//
//  TitleViewModel.swift
//  Stuffy
//
//  Created by Panda Sama on 12/2/24.
//

import Combine
import CoreData
import Foundation
import SwiftUI

class TitleViewModel: ObservableObject {
    @Published var titles: [Title] = []
    @Published var trackedTitles: [TrackedTitle] = []
    private let baseURL = "http://localhost:8000"

    init() {
        fetchTitles()
        fetchTrackedTitles()
    }

    func fetchTitles() {
        guard let url = URL(string: "\(baseURL)/titles") else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let data = data {
                do {
                    let titles = try JSONDecoder().decode([Title].self, from: data)
                    DispatchQueue.main.async {
                        self?.titles = titles
                        print("Fetched \(titles.count) titles")
                    }
                } catch {
                    print("Decoding error: \(error)")
                }
            }
        }.resume()
    }

    func startTracking(titleId: Int) {
        Task {
            do {
                let newTracking = try await APIService.shared.startTracking(titleId: titleId)
                await MainActor.run {
                    print("Started tracking title ID: \(titleId)")
                    trackedTitles.append(newTracking)

                    // refresh both list
                    self.fetchTrackedTitles()
                }
            } catch {
                print("Error starting tracking: \(error)")
            }
        }
    }

    func updateTitleStatus(trackingId: Int, status: String) {
        Task {
            do {
                print("Updating status for tracking ID: \(trackingId) to \(status)")
                let updatedTracking = try await APIService.shared.updateTrackingStatus(
                    trackingId: trackingId,
                    status: status
                )

                await MainActor.run {
                    // Update immediately for UI responsiveness
                    if let index = trackedTitles.firstIndex(where: { $0.tracking_id == trackingId }) {
                        trackedTitles[index] = updatedTracking
                        print("Updated tracking status locally")
                    }

                    // Then refresh both lists to ensure consistency
                    self.fetchTrackedTitles()
                    // Delay the fetch slightly to ensure the server has processed the update
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.fetchTrackedTitles()
                    }
                }
            } catch {
                print("Error updating tracking status: \(error)")
            }
        }
    }

    func fetchTrackedTitles() {
        Task {
            do {
                let tracked = try await APIService.shared.fetchTrackedTitles()
                await MainActor.run {
                    trackedTitles = tracked
                    print("Fetched \(tracked.count) tracked titles")

                    // Debug print tracked titles details
                    for title in tracked {
                        print(
                            "Title ID: \(title.title_id), Status: \(title.status), End Date: \(String(describing: title.date_ended))"
                        )
                    }
                }
            } catch {
                print("Error fetching tracked titles: \(error)")
            }
        }
    }
}
