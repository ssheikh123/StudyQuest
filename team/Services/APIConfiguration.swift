import Foundation

struct APIConfiguration {
    let apiKey: String
    let model: String
    let timeoutInterval: TimeInterval
    let maxRetryCount: Int

    static func development() throws -> APIConfiguration {
        guard let apiKey = Self.firstValue(for: ["GEMINI_API_KEY", "GOOGLE_API_KEY", "API_KEY"]), !apiKey.isEmpty else {
            throw OpenAIServiceError.invalidAPIKey
        }

        return APIConfiguration(
            apiKey: apiKey,
            model: Self.firstValue(for: ["GEMINI_MODEL", "GOOGLE_AI_MODEL"]) ?? "gemini-3.1-flash-lite",
            timeoutInterval: 30,
            maxRetryCount: 2
        )
    }

    private static func firstValue(for keys: [String]) -> String? {
        for key in keys {
            if let value = value(for: key) {
                return value
            }
        }
        return nil
    }

    private static func value(for key: String) -> String? {
        if let value = ProcessInfo.processInfo.environment[key], !value.isEmpty {
            return value
        }

        if let value = Bundle.main.object(forInfoDictionaryKey: key) as? String, !value.isEmpty {
            return value
        }

        return nil
    }
}
