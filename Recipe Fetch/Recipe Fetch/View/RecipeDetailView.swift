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
        GroupBox {
            VStack(alignment: .center) {
                Text(recipeData?.name ?? "")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text(recipeData?.cuisinie ?? "")
                    .font(.title)
            }
            GroupBox {
                CustomAsyncImage(urlString: recipeData?.photoURLSmall)
            }
            
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
        }
        Spacer()
    }
}

#Preview {
    RecipeDetailView()
}

