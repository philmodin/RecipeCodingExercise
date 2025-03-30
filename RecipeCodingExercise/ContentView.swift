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
	@Query var cachedImages: [CachedImage]
	@Environment(\.modelContext) var modelContext
	
    var body: some View {
		List {
			// Segmented picker is for demonstrstion purposes only. Doesn't ship in production.
			#if DEBUG
			Picker("", selection: $segmentIndex) {
				Text("Recipes").tag(0)
				Text("Empty").tag(1)
				Text("Malformed").tag(2)
			}
			.pickerStyle(.segmented)
			Button("Purge image cache", systemImage: "trash") {
				do {
					print("pre  purge: ", cachedImages.count)
					try modelContext.delete(model: CachedImage.self)
					try modelContext.save()
					print("post purge: ", cachedImages.count)
				} catch {
					print("failed to delete image cache", error)
				}
			}
			#endif
			
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
						
						if let cachedImage = cachedImages.first(where: { $0.photoUrl == recipe.photo_url_small }),
						   let uiImage = UIImage(data: cachedImage.imageData) {
							Image(uiImage: uiImage)
								.resizable()
								.scaledToFill()
								.frame(width: 200, height: 200)
								.clipShape(.rect(cornerRadius: 16))
								.task {
									print("loading image from cache ", cachedImage.photoUrl)
								}
						} else if let urlString = recipe.photo_url_small {
							ProgressView()
								.frame(width: 200, height: 200)
								.task {
									let _ = await NetworkService(modelContext: modelContext).fetchImage(urlString: urlString)
								}
						}
					}
				}
			}
		}
		.task {
			Task {
				recipes = try await NetworkService(modelContext: modelContext).loadRecipes(source: segmentIndex)
			}
		}
		.refreshable {
			Task {
				do {
					recipes = nil
					error = nil
					recipes = try await NetworkService(modelContext: modelContext).loadRecipes(source: segmentIndex)
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
