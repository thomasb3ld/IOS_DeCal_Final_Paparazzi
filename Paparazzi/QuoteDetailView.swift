import SwiftUI
import SwiftData

struct QuoteDetailView: View {
    let quote: Quote
    @State private var viewModel: QuoteDetailViewModel
    @State private var showingStory = false
    
    init(quote: Quote, apiKey: String) {
        self.quote = quote
        _viewModel = State(initialValue: QuoteDetailViewModel(quote: quote, apiKey: apiKey))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                // Quote Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Quote")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(quote.content)
                        .font(.title3)
                        .italic()
                    
                    HStack {
                        Text("- \(quote.celebrity)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text("on \(quote.subject)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // Story Section
                VStack(alignment: .leading, spacing: 16) {
                    if !showingStory {
                        Button(action: {
                            showingStory = true
                            Task {
                                await viewModel.generateStory()
                            }
                        }) {
                            Text("Generate Story")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .disabled(viewModel.isLoadingStory)
                    } else {
                        Text("Story")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        if viewModel.isLoadingStory {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .foregroundColor(.red)
                        } else {
                            Text(viewModel.story)
                                .font(.body)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
            }
            .padding()
        }
        .navigationTitle("Quote Details")
        .navigationBarTitleDisplayMode(.inline)
    }
} 