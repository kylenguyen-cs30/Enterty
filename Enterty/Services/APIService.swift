//
//  APIService.swift
//  Entery
//
//  Created by Panda Sama on 12/2/24.
//

import Foundation

// MARK: - Services/APIService.swift

class APIService {
    static let shared = APIService()
    private let baseURL = "http://localhost:8000"

    // NOTE: fetch all titles
    func fetchTitles() async throws -> [Title] {
        guard let url = URL(string: "\(baseURL)/titles") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
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
    private let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()

        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    //  NOTE: Add Function to start tracking
    func startTracking(titleId: Int) async throws -> TrackedTitle {
        guard let url = URL(string: "\(baseURL)/tracking") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create proper tracking request body
        struct TrackingRequest: Codable {
            let title_id: Int
            let status: String
        }

        let trackingRequest = TrackingRequest(title_id: titleId, status: "active")
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(trackingRequest)

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
