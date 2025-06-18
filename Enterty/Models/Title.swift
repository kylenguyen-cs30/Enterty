import Foundation

// MARK: - Models/Title.swift

/*
 Identifiable : list protocol for ID object. requirement : we need to have "id" attribute. Identifiable
 is used to tell the different elements in a list.

 Codable: combination of Encoable and Decoable. requirement: none. help us to format the data such as JSON,
 Property List,...
 */

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

/*
 câu lệnh trong swift có nghĩa là mình mở rộng Title và tuân thủ protocol Hashable

 Hashable : một protocol cho phép các đối tượng(object) có thể sinh ra một giá trị Hash để
 sử dụng trong các cấu trúc dữ liệu như Set hoặc là key cho Dictionary.

 khi một struct/class tuân thủ Hashable, Swift tự động tạo ra các hàm cần thiết, nên bạn hông
 cần phải tự viết code sinh hash

 */
extension Title: Hashable {}
