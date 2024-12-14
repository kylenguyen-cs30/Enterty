//
//  ContentView.swift
//  Enterty
//
//  Created by Panda Sama on 12/2/24.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TitleViewModel()

    var body: some View {
        TabView {
            AllTitlesView(viewModel: viewModel)
                .tabItem {
                    Label("All Titles", systemImage: "list.bullet")
                }

            CurrentlyTrackingView(viewModel: viewModel)
                .tabItem {
                    Label("Tracking", systemImage: "star.fill")
                }

            HistoryView(viewModel: viewModel)
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
        }
        .onAppear {
            viewModel.fetchTitles()
        }
    }
}
