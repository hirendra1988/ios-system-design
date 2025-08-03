//
//  Untitled.swift
//  SystemDesign
//
//  Created by Hirendra Sharma on 19/07/25.
//

import Foundation
import AudioToolbox
import UserNotifications

protocol TimerEventHandler {
    func triggerVibration()
    func scheduleNotification(after seconds: Int)
}

class DefaultTimerEventHandler: TimerEventHandler {
    func triggerVibration() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    func scheduleNotification(after seconds: Int) {
        let content = UNMutableNotificationContent()
        content.title = "⏰ Timer Finished"
        content.body = "Your countdown has ended."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds),repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
}
