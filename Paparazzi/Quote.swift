import Foundation
import SwiftData

@Model
final class Quote {
    var celebrity: String
    var subject: String
    var content: String
    var timestamp: Date
    
    init(celebrity: String, subject: String, content: String) {
        self.celebrity = celebrity
        self.subject = subject
        self.content = content
        self.timestamp = Date()
    }
} 