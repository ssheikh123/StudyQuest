import Foundation

enum OpenAIServiceError: LocalizedError, Equatable {
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

struct OpenAIService {
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

    func send(request promptRequest: AIPromptRequest) async throws -> String {
        let request = GeminiGenerateContentRequest(
            systemInstruction: GeminiContent(
                role: nil,
                parts: [GeminiPart(text: promptRequest.instructions)]
            ),
            contents: promptRequest.input.map(GeminiContent.init(message:)),
            generationConfig: GeminiGenerationConfig(
                temperature: 0.55,
                maxOutputTokens: 320
            )
        )

        var lastError: Error?
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

        throw mapError(lastError ?? OpenAIServiceError.unavailable)
    }

    private func perform(_ body: GeminiGenerateContentRequest) async throws -> String {
        var urlRequest = URLRequest(url: try endpointURL())
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try Self.encoder.encode(body)

        let (data, response) = try await session.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw OpenAIServiceError.unavailable
        }

        switch httpResponse.statusCode {
        case 200..<300:
            let decoded = try Self.decoder.decode(GeminiGenerateContentResponse.self, from: data)
            guard let outputText = decoded.resolvedText?.trimmingCharacters(in: .whitespacesAndNewlines), !outputText.isEmpty else {
                throw OpenAIServiceError.emptyResponse
            }
            return outputText
        case 400:
            let apiError = try? Self.decoder.decode(GeminiErrorResponse.self, from: data)
            throw OpenAIServiceError.requestFailed(apiError?.error.message ?? "The AI tutor could not complete that request.")
        case 401, 403:
            throw OpenAIServiceError.invalidAPIKey
        case 408:
            throw OpenAIServiceError.timeout
        case 429:
            throw OpenAIServiceError.rateLimited
        case 500..<600:
            throw OpenAIServiceError.unavailable
        default:
            let apiError = try? Self.decoder.decode(GeminiErrorResponse.self, from: data)
            throw OpenAIServiceError.requestFailed(apiError?.error.message ?? "The AI tutor could not complete that request.")
        }
    }

    private func endpointURL() throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "generativelanguage.googleapis.com"
        components.path = "/v1beta/models/\(configuration.model):generateContent"
        components.queryItems = [URLQueryItem(name: "key", value: configuration.apiKey)]

        guard let url = components.url else {
            throw OpenAIServiceError.requestFailed("The AI tutor could not build a Gemini request.")
        }
        return url
    }

    private func mapError(_ error: Error) -> OpenAIServiceError {
        if let serviceError = error as? OpenAIServiceError {
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

    private func shouldRetry(_ error: OpenAIServiceError) -> Bool {
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
