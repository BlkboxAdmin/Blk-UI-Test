//
//  AppState.swift
//  blk
//
//  Created by Nabeel Shafique on 12/12/2022.
//

import Foundation
import UserNotifications

class AppState: ObservableObject {
	
	static let shared = AppState()

	var isNewFriendRequest: Bool {
		return !profileId.isEmpty
	}
	
	@Published var notificationType: PushNotificationType = .none
	@Published var profileId: String = ""
	@Published var sender_user_id: String = ""
	@Published var receiver_user_id: String = ""
	@Published var chat: Chat?
}

enum PushNotificationType: String {
case none = ""
case message = "message"
case friendRequest = "friend_request"
}
