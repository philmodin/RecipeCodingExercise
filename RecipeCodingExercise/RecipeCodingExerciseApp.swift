//
//  RecipeCodingExerciseApp.swift
//  RecipeCodingExercise
//
//  Created by Philip Modin on 1/18/25.
//

import SwiftData
import SwiftUI

@main
struct RecipeCodingExerciseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
//		.modelContainer(for: Recipe.self)
		.modelContainer(for: CachedImage.self)
    }
}
