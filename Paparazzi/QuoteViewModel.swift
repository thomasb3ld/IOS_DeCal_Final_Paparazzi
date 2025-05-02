import SwiftUI
import SwiftData

@Observable
class QuoteViewModel {
    private let modelContext: ModelContext
    private let apiKey: String
    private let chatGPTService: ChatGPTService
    
    var celebrity: String = ""
    var subject: String = ""
    var isLoading: Bool = false
    var errorMessage: String = ""
    
    init(modelContext: ModelContext, apiKey: String) {
        self.modelContext = modelContext
        self.apiKey = apiKey
        self.chatGPTService = ChatGPTService(apiKey: apiKey)
    }
    
    func generateQuote() async {
        guard !celebrity.isEmpty else {
            errorMessage = "Please enter a celebrity's name"
            return
        }
        
        guard !subject.isEmpty else {
            errorMessage = "Please enter a subject"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        do {
            let content = try await chatGPTService.generateQuote(celebrity: celebrity, subject: subject)
            let quote = Quote(celebrity: celebrity, subject: subject, content: content)
            modelContext.insert(quote)
            try modelContext.save()
            
            // Clear inputs
            celebrity = ""
            subject = ""
            
        } catch let error as ChatGPTError {
            switch error {
            case .apiError(let message):
                errorMessage = "API Error: \(message)"
            case .invalidResponse:
                errorMessage = "Invalid response from the server"
            case .networkError(let underlyingError):
                errorMessage = "Network error: \(underlyingError.localizedDescription)"
            }
        } catch {
            errorMessage = "Unexpected error: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
} 