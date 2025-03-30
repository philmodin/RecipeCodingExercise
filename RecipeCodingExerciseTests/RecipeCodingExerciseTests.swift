//
//  RecipeCodingExerciseTests.swift
//  RecipeCodingExerciseTests
//
//  Created by Philip Modin on 3/29/25.
//

import Testing
import SwiftData
@testable import RecipeCodingExercise

struct RecipeCodingExerciseTests {

    @MainActor @Test func startEmptyImageCache() async throws {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: CachedImage.self, configurations: config)
		let context = container.mainContext
		var cachedImages: [CachedImage] = try context.fetch(FetchDescriptor<CachedImage>())
		assert(cachedImages.count == 0)
    }
	
	@MainActor @Test func imageCaching() async throws {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: CachedImage.self, configurations: config)
		let context = container.mainContext
		let network = NetworkService(modelContext: context)
		let _ = await network.fetchImage(urlString: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/small.jpg")
		var cachedImages: [CachedImage] = try context.fetch(FetchDescriptor<CachedImage>())
		assert(cachedImages[0].photoUrl == "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/small.jpg")
	}

}
