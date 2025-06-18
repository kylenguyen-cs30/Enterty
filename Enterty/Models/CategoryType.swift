import Foundation

// MARK: - Models/CategoryType.swift

//
// model type for CategoryType
//     - to describe the type of title

enum CategoryType: String, Codable {
    case Game
    case Movie
    case TVShow
    case Book
}
