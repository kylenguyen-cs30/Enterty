//
//  TrackedTitleRow.swift
//  Enterty
//
//  Created by Panda Sama on 12/2/24.
//

import Foundation
import SwiftUI

struct TrackedTitleRow: View {
    let title: Title
    let tracked: TrackedTitle
    let onStatusUpdate: (String) -> Void

    // add a date formatter
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    // Add a helper function to format the date string
    private func formatDateString(_ dateString: String) -> String {
        if let date = ISO8601DateFormatter().date(from: dateString) {
            return dateFormatter.string(from: date)
        }
        return dateString
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                ImageLoaderView(urlString: title.title_cover)
                    .frame(width: 60, height: 90)
                    .cornerRadius(8)
                    .background(Color.gray.opacity(0.2))

                VStack(alignment: .leading) {
                    // Title name
                    Text(title.title_name)
                        .font(.headline)
                    // Date started
                    Text("Started: \(formatDateString(tracked.date_started))")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    // show completion status if
                    if tracked.status == "finished" {
                        let status = DateUtils.completionStatus(for: tracked)
                        Text(status)
                            .font(.caption)
                            .foregroundColor(.green)
                            .onAppear {
                                print("Completion status: \(status)") // debut print
                                print("Title Status: \(tracked.status)")
                                print("End date:  \(String(describing: tracked.date_ended))")
                            }
                    }
                }

                Spacer()

                if tracked.status == "active" {
                    Menu {
                        Button("Stop Tracking") {
                            onStatusUpdate("stopped")
                        }
                        Button("Mark as Finished") {
                            print("Marking as finished")

                            onStatusUpdate("finished")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#if DEBUG
    struct TrackedTitleRow_Previews: PreviewProvider {
        static var previews: some View {
            let sampleTitle = Title(
                title_id: 1,
                title_name: "Sample Title",
                category: .Movie,
                title_cover: "movies/1-movie.png",
                date_started: "2024-01-01T00:00:00Z",
                date_ended: nil,
                complete_counter: 0
            )
            let sampleTracking = TrackedTitle(
                tracking_id: 1, title_id: 1, date_started: "2024-01-01T00:00:00Z",
                date_ended: "2024-01-01T00:00:00Z", status: "finished"
            )
            TrackedTitleRow(
                title: sampleTitle, tracked: sampleTracking,
                onStatusUpdate: {
                    _ in
                }
            ).previewLayout(.sizeThatFits).padding()
        }
    }
#endif
