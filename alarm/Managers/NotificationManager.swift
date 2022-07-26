//
//  NotificationManager.swift
//  alarm
//
//  Created by Константин Кифа on 27.07.2022.
//
/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import UserNotifications

enum NotificationManagerConstants {
    static let calendarBasedNotificationThreadId =
    "CalendarBasedNotificationThreadId"
}

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    var settings: UNNotificationSettings?
    
    func requestAuthorization(completion: @escaping  (Bool) -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
                self.fetchNotificationSettings()
                completion(granted)
            }
    }
    
    func fetchNotificationSettings() {
        // 1
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            // 2
            DispatchQueue.main.async {
                self.settings = settings
            }
        }
    }
    
    func removeScheduledNotification(task: Task) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [task.id])
    }
    
    // 1
    func scheduleNotification(task: Task) {
        // 2
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName.init(rawValue: task.reminder.soundName!))
        content.title = task.name
        content.body = task.reminder.description!
        content.categoryIdentifier = "OrganizerPlusCategory"
        let taskData = try? JSONEncoder().encode(task)
        if let taskData = taskData {
            content.userInfo = ["Task": taskData]
        }
        
        // 3
        var trigger: UNNotificationTrigger?

            if let dateComponents = task.reminder.dateComponents {
                trigger = UNCalendarNotificationTrigger(
                    dateMatching: dateComponents,
                    repeats: task.reminder.isNeedToRepeat!)
            }
            content.threadIdentifier =
            NotificationManagerConstants.calendarBasedNotificationThreadId
        
        // 4
        if let trigger = trigger {
            let request = UNNotificationRequest(
                identifier: task.id,
                content: content,
                trigger: trigger)
            // 5
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
}
