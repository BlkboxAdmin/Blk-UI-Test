//
//  Notification.swift
//  blk
//
//  Created by Nabeel Shafique on 01/11/2022.
//

import Foundation

struct NotData: Decodable {
	let data: NotificationData
	
}

struct NotificationData: Decodable {
	let rows: [Notification]
	let page: Int
	let perPage: Int
	let offset: Int
	let totalRows: Int
	let totalPages: Int
}

struct Notification: Hashable, Codable, Identifiable {
	var id: String
	var type: String
	var text: String
	var user_id: String
	var is_read: Int
	var isRead: Bool {
		return (is_read == 1)
	}
	var updated_on: String
	var created_on: String
	var status: String
}
