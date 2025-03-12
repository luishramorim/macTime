//
//  TimerWindowManager.swift
//  macTime
//
//  Created by Luis Amorim on 12/03/25.
//

import SwiftUI
import AppKit

class TimerWindowManager {
    static let shared = TimerWindowManager()
    
    private var window: NSWindow?
    
    func openWindow() {
        if window == nil {
            let hostingController = NSHostingController(rootView: TimerView())
            let newWindow = NSWindow(
                contentViewController: hostingController
            )
            
            newWindow.setContentSize(NSSize(width: 350, height: 400))
            newWindow.styleMask = [.borderless, .closable]
            newWindow.isOpaque = false
            newWindow.backgroundColor = NSColor.clear
            newWindow.titlebarAppearsTransparent = true
            newWindow.level = .normal
            newWindow.standardWindowButton(.miniaturizeButton)?.isHidden = true
            newWindow.standardWindowButton(.zoomButton)?.isHidden = true
            newWindow.center()
            newWindow.makeKeyAndOrderFront(nil)
            newWindow.isMovableByWindowBackground = true
            
            window = newWindow
        } else {
            window?.makeKeyAndOrderFront(nil)
        }
    }
    
    func closeWindow() {
        window?.close()
    }
    
    func toggleOverlay() {
        if window?.level == .floating {
            window?.level = .normal
        } else {
            window?.level = .floating
        }
    }
}
