//
//  AlarmView.swift
//  macTime
//
//  Created by Luis Amorim on 12/03/25.
//

import SwiftUI

/// A view that allows the user to manage multiple alarms with toggles to activate or deactivate them.
struct AlarmView: View {
    @State private var alarms: [Alarm] = [
        Alarm(name: "Wake Up", isActive: false),
        Alarm(name: "Meeting", isActive: false),
        Alarm(name: "Exercise", isActive: false)
    ]

    var body: some View {
        VStack {
            List {
                ForEach($alarms) { $alarm in
                    HStack {
                        Text(alarm.name)
                            .font(.headline)
                        
                        Toggle(isOn: $alarm.isActive) {
                            
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                    }
                    .padding(.vertical, 8)
                }
            }
            .scrollContentBackground(.hidden)
            .background(
                .ultraThinMaterial
            )
        }
    }
}

/// A model representing an individual alarm.
struct Alarm: Identifiable {
    let id = UUID()
    var name: String
    var isActive: Bool
}

#Preview {
    AlarmView()
}
