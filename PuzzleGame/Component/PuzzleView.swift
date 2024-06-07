//
//  PuzzleView.swift
//  PuzzleGame
//
//  Created by Ahmad Shaheer on 08/06/2024.
//

import SwiftUI

struct PuzzleView: View {
    @Binding var orderedTiles: [[UIImage]]
    @Binding var shuffledTiles: [[UIImage]]
    @Binding var userWon: Bool
    @Binding var moves: Int
    @Binding var draggingItem: (row: Int, col: Int)?
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<3, id: \.self) { column in
                            let image = shuffledTiles[row][column]
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .draggable(image.pngData()!) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geo.size.width / 3, height: geo.size.width / 3)
                                        .onAppear {
                                            draggingItem = (row, column)
                                        }
                                }
                                .dropDestination(for: Data.self) { items, _ in
                                    if let item = items.first, let _ = UIImage(data: item), let draggingItem {
                                        let tempImage = shuffledTiles[draggingItem.row][draggingItem.col]
                                        shuffledTiles[draggingItem.row][draggingItem.col] = shuffledTiles[row][column]
                                        shuffledTiles[row][column] = tempImage
                                        
                                        moves += 1
                                        userWon = zip(shuffledTiles, orderedTiles).map({
                                            return $0.0 == $0.1
                                        }).allSatisfy({ $0 == true })
                                    }
                                    return true
                                }
                                .frame(width: geo.size.width / 3, height: geo.size.width / 3)
                        }
                    }
                    
                }
            }
        }
    }
}
