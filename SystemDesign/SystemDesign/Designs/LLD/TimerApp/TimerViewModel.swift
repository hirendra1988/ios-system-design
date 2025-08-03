//
//  TimerViewModel.swift
//  SystemDesign
//
//  Created by Hirendra Sharma on 19/07/25.
//

import SwiftUI
import Combine
import AudioToolbox

class TimerViewModel: ObservableObject {
    @Published var timeRemaining: Int
    private var initialSeconds: Int
    private var timer: AnyCancellable?
    private var endDate: Date?
    private var delegate: TimerEventHandler
    
    init(startSeconds: Int,
         delegate: TimerEventHandler = DefaultTimerEventHandler()) {
        self.timeRemaining = startSeconds
        self.initialSeconds = startSeconds
        self.delegate = delegate
    }
    
    func start() {
        guard timer == nil else { return }
        endDate = Date().addingTimeInterval(TimeInterval(timeRemaining))
        self.delegate.scheduleNotification(after: timeRemaining)
        startTimer()
    }
    
    private func startTimer() {
        timer?.cancel()
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [weak self] res in
                guard let strongSelf = self else { return }
                strongSelf.updateRemainingTime()
            })
    }
    
    private func updateRemainingTime() {
        guard let endDate = endDate else { return }
        let remaining = Int(ceil(endDate.timeIntervalSinceNow))
        timeRemaining = max(remaining, 0)
        
        if timeRemaining <= 0 {
            stop()
            self.delegate.triggerVibration()
        }
    }
    
    func stop() {
        timer?.cancel()
        timer = nil
    }
    
    func reset() {
        stop()
        timeRemaining = initialSeconds
        endDate = nil
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    deinit {
        timer?.cancel()
    }
    
}
