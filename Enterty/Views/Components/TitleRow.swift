//
//  TitleRow.swift
//  Enterty
//
//  Created by Panda Sama on 12/2/24.
//

import Foundation
import SwiftUI

struct TitleRow: View {
    let title: Title
    let isTracking: Bool
    let trackedTitles: [TrackedTitle]
    let onTrackingTapped: () -> Void

    private var lastFinishedTracking: TrackedTitle? {
        let finished =
            trackedTitles
                .filter { $0.title_id == title.title_id && $0.status == "finished" }
                .sorted { ($0.date_ended ?? "") > ($1.date_ended ?? "") }
                .first

        // Debug print
        print("Title: \(title.title_name)")
        print("Found finished tracking: \(finished != nil)")
        if let finished = finished {
            print("Status: \(finished.status)")
            print("End date: \(finished.date_ended ?? "nil")")
        }

        return finished
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                ImageLoaderView(urlString: title.title_cover)
                    .frame(width: 60, height: 90)
                    .cornerRadius(8)
                    .background(Color.gray.opacity(0.2))

                VStack(alignment: .leading) {
                    Text(title.title_name)
                        .font(.headline)
                    Text(title.category.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    if let lastFinished = lastFinishedTracking {
                        Text(DateUtils.completionStatus(for: lastFinished))
                            .font(.caption)
                            .foregroundColor(.green)
                            .onAppear {
                                print("Displaying completion status for \(title.title_name)")
                            }
                    }
                }

                Spacer()

                Button(action: onTrackingTapped) {
                    Text(isTracking ? "Tracking" : "Start Tracking")
                        .foregroundColor(isTracking ? .gray : .blue)
                }
                .disabled(isTracking)
            }
        }
        .padding(.vertical, 8)
    }
}
