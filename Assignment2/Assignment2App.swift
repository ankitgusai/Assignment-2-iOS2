//
//  Assignment1App.swift
//  Assignment1
//
//  Created by Ankitgiri Gusai on 2023-02-05.
//

import SwiftUI

@main
struct Assignment2App: App {
    @StateObject private var dataController = NasaRoverDataController()
    var body: some Scene {
        WindowGroup {
            FavoriteImagesView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
