//
//  CardView.swift
//  Recipe Fetch
//
//  Created by Israel Manzo on 2/4/25.
//

import SwiftUI

struct CardView: View {
    
    var recipe: Recipe
    
    var body: some View {
        ZStack(alignment: .leading) {
            AsyncImage(url: URL(string: recipe.photoURLSmall)) { image in
                image.image?.resizable()
                    .scaledToFit()
                    .cornerRadius(10)
            }
            VStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(recipe.name)
                            .font(.callout)
                        Text(recipe.cuisine )
                            .font(.title2)
                            
                            .fontWeight(.bold)
                    }
                    .shadowText(x: 10, y: 15, cornerRadius: 10)
                    Spacer()
                    VStack {
                        if let sourceURL = recipe.sourceURL {
                            Text(sourceURL)
                                .font(.caption)
                                .shadowText(x: 10, y: -15, cornerRadius: 10)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CardView(recipe: Recipe(cuisine: "Italian", name: "Spagetty", photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg", photoURLSmall: "", sourceURL: "", uuid: "2www"))
}

struct ShadowText: ViewModifier {
    var x: CGFloat
    var y: CGFloat
    var cornerRadius: CGFloat
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding()
            .background(Color.black.opacity(0.5))
            .cornerRadius(10)
            .offset(x: x, y: y)
    }
}

extension View {
    func shadowText(x: CGFloat = 0, y: CGFloat = 0, cornerRadius: CGFloat = 10) -> some View {
        modifier(ShadowText(x: x, y: y, cornerRadius: cornerRadius))
    }
}
