import Foundation

enum ChatGPTError: Error {
    case invalidResponse
    case apiError(String)
    case networkError(Error)
}

class ChatGPTService {
    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func generateResponse(prompt: String) async throws -> String {
        let url = URL(string: baseURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "model": "gpt-4",
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7,
            "max_tokens": 500
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ChatGPTError.invalidResponse
            }
            
            if httpResponse.statusCode != 200 {
                // Try to parse error message from response
                if let errorResponse = try? JSONDecoder().decode(ChatGPTErrorResponse.self, from: data) {
                    throw ChatGPTError.apiError(errorResponse.error.message)
                } else {
                    throw ChatGPTError.apiError("API returned status code \(httpResponse.statusCode)")
                }
            }
            
            let apiResponse = try JSONDecoder().decode(ChatGPTResponse.self, from: data)
            guard let content = apiResponse.choices.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines) else {
                throw ChatGPTError.invalidResponse
            }
            
            return content
            
        } catch let error as ChatGPTError {
            throw error
        } catch {
            throw ChatGPTError.networkError(error)
        }
    }
    
    func generateQuote(celebrity: String, subject: String) async throws -> String {
        let prompt = "Generate a motivational quote about \(subject) in the style of \(celebrity). The quote should be concise and impactful. Only return the quote itself, no additional text."
        return try await generateResponse(prompt: prompt)
    }
}

struct ChatGPTResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
    }
    
    struct Message: Codable {
        let content: String
    }
}

struct ChatGPTErrorResponse: Codable {
    let error: APIError
    
    struct APIError: Codable {
        let message: String
    }
} 
