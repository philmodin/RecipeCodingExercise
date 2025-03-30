//
//  NetworkService.swift
//  RecipeCodingExercise
//
//  Created by Philip Modin on 1/18/25.
//

import Foundation
import SwiftData

enum Errors: Error {
	case URLError
}

@MainActor
class NetworkService {
	
	private let modelContext: ModelContext
	
	init(modelContext: ModelContext) {
		self.modelContext = modelContext
	}
		
	func loadRecipes(source: Int = 0) async throws -> [Response.Recipe] {
		var urlSource: URL?
		// Use a URL based on the selected tab.
		switch source {
		case 0: urlSource = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
		case 1: urlSource = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")
		default: urlSource = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
		}
		
		guard let urlSource else { throw Errors.URLError }
		
		do {
			let (data, _) = try await URLSession.shared.data(from: urlSource)
			return try JSONDecoder().decode(Response.self, from: data).recipes
		} catch {
			throw error
		}
	}
	
	func fetchImage(urlString: String) async -> Data? {
		if let imageData = await checkCache(urlString: urlString) {
			return imageData
		} else {
			await loadAndCacheImage(urlString: urlString)
			return nil
		}
	}
	
	private func checkCache(urlString: String) async -> Data? {
		do {
			let cachedImages: [CachedImage] = try modelContext.fetch(FetchDescriptor<CachedImage>())
			return cachedImages.first(where: { $0.photoUrl == urlString })?.imageData
		} catch {
			return nil
		}
	}
	
	private func loadAndCacheImage(urlString: String) async {
		guard let url = URL(string: urlString) else { return }

		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			modelContext.insert(CachedImage(imageData: data, url: urlString))
		} catch {
			print("error:\n", error.localizedDescription)
			
		}
	}
}


