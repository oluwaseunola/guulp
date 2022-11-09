//
//  GluggAppApp.swift
//  GluggApp
//
//  Created by Seun Olalekan on 2022-10-06.
//

import SwiftUI


@main
struct GluggAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
