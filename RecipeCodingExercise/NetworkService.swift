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
		print("response:\n", response)
		print("data:\n", String(decoding: data, as: UTF8.self))
		return try JSONDecoder().decode(Response.self, from: data).recipes
	} catch {
		Logger().error("\(error.localizedDescription)")
		throw error
	}
}

func loadImage(urlString: String) async throws -> Image? {
	guard let url = URL(string: urlString) else {
		throw Errors.URLError
	}
	
	// Check for image in disk cache
	
	// Otherwise load from internet
	// Save image to disk and return image
	
	do {
		let (data, response) = try await URLSession.shared.data(from: url)
		print("response:\n", response)
	} catch {
		print("error:\n", error.localizedDescription)
		throw error
	}
	return nil
}
