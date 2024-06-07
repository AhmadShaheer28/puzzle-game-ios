//
//  LoaderView.swift
//  AiArtGenerator
//
//  Created by Ahmad Shaheer on 19/04/2024.
//

import SwiftUI

struct LoaderView: View {
    
    @State var text: String = ""
    @State private var angle: Double = 0
    @State private var isAnimating = false
    
    private var rotateAnimation: Animation {
        Animation.linear(duration: 2.0).repeatForever(autoreverses: false)
    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            VStack {
                Image("ic_loader")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(isAnimating ? 360 : -360))
                    .animation(rotateAnimation, value: isAnimating)
                    .onAppear {
                        DispatchQueue.main.async {
                            withAnimation(rotateAnimation) {
                                isAnimating = true
                            }
                        }
                    }
                
                Text(text)
                    .font(.heading)
                    .foregroundStyle(.white)
            }
            .frame(width: size.width, height: size.height, alignment: .center)
        } .background(.clear)
    }
}

#Preview {
    LoaderView(text: "Generating...")
}
