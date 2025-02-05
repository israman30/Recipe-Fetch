//
//  CardView.swift
//  Recipe Fetch
//
//  Created by Israel Manzo on 2/4/25.
//

import SwiftUI

struct CardView: View {
    
    var recipe: Recipe?
    var recipeData: RecipeData?
    
    var body: some View {
        ZStack(alignment: .leading) {
            AsyncImage(url: URL(string: (recipe?.photoURLSmall == nil ? recipeData?.photoURLSmall : recipe?.photoURLSmall) ?? "")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(5)
                } else if phase.error != nil {
                    Text("Error loading image.")
                        .font(.title)
                        .foregroundStyle(.gray)
                } else {
                    Image(systemName: "wifi.exclamationmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                }
            }
            
            VStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text((recipe?.name == nil ? recipeData?.name : recipe?.name) ?? "")
                            .font(.largeTitle)
                        Text((recipe?.cuisine == nil ? recipeData?.cuisinie : recipe?.cuisine) ?? "")
                            .font(.title2)
                    }
                    .shadowText(x: 10, y: 15, cornerRadius: 5)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    CardView(recipe: Recipe(cuisine: "Italian", name: "Spagetty", photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg", photoURLSmall: "", sourceURL: "", uuid: "2www"))
}

// MARK: - Modifier for CardView shadow
struct ShadowText: ViewModifier {
    var x: CGFloat
    var y: CGFloat
    var cornerRadius: CGFloat
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(Color.black.opacity(0.6))
            .cornerRadius(cornerRadius)
            .offset(x: x, y: y)
    }
}

extension View {
    func shadowText(x: CGFloat = 0, y: CGFloat = 0, cornerRadius: CGFloat = 10) -> some View {
        modifier(ShadowText(x: x, y: y, cornerRadius: cornerRadius))
    }
}
