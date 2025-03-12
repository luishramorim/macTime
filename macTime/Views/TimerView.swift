//
//  TimerView.swift
//  macTime
//
//  Created by Luis Amorim on 12/03/25.
//

import SwiftUI
import UserNotifications

struct TimerView: View {
    @State private var timer: Timer? = nil
    @State private var chosenMinutes: Double = 25
    @State private var remainingTime: Double = 25 * 60
    @State private var isRunning: Bool = false
    @State private var startDate: Date? = nil
    @State private var endDate: Date? = nil
    
    @State private var isPinned = false
    
    var totalTime: Double { chosenMinutes * 60 }
    
    var body: some View {
        VStack(spacing: 20){
            HStack {
                // Close Button
                Button(action:
                        {TimerWindowManager.shared.closeWindow()}
                ) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
                .offset(x: -5, y: -10)
                
                Spacer()
                
                Text("Timer")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 2)
                
                Spacer()
                
                Button(action: {
                    isPinned.toggle()
                    TimerWindowManager.shared.toggleOverlay()
                }) {
                    Image(systemName: isPinned ? "pin.fill" : "pin.slash")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
                .offset(x: 2, y: -10)
                
            }
            .padding(.top, 5)
            
            // Timer Gauge and buttons for minutes adjustments
            Gauge(value: remainingTime, in: 0...totalTime){
                HStack{
                    Spacer()
                    Button {
                        if !isRunning, chosenMinutes > 1 {
                            chosenMinutes -= 1
                            remainingTime = chosenMinutes * 60
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(chosenMinutes <= 1 || isRunning)
                    
                    Text(timeString(from: Int(remainingTime)))
                        .font(.system(size: 64, weight: .bold, design: .monospaced))
                        .contentTransition(.numericText(value: remainingTime))
                    
                    Button {
                        if !isRunning {
                            chosenMinutes += 1
                            remainingTime = chosenMinutes * 60
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(chosenMinutes >= 120 || isRunning)
                    
                    Spacer()
                }
            }
            .gaugeStyle(.accessoryLinearCapacity)
            .tint(.blue)
            .animation(.easeInOut(duration: 1.0), value: remainingTime)
            
            // Control buttons for starting, pausing, and resetting the timer.
            HStack(spacing: 16) {
                Button(action: resetTimer) {
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.gray.opacity(0.2))
                        Image(systemName: "stop.fill")
                            .font(.system(size: 18))
                            .foregroundColor(isRunning || remainingTime < totalTime ? .primary : .gray)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(!isRunning && remainingTime == totalTime)
                
                if !isRunning {
                    Button(action: startTimer) {
                        ZStack {
                            Circle()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color.green)
                            Image(systemName: "play.fill")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Button(action: pauseTimer) {
                        ZStack {
                            Circle()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color.red)
                            Image(systemName: "pause.fill")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .onAppear {
            requestNotificationPermission()
        }
    }
    
    func startTimer() {
        guard !isRunning else { return }
        startDate = Date()
        endDate = startDate!.addingTimeInterval(remainingTime)
        isRunning = true
                
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remainingTime > 0 {
                withAnimation(.easeInOut(duration: 1.0)) {
                    remainingTime -= 1
                }
            } else {
                timer?.invalidate()
                isRunning = false
                sendNotification()
                resetTimer()
            }
        }
    }
    
    func pauseTimer() {
        isRunning = false
        timer?.invalidate()
    }
    
    func resetTimer() {
        timer?.invalidate()
        remainingTime = totalTime
        isRunning = false
        endDate = nil
    }
    
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "macTime"
        content.body = "Timer Over!"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            }
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            } else if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}


#Preview {
    TimerView()
}
