//
//  AppDelegate.swift
//  blk
//
//  Created by Nabeel Shafique on 02/11/2022.
//

import UIKit
import SwiftKeychainWrapper

class AppDelegate: NSObject, UIApplicationDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		
		UNUserNotificationCenter.current().delegate = self
		
		UITextView.appearance().backgroundColor = .clear
		// List
		UITableView.appearance().backgroundColor = UIColor.clear
		UITableViewCell.appearance().backgroundColor = .clear
		
		registerForPushNotifications()
		
		//If your app wasn’t running and the user launches it by tapping the push notification, iOS passes the notification to your app
		let notificationOption = launchOptions?[.remoteNotification]
		if let notification = notificationOption as? [String: AnyObject] {
			processPushNotification(notification)
		}
		
		return true
	}
	
	func processPushNotification(_ notification: [AnyHashable: Any], completionHandler: ((UIBackgroundFetchResult) -> Void)? = nil) {
		
		guard let type = notification["type"] as? String else {
			completionHandler?(.failed)
			return
		}
		
		switch type {
		case PushNotificationType.message.rawValue:
			guard let senderUserId = notification["sender_user_id"] as? String else {
				completionHandler?(.failed)
				return
			}
			
			guard let receiverUserId = notification["receiver_user_id"] as? String else {
				completionHandler?(.failed)
				return
			}
			
			AppState.shared.sender_user_id = senderUserId
			AppState.shared.receiver_user_id = receiverUserId
			AppState.shared.notificationType = .message
			
		case PushNotificationType.friendRequest.rawValue:
			guard let profileId = notification["profile_id"] as? String else {
				completionHandler?(.failed)
				return
			}
			
			AppState.shared.profileId = profileId
			AppState.shared.notificationType = .friendRequest
		default:
			break
		}
	}
	
	// To handle the situation where your app is running when a push notification is received
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		// we dont need this
		//processPushNotification(userInfo, completionHandler: completionHandler)
	}
	
	//No callback in simulator
	//-- must use device to get valid push token
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
		let token = tokenParts.joined()
		
		// send this token to server with userId to save the device address with user (this can be done on signup/signin)
		let saveSuccessful: Bool = KeychainWrapper.standard.set(token, forKey: Common.deviceTokenKey)
		if !saveSuccessful {
			print("Device Token: \(token)")
		}
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print("Failed to register: \(error)")
		
	}
	
	func registerForPushNotifications() {
		let center = UNUserNotificationCenter.current()
		center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			
			if let error = error {
				// Handle the error here.
				print(error)
			}
			
			guard granted else { return }
			
			self.getNotificationSettings()
			
		}
	}
	
	func getNotificationSettings() {
		UNUserNotificationCenter.current().getNotificationSettings { settings in
			//print("Notification settings: \(settings)")
			
			guard settings.authorizationStatus == .authorized else { return }
			DispatchQueue.main.async {
				UIApplication.shared.registerForRemoteNotifications()
			}
		}
	}
	
}

extension AppDelegate: UNUserNotificationCenterDelegate {
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		
		let userInfo = response.notification.request.content.userInfo
		
		processPushNotification(userInfo)
		
		completionHandler()
	}
}
