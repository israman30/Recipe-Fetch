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
                        }
                    }
                    .shadowText(x: 10, y: -15, cornerRadius: 10)
                }
            }
        }
    }
}

#Preview {
    CardView(recipe: Recipe(cuisine: "Italian", name: "Spagetty", photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg", photoURLSmall: "", sourceURL: "", uuid: "2www"))
}

struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color("CardBackground"))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 4)
    }
}
extension View {
    func cardBackground() -> some View {
        modifier(CardBackground())
    }
}
