//
//  Friend.swift
//  blk
//
//  Created by Nabeel Shafique on 01/12/2022.
//

import Foundation

struct FriendShipData: Codable, Hashable {
	var isFriend: Bool
	var isInvited: Bool
	var isInviter: Bool? {
		if !isInvited {
			return nil
		}
		
		if data == nil {
			return nil
		}
		
		if data!.sender_user_id == Common.user!.id {
			return true
		}
		
		return false
	}
	var data: Friend?
}

struct Friend: Identifiable, Codable, Hashable {
	var id: String
	var sender_user_id: String
	var receiver_user_id: String
	var invited_on: String
	var answered_on: String?
	var created_by: String
	var updated_on: String
	var created_on: String
	var status: String
}

enum FriendBtnText: String {
	case addFriend = "Add Friend"
	case invited = "Invited"
	case accept = "Accept"
	case decline = "Decline"
	case unfriend = "Unfriend"
}
