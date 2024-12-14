//
//  ImageLoader.swift
//  Stuffy
//
//  Created by Panda Sama on 12/2/24.
//

import Foundation
import SwiftUI
import UIKit

// indicator that this class only running on
// MainActor
@MainActor
class ImageLoader: ObservableObject {
    // Observable property to hold the loaded image
    @Published var image: UIImage?
    private let cache = NSCache<NSString, UIImage>()

    func loadImage(from urlString: String) {
        // Create a unique key for caching based on the url string
        let cacheKey = NSString(string: urlString)

        if let cachedImage = cache.object(forKey: cacheKey) {
            image = cachedImage
            return
        }

        Task {
            do {
                let imageData = try await APIService.shared.fetchImage(from: urlString)
                if let uiImage = UIImage(data: imageData) {
                    self.cache.setObject(uiImage, forKey: cacheKey)
                    self.image = uiImage
                }
            } catch {
                print("Error loading image: \(error)")
            }
        }
    }
}

// Add a convenience Image view for SwiftUI
struct ImageLoaderView: View {
    @StateObject private var imageLoader = ImageLoader()
    let urlString: String

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
            imageLoader.loadImage(from: urlString)
        }
    }
}
