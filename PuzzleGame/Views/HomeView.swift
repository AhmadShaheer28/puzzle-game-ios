//
//  HomeView.swift
//  PuzzleGame
//
//  Created by Ahmad Shaheer on 07/06/2024.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct HomeView: View {
    
    @State private var orderedTiles: [[UIImage]] = []
    @State private var shuffledTiles: [[UIImage]] = []
    @State private var puzzleImage: UIImage = UIImage()
    @State private var userWon = false
    @State private var loadedPuzzle = false
    @State private var showHint = false
    @State private var moves = 0
    @State private var draggingItem: (row: Int, col: Int)? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                
                if loadedPuzzle {
                    
                    HStack {
                        movesCountView()
                        Spacer()
                        puzzleHintToggleView()
                    }
                    .padding([.top, .horizontal], 20)
                    
                    puzzleHintView(puzzleImage)
                    
                    
                    PuzzleView(orderedTiles: $orderedTiles, shuffledTiles: $shuffledTiles, userWon: $userWon, moves: $moves, draggingItem: $draggingItem)
                        .padding()
                    
                } else {
                    LoaderView(text: "Loading...")
                }
            }
            .alert("You Win 🏆", isPresented: $userWon) {}
            .background {
                Color.screenBackground
                    .ignoresSafeArea()
            }
            .task {
                await loadPuzzleImage()
            }
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    titleView()
                }
            })
        }
    }
    
    @ViewBuilder private func movesCountView() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                    .resizable()
                    .frame(width: 32, height: 32)
                Text("\(moves)")
                    .font(.subHeading)
            }
        }
        .foregroundStyle(Color.pinkColor)
    }
    
    @ViewBuilder private func puzzleHintToggleView() -> some View {
        VStack {
            Button(action: {
                withAnimation {
                    showHint.toggle()
                }
            }, label: {
                Image(systemName: showHint ? "eye.circle.fill" : "eye.slash.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
            })
        }
        .foregroundStyle(Color.pinkColor)
    }
    
    @ViewBuilder private func titleView() -> some View {
        HStack {
            Text("Puzzle Game")
                .font(.custom("Noteworthy Bold", fixedSize: 35))
        }
        .foregroundLinearGradient(colors: [Color.purpleColor, Color.pinkColor], startPoint: .top, endPoint: .bottom)
    }
    
    @ViewBuilder private func puzzleHintView(_ image: UIImage) -> some View {
        if showHint {
            Image(uiImage: image)
                .resizable()
                .frame(width: 200, height: 200)
                .animation(.linear, value: showHint)
        }
    }
    
    private func loadPuzzleImage() async {
        do {
            
            let (image, tiles) = try await PuzzleLoader().loadPuzzle()
            puzzleImage = image
            orderedTiles = tiles.0
            shuffledTiles = tiles.1
            
            loadedPuzzle = true
        }
        catch {
            loadedPuzzle = false
            print(error.localizedDescription)
        }
    }
    
    private func reset() {
        moves = 0
        userWon = false
        loadedPuzzle = false
        puzzleImage = UIImage()
        orderedTiles = []
        shuffledTiles = []
    }

}

#Preview {
    HomeView()
}
