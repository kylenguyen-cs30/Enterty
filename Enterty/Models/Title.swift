import Foundation

// MARK: - Models/Title.swift

struct Title: Identifiable, Codable {
    let title_id: Int
    let title_name: String
    let category: CategoryType
    let title_cover: String
    let date_started: String?
    let date_ended: String?
    let complete_counter: Int

    var id: Int { title_id }
}

extension Title: Hashable {}
