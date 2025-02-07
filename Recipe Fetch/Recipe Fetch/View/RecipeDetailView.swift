//
//  SourceRecipeView.swift
//  Recipe Fetch
//
//  Created by Israel Manzo on 2/6/25.
//

import SwiftUI

struct RecipeDetailView: View {
    
    var recipeData: RecipeData?
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: recipeData?.photoURLSmall ?? "")) { phase in
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
                Text(recipeData?.name ?? "")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text(recipeData?.cuisinie ?? "")
                    .font(.title)
            }
            Spacer()
            VStack(spacing: 10) {
                if let url = URL(string: recipeData?.sourceURL ?? "") {
                    Link(destination: url) {
                        HStack {
                            Text("Source")
                            Image(systemName: "safari")
                        }
                        .font(.title2)
                    }
                }
                
                if let youtubeURL = URL(string: recipeData?.youtubeURL ?? "") {
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
    RecipeDetailView()
}
