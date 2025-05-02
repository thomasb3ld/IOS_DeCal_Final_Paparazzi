import SwiftUI
import SwiftData

struct QuotesListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Quote.timestamp, order: .reverse) private var quotes: [Quote]
    let apiKey: String
    
    // Calculate available height for quotes
    private let screenHeight = UIScreen.main.bounds.height
    private var quoteHeight: CGFloat {
        // Reserve ~20% of screen height for each quote, max 5 quotes
        min(screenHeight * 0.18, screenHeight / 5)
    }
    
    var body: some View {
        NavigationStack {
            if quotes.isEmpty {
                ContentUnavailableView("No Quotes Yet", 
                    systemImage: "quote.bubble",
                    description: Text("Generate your first quote in the Generate tab"))
            } else {
                List {
                    ForEach(quotes) { quote in
                        NavigationLink(destination: QuoteDetailView(quote: quote, apiKey: apiKey)) {
                            QuoteCard(quote: quote)
                                .frame(height: quoteHeight)
                        }
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: deleteQuotes)
                }
                .listStyle(.plain)
                .navigationTitle("Saved Quotes")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    private func deleteQuotes(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(quotes[index])
        }
    }
}

// Separate card view for better organization
struct QuoteCard: View {
    let quote: Quote
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(quote.content)
                .font(.system(size: 16, weight: .regular))
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 4)
            
            HStack {
                Text("- \(quote.celebrity)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("on \(quote.subject)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
        )
    }
} 