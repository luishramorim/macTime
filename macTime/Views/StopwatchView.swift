//
//  StopwatchView.swift
//  macTime
//
//  Created by Luis Amorim on 12/03/25.
//

import SwiftUI

/// A stopwatch view that allows users to start, pause, reset, and record lap times.
struct StopwatchView: View {
    @State private var isRunning = false
    @State private var timeElapsed: TimeInterval = 0
    @State private var timer: Timer?
    
    @State private var isPinned = false
    
    @State private var minutes = 0
    @State private var seconds = 0
    @State private var tenths = 0
    
    @State private var laps: [LapRecord] = []
    
    var body: some View {
        VStack(spacing: 16) {
            VStack {
                HStack {
                    // Close Button
                    Button(action: closeWindow) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .offset(x: -5, y: -10)
                    
                    Spacer()
                    
                    Text("Stopwatch")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 2)
                    
                    Spacer()
                    
                    Button(action: {
                        isPinned.toggle()
                        StopwatchWindowManager.shared.toggleOverlay()
                    }) {
                        Image(systemName: isPinned ? "pin.fill" : "pin.slash")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .offset(x: 2, y: -10)
                    
                }
                .padding(.top, 5)
                
                // Timer Display
                HStack(spacing: 0) {
                    Text("\(String(format: "%02d", minutes))")
                        .font(.system(size: 64, weight: .bold, design: .monospaced))
                        .contentTransition(.numericText())
                        .animation(.smooth, value: minutes)
                    
                    Text(":")
                    
                    Text("\(String(format: "%02d", seconds))")
                        .font(.system(size: 64, weight: .bold, design: .monospaced))
                        .contentTransition(.numericText())
                        .animation(.smooth, value: seconds)
                    
                    Text(".")
                    
                    Text("\(String(format: "%01d", tenths))")
                        .font(.system(size: 64, weight: .bold, design: .monospaced))
                        .contentTransition(.numericText())
                        .animation(.smooth, value: tenths)
                }
                .font(.system(size: 42, weight: .bold, design: .monospaced))
            }
            
            // Control Buttons
            HStack(spacing: 16) {
                // Reset Button
                Button(action: resetTimer) {
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.gray.opacity(0.2))
                        Image(systemName: "stop.fill")
                            .font(.system(size: 18))
                            .foregroundColor(isRunning || timeElapsed > 0 ? .primary : .gray)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(!isRunning && timeElapsed == 0)
                
                // Start/Pause Button
                Button(action: {
                    if isRunning {
                        stopTimer()
                    } else {
                        startTimer()
                    }
                    isRunning.toggle()
                }) {
                    ZStack {
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(isRunning ? Color.red : Color.green)
                        Image(systemName: isRunning ? "pause.fill" : "play.fill")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // Lap Button
                Button(action: recordLap) {
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.gray.opacity(0.2))
                        Image(systemName: "flag")
                            .font(.system(size: 18))
                            .foregroundColor(isRunning ? .primary : .gray)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(!isRunning)
            }
        }
        .padding()
        .frame(width: 320)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
    
    /// Starts the stopwatch timer, updating every 0.1 seconds.
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            timeElapsed += 0.1
            updateTimeComponents()
        }
    }
    
    /// Updates the time display components (minutes, seconds, tenths of a second).
    func updateTimeComponents() {
        minutes = Int(timeElapsed / 60)
        seconds = Int(timeElapsed) % 60
        tenths = Int((timeElapsed.truncatingRemainder(dividingBy: 1)) * 10)
    }
    
    /// Stops the stopwatch timer.
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// Resets the stopwatch and clears lap history.
    func resetTimer() {
        stopTimer()
        timeElapsed = 0
        minutes = 0
        seconds = 0
        tenths = 0
        isRunning = false
        laps.removeAll()
    }
    
    /// Records a lap and saves the elapsed time.
    func recordLap() {
        let lap = LapRecord(
            number: laps.count + 1,
            time: timeElapsed,
            formattedTime: "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds)).\(String(format: "%01d", tenths))"
        )
        laps.append(lap)
    }
    
    /// Closes only the stopwatch window.
    func closeWindow() {
        StopwatchWindowManager.shared.closeWindow()
    }
}

/// Represents a lap record with an identifier, number, and formatted time.
struct LapRecord: Identifiable {
    let id = UUID()
    let number: Int
    let time: TimeInterval
    let formattedTime: String
}

/// A view that displays a recorded lap.
struct LapRowView: View {
    let lap: LapRecord
    
    var body: some View {
        HStack {
            Text("Lap \(lap.number)")
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(lap.formattedTime)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    StopwatchView()
}
