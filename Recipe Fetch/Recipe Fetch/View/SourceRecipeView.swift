//
//  SourceRecipeView.swift
//  Recipe Fetch
//
//  Created by Israel Manzo on 2/6/25.
//

import SwiftUI

struct SourceRecipeView: View {
    
    var recipe: Recipe?
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: recipe?.photoURLLarge ?? "")) { phase in
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
            VStack(alignment: .center) {
                Text(recipe?.name ?? "")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text(recipe?.cuisine ?? "")
                    .font(.title)
            }
            Spacer()
            VStack(spacing: 10) {
                if let url = URL(string: recipe?.sourceURL ?? "") {
                    Link(destination: url) {
                        HStack {
                            Text("Source")
                            Image(systemName: "safari")
                        }
                        .font(.title2)
                    }
                }
                
                if let youtubeURL = URL(string: recipe?.youtubeURL ?? "") {
                    Link(destination: youtubeURL) {
                        HStack {
                            Text("YouTube")
                            Image(systemName: "play.tv.fill")
                        }
                        .foregroundStyle(.red)
                        .font(.title2)
                    }
                }
            }
            .padding()
            Spacer()
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    SourceRecipeView(recipe: Recipe(cuisine: "Malasyan", name: "Apam Balik", photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg", photoURLSmall: "", sourceURL: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", uuid: "xxx", youtubeURL: "https://www.youtube.com/watch?v=6R8ffRRJcrg"))
}
