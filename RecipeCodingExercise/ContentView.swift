//
//  ContentView.swift
//  RecipeCodingExercise
//
//  Created by Philip Modin on 1/18/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	@State private var segmentIndex = 0
	@State private var recipes: [Response.Recipe]?
	
	@State private var error: Error?
	@State private var isEmpty = false
	
//	@Query var recipes: [Recipe]
	
    var body: some View {
		List {
			// Segmented picker is for demonstrstion purposes only. Doesn't ship in production.
			Picker("", selection: $segmentIndex) {
				Text("Recipes").tag(0)
				Text("Empty").tag(1)
				Text("Malformed").tag(2)
			}
			.pickerStyle(.segmented)
			
			if error != nil {
				Text("Something went wrong, please try again later.")
			} else if let recipes, recipes.count < 1 {
				Text("No recipes available yet, please try again later.")
			} else if let recipes {
				ForEach(recipes, id: \.uuid) { recipe in
					VStack(alignment: .leading) {
						Text(recipe.cuisine)
							.font(.largeTitle)
						Text(recipe.name)
						AsyncImage(url: URL(string: recipe.photo_url_small!)) { image in
							image
								.resizable()
								.scaledToFill()
						} placeholder: {
							Color.clear
						}
							.frame(width: 200, height: 200)
							.clipShape(.rect(cornerRadius: 16))
					}
				}
			}
		}
		.task {
			Task {
				recipes = try await loadRecipes(source: segmentIndex)
			}
		}
		.refreshable {
			Task {
				do {
					recipes = nil
					error = nil
					recipes = try await loadRecipes(source: segmentIndex)
				} catch {
					self.error = error
				}
			}
		}
    }
}

#Preview {
    ContentView()
}
