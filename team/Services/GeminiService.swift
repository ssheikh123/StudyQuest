import Foundation

// User-facing AI failures are normalized here so the chat UI never has to understand
// raw networking errors, HTTP status codes, or provider-specific Gemini messages.
enum GeminiServiceError: LocalizedError, Equatable {
    case invalidAPIKey
    case noInternet
    case timeout
    case rateLimited
    case unavailable
    case cancelled
    case emptyResponse
    case requestFailed(String)

    var errorDescription: String? {
        switch self {
        case .invalidAPIKey:
            return "The AI tutor is not configured yet. Check the Gemini API key in the development configuration."
        case .noInternet:
            return "The AI tutor needs an internet connection. Check your connection and try again."
        case .timeout:
            return "The AI tutor took too long to respond. Try again in a moment."
        case .rateLimited:
            return "The AI tutor is receiving too many requests right now. Please wait a bit and try again."
        case .unavailable:
            return "The AI tutor is temporarily unavailable. Try again soon."
        case .cancelled:
            return "The request was cancelled."
        case .emptyResponse:
            return "The AI tutor returned an empty response. Try asking another way."
        case .requestFailed(let message):
            return message
        }
    }
}

// Gemini-backed networking for the AI tutor. The rest of the app depends on this
// small send(request:) API instead of knowing about Gemini request/response details.
struct GeminiService {
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()

    private let configuration: APIConfiguration
    private let session: URLSession

    init(configuration: APIConfiguration, session: URLSession? = nil) {
        self.configuration = configuration
        if let session {
            self.session = session
        } else {
            let sessionConfiguration = URLSessionConfiguration.default
            sessionConfiguration.timeoutIntervalForRequest = configuration.timeoutInterval
            sessionConfiguration.timeoutIntervalForResource = configuration.timeoutInterval + 10
            self.session = URLSession(configuration: sessionConfiguration)
        }
    }

    // Sends a prompt to Gemini using what is included in the message to the AI.
    func send(request promptRequest: AIPromptRequest) async throws -> String {
        // PromptBuilder already optimized the lesson context and recent chat history.
        // This layer only translates that provider-agnostic prompt into Gemini's shape.
        let request = GeminiGenerateContentRequest(
            systemInstruction: GeminiContent(
                role: nil,
                parts: [GeminiPart(text: promptRequest.instructions)]
            ),
            contents: promptRequest.input.map(GeminiContent.init(message:)),
            generationConfig: GeminiGenerationConfig(
                // Higher temperature for more creative responses, lower for direct
                // More output tokens for more words output
                temperature: 0.55,
                maxOutputTokens: 320
            )
        )

        
        var lastError: Error?
        // Exponential backoff handles temporary Gemini/API/network problems without
        // making the student manually retry every transient failure.
        for attempt in 0...configuration.maxRetryCount {
            do {
                return try await perform(request)
            } catch {
                let serviceError = mapError(error)
                guard shouldRetry(serviceError), attempt < configuration.maxRetryCount else {
                    throw serviceError
                }
                lastError = serviceError
                try await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(attempt)) * 500_000_000))
            }
        }

        throw mapError(lastError ?? GeminiServiceError.unavailable)
    }

    private func perform(_ body: GeminiGenerateContentRequest) async throws -> String {
        // This is the only place that performs network I/O for the tutor, keeping
        // SwiftUI views and managers free of URLSession and provider details.
        var urlRequest = URLRequest(url: try endpointURL())
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try Self.encoder.encode(body)

        let (data, response) = try await session.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GeminiServiceError.unavailable
        }

        // Map HTTP responses into the app's stable error language so the rest of
        // StudyQuest behaves the same even if the AI provider changes again later.
        switch httpResponse.statusCode {
        case 200..<300:
            let decoded = try Self.decoder.decode(GeminiGenerateContentResponse.self, from: data)
            guard let outputText = decoded.resolvedText?.trimmingCharacters(in: .whitespacesAndNewlines), !outputText.isEmpty else {
                throw GeminiServiceError.emptyResponse
            }
            return outputText
        case 400:
            let apiError = try? Self.decoder.decode(GeminiErrorResponse.self, from: data)
            throw GeminiServiceError.requestFailed(apiError?.error.message ?? "The AI tutor could not complete that request.")
        case 401, 403:
            throw GeminiServiceError.invalidAPIKey
        case 408:
            throw GeminiServiceError.timeout
        case 429:
            throw GeminiServiceError.rateLimited
        case 500..<600:
            throw GeminiServiceError.unavailable
        default:
            let apiError = try? Self.decoder.decode(GeminiErrorResponse.self, from: data)
            throw GeminiServiceError.requestFailed(apiError?.error.message ?? "The AI tutor could not complete that request.")
        }
    }

    private func endpointURL() throws -> URL {
        // URLComponents avoids fragile string interpolation for the API key query item.
        var components = URLComponents()
        components.scheme = "https"
        components.host = "generativelanguage.googleapis.com"
        components.path = "/v1beta/models/\(configuration.model):generateContent"
        components.queryItems = [URLQueryItem(name: "key", value: configuration.apiKey)]

        guard let url = components.url else {
            throw GeminiServiceError.requestFailed("The AI tutor could not build a Gemini request.")
        }
        return url
    }

    private func mapError(_ error: Error) -> GeminiServiceError {
        // URLSession and Gemini can fail in many different ways; the UI only needs
        // a small set of clear, student-friendly states.
        if let serviceError = error as? GeminiServiceError {
            return serviceError
        }

        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost, .cannotFindHost, .cannotConnectToHost:
                return .noInternet
            case .timedOut:
                return .timeout
            case .cancelled:
                return .cancelled
            default:
                return .unavailable
            }
        }

        if error is CancellationError {
            return .cancelled
        }

        return .unavailable
    }

    private func shouldRetry(_ error: GeminiServiceError) -> Bool {
        switch error {
        case .timeout, .rateLimited, .unavailable, .noInternet:
            return true
        case .invalidAPIKey, .cancelled, .emptyResponse, .requestFailed:
            return false
        }
    }
}

struct AIPromptRequest {
    let instructions: String
    let input: [ResponsesInputMessage]
}

struct ResponsesInputMessage: Codable, Equatable {
    let role: String
    let content: String
}

@available(*, deprecated, renamed: "GeminiService")
typealias OpenAIService = GeminiService

@available(*, deprecated, renamed: "GeminiServiceError")
typealias OpenAIServiceError = GeminiServiceError

private struct GeminiGenerateContentRequest: Encodable {
    let systemInstruction: GeminiContent
    let contents: [GeminiContent]
    let generationConfig: GeminiGenerationConfig
}

private struct GeminiContent: Codable {
    let role: String?
    let parts: [GeminiPart]

    init(role: String?, parts: [GeminiPart]) {
        self.role = role
        self.parts = parts
    }

    init(message: ResponsesInputMessage) {
        role = message.role == "assistant" ? "model" : "user"
        parts = [GeminiPart(text: message.content)]
    }

    enum CodingKeys: String, CodingKey {
        case role
        case parts
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(role, forKey: .role)
        try container.encode(parts, forKey: .parts)
    }
}

private struct GeminiPart: Codable {
    let text: String?
}

private struct GeminiGenerationConfig: Codable {
    let temperature: Double
    let maxOutputTokens: Int
}

private struct GeminiGenerateContentResponse: Decodable {
    let candidates: [GeminiCandidate]?

    var resolvedText: String? {
        candidates?
            .flatMap { $0.content?.parts ?? [] }
            .compactMap(\.text)
            .joined(separator: "\n")
    }
}

private struct GeminiCandidate: Decodable {
    let content: GeminiContent?
}

private struct GeminiErrorResponse: Decodable {
    let error: GeminiAPIError
}

private struct GeminiAPIError: Decodable {
    let code: Int?
    let message: String
    let status: String?
}
