//
//  TitleImageView.swift
//  Enterty
//
//  Created by Panda Sama on 12/2/24.
//

import Foundation
import SwiftUI

struct TitleImageView: View {
    @StateObject private var imageLoader = ImageLoader()
    let imageUrl: String

    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            imageLoader.loadImage(from: imageUrl)
        }
    }
}
