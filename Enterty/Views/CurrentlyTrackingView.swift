//
//  CurrentlyTrackingView.swift
//  Enterty
//
//  Created by Panda Sama on 13/2/24.
//

import Foundation
import SwiftUI

struct CurrentlyTrackingView: View {
    @ObservedObject var viewModel: TitleViewModel

    private var activeTrackedTitles: [TrackedTitle] {
        // Only show active titles, and take most recent tracking for each title
        let groupedByTitleId = Dictionary(
            grouping: viewModel.trackedTitles.filter { $0.status == "active" }
        ) { $0.title_id }
        return groupedByTitleId.compactMap { _, trackings in
            trackings.sorted { $0.date_started > $1.date_started }.first
        }
    }

    private func findTitle(for tracked: TrackedTitle) -> Title? {
        viewModel.titles.first { $0.title_id == tracked.title_id }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(activeTrackedTitles) { tracked in
                    if let title = findTitle(for: tracked) {
                        // NOTE: Component for designing
                        TrackedTitleRow(
                            title: title,
                            tracked: tracked,
                            onStatusUpdate: { status in
                                print("Updating status to: \(status)")

                                viewModel.updateTitleStatus(
                                    trackingId: tracked.tracking_id, // Use tracking_id instead of title_id
                                    status: status
                                )
                            }
                        )
                    }
                }
            }
            .navigationTitle("Currently Tracking")
            .refreshable {
                viewModel.fetchTrackedTitles()
            }
        }
    }
}
