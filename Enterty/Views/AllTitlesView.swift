// AllTitlesView.swift
//  Enterty
//
//  Created by Panda Sama on 12/2/24.
//

import Foundation
import SwiftUI

struct AllTitlesView: View {
    @ObservedObject var viewModel: TitleViewModel
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            ZStack {
                if isLoading {
                    ProgressView("Loading titles...")
                } else if let error = errorMessage {
                    VStack {
                        Text("Error: \(error)")
                        Button("Retry") {
                            viewModel.fetchTitles()
                        }
                    }
                } else {
                    List {
                        ForEach(
                            viewModel.titles.filter { title in
                                searchText.isEmpty ? true : title.title_name.contains(searchText)
                            }, id: \.self
                        ) { title in
                            TitleRow(
                                title: title,
                                isTracking: viewModel.trackedTitles.contains {
                                    $0.title_id == title.title_id && $0.status == "active"
                                },
                                trackedTitles: viewModel.trackedTitles,
                                onTrackingTapped: {
                                    viewModel.startTracking(titleId: title.title_id)
                                }
                            )
                        }
                    }
                }
            }
            .navigationTitle("Available Titles")
            .searchable(text: $searchText)
            .onAppear {
                viewModel.fetchTrackedTitles() // Refresh tracked titles when view appears
            }
        }
    }
}
