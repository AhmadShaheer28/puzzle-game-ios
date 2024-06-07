//
//  PuzzleLoader.swift
//  PuzzleGame
//
//  Created by Ahmad Shaheer on 07/06/2024.
//

import Foundation
import SwiftUI

struct PuzzleLoader {
    private let urlString = "https://picsum.photos/1024"
    func loadPuzzle() async throws -> (UIImage, ([[UIImage]], [[UIImage]])) {
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Error in URL conversion", code: 0, userInfo: nil)
        }
        var imageData: Data?
        
        if Reachability.isConnectedToNetwork() {
            let (data, _) = try await URLSession.shared.data(from: url)
            imageData = data
        } else {
            imageData = UIImage(named: "off_net_img")?.jpegData(compressionQuality: 1.0)
        }
        
        guard let imageData else { throw NSError(domain: "Error unwrapping image data", code: 2, userInfo: nil) }
        
        guard let inputImage = UIImage(data: imageData),
              let croppedImage = cropImageForPuzzle(image: inputImage) else {
            throw NSError(domain: "Error loading image", code: 3, userInfo: nil)
        }

        let tiles = tilesFromImage(image: croppedImage, size: CGSize(width: croppedImage.size.width/3, height: croppedImage.size.height/3))
        return (croppedImage, tiles)
    }
    
    private func cropImageForPuzzle(image: UIImage) -> UIImage? {
        let minLength = min(image.size.width, image.size.height)
        let x = image.size.width / 2 - minLength / 2
        let y = image.size.height / 2 - minLength / 2
        let croppingRect = CGRect(x: x, y: y, width: minLength, height: minLength)
        
        if let croppedCGImage = image.cgImage?.cropping(to: croppingRect) {
            return UIImage(cgImage: croppedCGImage, scale: image.scale, orientation: image.imageOrientation)
        }
        return nil
    }
    
    private func tilesFromImage(image: UIImage, size: CGSize) -> ([[UIImage]], [[UIImage]]) {
        let hRowCount = Int(image.size.width / size.width)
        let vRowCount = Int(image.size.height / size.height)
        let tileSideLength = size.width
        
        var tiles = [[UIImage]](repeating: [], count: vRowCount)
        for vIndex in 0..<vRowCount {
            for hIndex in 0..<hRowCount {
                let imagePoint = CGPoint(x: CGFloat(hIndex) * tileSideLength * -1, y: CGFloat(vIndex) * tileSideLength * -1)
                UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                image.draw(at: imagePoint)
                if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
                    tiles[vIndex].append(newImage)
                }
                UIGraphicsEndImageContext()
            }
        }
        
        var iterator = tiles.joined().shuffled().makeIterator()
        let shuffledTiles = tiles.map { $0.compactMap { _ in iterator.next() }}
        return (tiles, shuffledTiles)
    }
}
