//
//  APIService.swift
//  Entery
//
//  Created by Panda Sama on 12/2/24.
//

import Foundation

// MARK: - Services/APIService.swift

class APIService {
    /*
     - static let là một biến tĩnh (static property) thuộc lớp struct/class
     - mục đích là đảm bảo chỉ có một instance của APIService tồn tại thay vì tạo nhiều lần
     */
    static let shared = APIService()
    private let baseURL = "http://localhost:8000"

    // NOTE: fetch all titles
    func fetchTitles() async throws -> [Title] {
        /*
         1. tạo URL
         - ghép chuỗi để tạo URL đến endpoint /titles của API
         - nếu không tạo được URL ném lỗi URLError
         */
        guard let url = URL(string: "\(baseURL)/titles") else {
            throw URLError(.badURL)
        }

        /*
         2. Gửi request lấy dữ liệu từ API (bất đồng bộ)
         - sử dụng URLSession.shared.data(from:url) để gửi HTTP GET đến URL vừa tạo
         */
        let (data, _) = try await URLSession.shared.data(from: url)

        /*
         3. Giải mả giữ liệu JSON cho đối tượng Title
         */
        return try JSONDecoder().decode([Title].self, from: data)
    }

    // NOTE: fetch all images
    func fetchImage(from urlString: String) async throws -> Data {
        guard let url = URL(string: "\(baseURL)/images/\(urlString)") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }

    // Format date
    /*
     Đoạn code này là một cách khai báo biến kiểu lazy
     - = { ... }() là một closure (giống như một hàm không tên)
     - () ở cuối closure nghĩa là closure này sẽ được thực thi ngay lập tức khi khai báo

     */
    private let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter() // tạo íntance
        /*
         thiết lập tuỳ chọn định dạng cho formatter :
         - .withInternetDateTime: định dạn ngày tháng theo kiểu Internet
         - .withFractionalSeconds: bao gồm cả phần giây thập phân
         */
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    //  NOTE: Add Function to start tracking
    func startTracking(titleId: Int) async throws -> TrackedTitle {
        guard let url = URL(string: "\(baseURL)/tracking") else {
            throw URLError(.badURL)
        }

        /*
         - Tạo một đối tượng URLRequest với URL vừa tạo
         - Đặt phương thức HTTP là POST
         - Đặt header Content-Type là application/json (nói với server rằng dữ liệu gửi lên là JSON )
         */

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create proper tracking request body
        /*
         - Khai báo một struct tạm thời TrackingRequest để tạo dữ liệu gửi lên Server
         - title_id : id của title
         - status: trạng thái theo dõi (ở đây là "active")
         */
        struct TrackingRequest: Codable {
            let title_id: Int
            let status: String
        }

        /*
         - tạo một instance của TrackingRequest với id truyền vào và status là "active".
         - tạo một JSONEncoder để mã hoá dữ liệu.
         - Encode trackingRequest thành JSON và gán vào phần thân (body) của request.
         */
        let trackingRequest = TrackingRequest(title_id: titleId, status: "active")
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(trackingRequest)

        /*
         - Gửi request lên server một cách bất đồng bộ
         - Nhận về dữ liệu trả về (data) và phản hồi (responses)
                 */
        let (data, response) = try await URLSession.shared.data(for: request)

        // Debug response
        if let httpResponse = response as? HTTPURLResponse {
            print("Response status code: \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response body: \(responseString)")
            }
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(TrackedTitle.self, from: data)
    }

    // Add function to fetch tracked titles
    func fetchTrackedTitles() async throws -> [TrackedTitle] {
        guard let url = URL(string: "\(baseURL)/tracking") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([TrackedTitle].self, from: data)
    }
}

extension APIService {
    // NOTE: Update tracking status for one title
    func updateTrackingStatus(trackingId: Int, status: String) async throws -> TrackedTitle {
        guard let url = URL(string: "\(baseURL)/tracking/\(trackingId)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create the update request body
        let body: [String: Any] = [
            "status": status,
            "date_ended": status == "finished" ? ISO8601DateFormatter().string(from: Date()) : nil,
        ].compactMapValues { $0 }

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(TrackedTitle.self, from: data)
    }
}
