import Foundation

struct Book: Identifiable, Codable, Sendable {
    let id: UUID
    let title: String
    let author: String
    let pageCount: Int
    let publishedYear: Int
    let genre: String
    let rating: Double
    let description: String
    let imageURL: String
}
