import SwiftUI

@Observable
class QuoteDetailViewModel {
    private let chatGPTService: ChatGPTService
    private let quote: Quote
    
    var story: String = ""
    var isLoadingStory: Bool = false
    var errorMessage: String = ""
    
    init(quote: Quote, apiKey: String) {
        self.quote = quote
        self.chatGPTService = ChatGPTService(apiKey: apiKey)
    }
    
    func generateStory() async {
        isLoadingStory = true
        errorMessage = ""
        
        do {
            let prompt = "Tell me an inspirational story about \(quote.celebrity). Make it engaging, motivational, and short."
            story = try await chatGPTService.generateResponse(prompt: prompt)
        } catch {
            errorMessage = "Failed to generate story: \(error.localizedDescription)"
        }
        
        isLoadingStory = false
    }
} 
