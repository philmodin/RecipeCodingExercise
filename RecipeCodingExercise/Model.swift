//
//  Model.swift
//  RecipeCodingExercise
//
//  Created by Philip Modin on 1/25/25.
//

import SwiftData

@Model
class Recipe {
		
	@Attribute(.unique) var uuid: String
	var cuisine: String
	var name: String
	var photo_url_large: String?
	var photo_url_small: String?
	var source_url: String?
	var youtube_url: String?
	
	init(uuid: String, cuisine: String, name: String, photo_url_large: String? = nil, photo_url_small: String? = nil, source_url: String? = nil, youtube_url: String? = nil) {
		self.uuid = uuid
		self.cuisine = cuisine
		self.name = name
		self.photo_url_large = photo_url_large
		self.photo_url_small = photo_url_small
		self.source_url = source_url
		self.youtube_url = youtube_url
	}
	
	convenience init(from recipe: Response.Recipe) {
		self.init(
			uuid: recipe.uuid,
			cuisine: recipe.cuisine,
			name: recipe.name,
			photo_url_large: recipe.photo_url_large,
			photo_url_small: recipe.photo_url_small,
			source_url: recipe.source_url,
			youtube_url: recipe.youtube_url
		)		
	}

}

struct Response: Codable {
	let recipes: [Recipe]
	struct Recipe: Codable {
		let cuisine: String
		let name: String
		let photo_url_large: String?
		let photo_url_small: String?
		let source_url: String?
		let uuid: String
		let youtube_url: String?
	}
}


