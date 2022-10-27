// UIImageView+Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Extension for update image in imageView
extension UIImageView {
    func getImageData(url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.image = image
                }
            }
        }.resume()
    }
}
