//
//  Message.swift
//  blk
//
//  Created by Nabeel Shafique on 04/11/2022.
//

import Foundation

struct MessageListData: Decodable {
	let data: MessageData
}

struct MessageData: Decodable {
	let rows: [Message]
	let page: Int
	let perPage: Int
	let offset: Int
	let totalRows: Int
	let totalPages: Int
}

struct NewMessageData: Decodable {
	let data: Bool
}

struct Message: Codable, Hashable, Identifiable {
	var id: String
	var message_text: String
	var isOtherUserMsg: Bool {
		return (Common.user!.id != created_by)
	}
	var is_my_message: Int
	var thread_id: String
	var created_by: String
	var created_on: String
	var status: String
	var user: User
	
}
