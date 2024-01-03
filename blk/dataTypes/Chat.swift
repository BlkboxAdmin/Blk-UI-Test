//
//  Chat.swift
//  blk
//
//  Created by Nabeel Shafique on 04/11/2022.
//

import Foundation

struct ChatData: Decodable {
	let data: [Chat]
}

struct ThreadData: Decodable {
	let data: ChatThread
}

struct Chat: Codable, Hashable, Identifiable {
	var id: String
	var sender_user_id: String
	var receiver_user_id: String
	var invited_on: String
	var answered_on: String?
	var created_by: String
	var updated_on: String
	var created_on: String
	var status: String
	var user: User?
	var thread: ChatThread?
}

struct ChatThread: Codable, Hashable, Identifiable {
	var id: String
	var participants_ids: String?
	var other_user: User?
	var created_by: String
	var created_on: String
	var status: String
}
