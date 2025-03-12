//
//  StopwatchWindowManager.swift
//  macTime
//
//  Created by Luis Amorim on 12/03/25.
//

import SwiftUI
import AppKit

class StopwatchWindowManager {
    static let shared = StopwatchWindowManager()
    
    private var window: NSWindow?
    
    func openWindow() {
        if window == nil {
            let hostingController = NSHostingController(rootView: StopwatchView())
            let newWindow = NSWindow(
                contentViewController: hostingController
            )
            
            newWindow.setContentSize(NSSize(width: 350, height: 400))
            newWindow.styleMask = [.borderless, .closable] // Remove title bar, mantém apenas o botão de fechar
            newWindow.isOpaque = false // Permite transparência
            newWindow.backgroundColor = NSColor.clear // Fundo transparente
            newWindow.titlebarAppearsTransparent = true
            newWindow.level = .normal // Mantém a janela acima das outras
            newWindow.standardWindowButton(.miniaturizeButton)?.isHidden = true // Oculta minimizar
            newWindow.standardWindowButton(.zoomButton)?.isHidden = true // Oculta maximizar
            newWindow.center()
            newWindow.makeKeyAndOrderFront(nil)
            newWindow.isMovableByWindowBackground = true
            
            window = newWindow
        } else {
            window?.makeKeyAndOrderFront(nil)
        }
    }
    
    /// Closes the stopwatch window.
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
