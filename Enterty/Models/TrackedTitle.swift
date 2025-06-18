import Foundation

struct TrackedTitle: Identifiable, Codable {
    let tracking_id: Int
    let title_id: Int
    let date_started: String
    var date_ended: String?
    var status: String

    var id: Int { tracking_id }

    /*
     CodingKey: giao thức đặc biệt trong Swift, dùng khi bạn muốn tuỳ chỉnh
     cách các thuộc tính của struct/class được mã hoá (encode) hoặc giải mã
     (decode) với các định dạng như JSON, Property List,...
     */
    enum CodingKeys: String, CodingKey {
        case tracking_id
        case title_id
        case date_started
        case date_ended
        case status
    }
}

enum TrackingStatus: String, Codable {
    case active
    case stopped
    case finished
}

extension TrackedTitle: Hashable {}
