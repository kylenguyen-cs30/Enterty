//
//  HistoryTitleRow.swift
//  Enterty
//
//  Created by Panda Sama on 12/2/24.
//

import SwiftUI

struct HistoryTitleRow: View {
    let title: Title
    let tracking: TrackedTitle

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                ImageLoaderView(urlString: title.title_cover)
                    .frame(width: 60, height: 90)
                    .cornerRadius(8)
                    .background(Color.gray.opacity(0.2))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title.title_name)  // Fixed property name
                        .font(.headline)

                    Text(title.category.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(DateUtils.completionStatus(for: tracking))
                        .font(.caption)
                        .foregroundColor(.green)
                }

                Spacer()
            }
        }
        .padding(.vertical, 8)
    }
}
