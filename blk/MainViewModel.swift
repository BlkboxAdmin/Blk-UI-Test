//
//  MainViewModel.swift
//  blk
//
//  Created by Nabeel Shafique on 01/11/2022.
//

import Foundation

class MainViewModel: BaseViewModel {
	
	@Published var userImage: String = ""
	@Published var notifications: [Notification] = []
	
	func renderUser() {
		userImage = Common.user!.imageUrlSM
	}
	
	func getNotifications()
	{
		//notifications = load("notifications.json")
		postRequest(endPoint: "/api/notifications/1") { data, status, message  in

			if (status == .success) {

				let response = try! JSONDecoder().decode(NotData.self, from: data)
				let detail = response.data

				self.notifications = detail.rows
			}
			else {
				print(message)
			}
		}
	}
}
