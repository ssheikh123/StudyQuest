import Foundation

struct SparkConversation: Codable, Equatable {
    var messages: [SparkMessage] = [
        SparkMessage(role: .spark, text: "Hi! I'm Spark. Ask me for a hint, an easier example, or help understanding a lesson.")
    ]
}
