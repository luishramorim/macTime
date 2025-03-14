//
//  ContentView.swift
//  macTime
//
//  Created by Luis Amorim on 12/03/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HStack{
                VStack(alignment: .leading){
                    Text("macTime")
                        .font(.system(size: 20, design: .rounded))
                    Text("version \(appVersion())")
                }
                .padding(.horizontal)
                Spacer()
            }
            
            Button {
                StopwatchWindowManager.shared.openWindow()
            } label: {
                HStack{
                    Image(systemName: "stopwatch.fill")
                    Text("Stopwatch")
                }
                .font(.title2)
                .padding()
                .background(
                    .regularMaterial
                )
                .cornerRadius(10)
            }
            .buttonStyle(.plain)
            .padding()
            
            Button {
                TimerWindowManager.shared.openWindow()
            } label: {
                HStack{
                    Image(systemName: "timer.circle.fill")
                    Text("Timer")
                }
                .font(.title2)
                .padding()
                .background(
                    .regularMaterial
                )
                .cornerRadius(10)
            }
            .buttonStyle(.plain)
            .padding(.bottom)
        }
        .frame(width: 250)
    }
    
    func appVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        } else {
            return "Unknown"
        }
    }
}

#Preview {
    ContentView()
}
