//
//  macTimeApp.swift
//  macTime
//
//  Created by Luis Amorim on 12/03/25.
//

import SwiftUI

@main
struct macTimeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(Color.clear)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .windowBackgroundDragBehavior(.enabled)
        .windowToolbarStyle(.unifiedCompact)
    }
}
