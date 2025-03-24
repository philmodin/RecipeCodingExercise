//
//  NetworkService.swift
//  RecipeCodingExercise
//
//  Created by Philip Modin on 1/18/25.
//

enum Errors: Error {
	case URLError
}

import Foundation
import OSLog
import SwiftUI
import SwiftData

class NetworkService {
	
	@Query var images: [ImageCache]
	@Environment(\.modelContext) var modelContext
	
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
			let (data, response) = try await URLSession.shared.data(from: urlSource)
//			print("response:\n", response)
//			print("data:\n", String(decoding: data, as: UTF8.self))
			return try JSONDecoder().decode(Response.self, from: data).recipes
		} catch {
			Logger().error("\(error.localizedDescription)")
			throw error
		}
	}
	
	func loadImage(urlString: String?) async -> Image {
		print("load image for: ", urlString ?? "none")
		guard let urlString, let url = URL(string: urlString) else {
			return Image(systemName: "xmark.icloud")
		}
		
		// Check for image in disk cache
		let imagePackage = images.first(where: { $0.photoUrl == urlString })
		if let imagePackage, let uiImage = UIImage(data: imagePackage.imageData) {
			return Image(uiImage: uiImage)
		}
		
		// Otherwise load from internet
		do {
			let (data, response) = try await URLSession.shared.data(from: url)
//			print("response:\n", response)
			// Save image to disk and return image
			modelContext.insert(ImageCache(imageData: data, url: urlString))
			if let uiImage = UIImage(data: data) {
				return Image(uiImage: uiImage)
			}
			
		} catch {
			print("error:\n", error.localizedDescription)
			return Image(systemName: "xmark.icloud")
		}

		// On failure return broken cloud
		return Image(systemName: "xmark.icloud")
	}
}


