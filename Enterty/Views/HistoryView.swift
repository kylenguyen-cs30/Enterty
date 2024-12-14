//
//  HistoryView.swift
//  Enterty
//
//  Created by Panda Sama on 13/2/24.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: TitleViewModel

    private var finishedTitles: [TrackedTitle] {
        viewModel.trackedTitles.filter { $0.status == "finished" }.sorted {
            ($0.date_ended ?? "") > ($1.date_ended ?? "")
        }
    }

    private func findTitle(for tracked: TrackedTitle) -> Title? {
        viewModel.titles.first { $0.title_id == tracked.title_id }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(finishedTitles) { tracking in
                    if let title = findTitle(for: tracking) {
                        HistoryTitleRow(title: title, tracking: tracking)

                    }

                }

            }.navigationBarTitle("History")
                .refreshable {
                    viewModel.fetchTrackedTitles()
                }
        }
    }
}
