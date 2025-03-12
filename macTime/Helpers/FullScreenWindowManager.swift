//
//  FullScreenWindowManager.swift
//  macTime
//
//  Created by Luis Amorim on 12/03/25.
//

import SwiftUI
import AppKit

/// Manages the full-screen window behavior and lifecycle.
class FullScreenWindowManager {
    static let shared = FullScreenWindowManager()

    private var window: NSWindow?

    /**
     Opens the full-screen window that covers the entire screen, including the menu bar and dock.

     This method checks if the window already exists. If not, it creates a new `NSWindow` and configures it to be
     borderless, translucent, and occupy the entire screen. It also ensures the window stays above other windows.
     */
    func openFullScreenWindow() {
        if window == nil {
            let hostingController = NSHostingController(rootView: FullScreenView().preferredColorScheme(.dark))
            let newWindow = NSWindow(
                contentViewController: hostingController
            )

            // Configures the window to occupy the entire screen (including the menu bar and dock).
            newWindow.setFrame(NSScreen.main!.frame, display: true) // Fill the entire screen
            newWindow.styleMask = [.borderless, .closable]
            newWindow.backgroundColor = NSColor.clear // Transparent background
            newWindow.isOpaque = false // Allows transparency
            newWindow.titlebarAppearsTransparent = true
            newWindow.level = .floating // Keeps the window above other windows
            newWindow.hasShadow = false // Disables shadow
            newWindow.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary] // Allows full-screen behavior
            newWindow.isMovableByWindowBackground = false
            
            // Prevents the window from being covered by the menu bar or dock.
            newWindow.ignoresMouseEvents = false
            newWindow.setFrame(NSScreen.main!.frame, display: true)
            
            // Makes the window visible and active
            newWindow.makeKeyAndOrderFront(nil)
            window = newWindow
        } else {
            window?.makeKeyAndOrderFront(nil) // Brings the window to the front if it already exists
        }
    }

    /**
     Closes the full-screen window if it is open.

     This method will close the window if it has been previously opened.
     */
    func closeWindow() {
        window?.close()
    }
}

/// A view that occupies the full screen with translucent background and some content.
struct FullScreenView: View {
    var body: some View {
        ZStack {
            // Applies a translucent material background that fills the entire screen
            Color.clear.background(.ultraThickMaterial)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Alert")
                    .font(.system(size: 72, weight: .bold, design: .rounded))

                Text("Alarm set to 08:00")
                    .font(.system(size: 32, weight: .regular, design: .rounded))
                
                Button(action: {
                    print("Snooze")
                }) {
                    Text("Snooze")
                }
                    
                // Button to close the full-screen window
                Button(action: {
                    FullScreenWindowManager.shared.closeWindow()
                }) {
                    Text("Close")
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.all) // Ignores the safe area to occupy the entire screen
    }
}

#Preview {
    FullScreenView()
        .preferredColorScheme(.dark)
}
