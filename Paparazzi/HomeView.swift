import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: QuoteViewModel
    
    init(apiKey: String, modelContext: ModelContext) {
        _viewModel = State(initialValue: QuoteViewModel(modelContext: modelContext, apiKey: apiKey))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    Text("Paparazzi")
                        .font(.system(size: 50, weight: .bold))
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.bottom, 20)
                    
                    VStack(spacing: 20) {
                        TextField("Celebrity's Name", text: $viewModel.celebrity)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disabled(viewModel.isLoading)
                            .multilineTextAlignment(.center)
                        
                        TextField("Subject", text: $viewModel.subject)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disabled(viewModel.isLoading)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            Task {
                                await viewModel.generateQuote()
                            }
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            } else {
                                Text("Generate Quote")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .disabled(viewModel.isLoading)
                        
                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .navigationTitle("Quote Generator")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
} 
