//
//  User.swift
//  blk
//
//  Created by Nabeel Shafique on 04/11/2022.
//

import Foundation

enum UserImgSize: CGFloat {
	case small = 38
	case medium = 60
	case large = 117
}

struct UserProfile: Decodable {
	let data: User
}

struct BlockList: Decodable {
	let data: [User]?
	
	private enum CodingKeys: String, CodingKey {
		case data
	}
	
	init(from decoder: Decoder) throws
	{
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		if let dataInfo = try? values.decode([User].self, forKey: .data) {
			data = dataInfo
		}
		else
		{
			data = []
		}
	}
}

struct User: Codable, Hashable, Identifiable {
	var id: String
	var username: String?
	var email: String
	var fullname: String?
	var name: String {
		return fullname ?? username ?? email
	}
	var image: String?
	var imageDefault: String {
		return "user-default"
	}
	var imageUrl: String {
		return UploadedImage.getUrl(imageId: image ?? "")
	}
	var imageUrlSM: String {
		return UploadedImage.getUrl(imageId: image ?? "", variant: .small)
	}
	var imageUrlMD: String {
		return UploadedImage.getUrl(imageId: image ?? "", variant: .medium)
	}
	var imageUrlLG: String {
		return UploadedImage.getUrl(imageId: image ?? "", variant: .large)
	}
	var bio: String?
	var phone: String?
	var dob: String?
	var show_online: Int?
	var showOnline: Bool {
		return show_online == 1
	}
	var push_notification: Int?
	var pushNotification: Bool {
		return push_notification == 1
	}
	var sms_notification: Int?
	var smsNotification: Bool {
		return sms_notification == 1
	}
	var email_notification: Int?
	var emailNotification: Bool {
		return email_notification == 1
	}
	var blocked_user_ids: String?
	var isBlocked: Bool {
		if Common.user!.blocked_user_ids == nil {
			return false
		}
		let blockedUserArr = Common.user?.blocked_user_ids?.components(separatedBy: ",")
		let idx = blockedUserArr?.firstIndex(of: id)
		return (idx != nil)
	}
	var isBlocking: Bool {
		if blocked_user_ids == nil {
			return false
		}
		let blockedUserArr = blocked_user_ids?.components(separatedBy: ",")
		let idx = blockedUserArr?.firstIndex(of: Common.user!.id)
		return (idx != nil)
	}
	var followed_books: String?
	var last_activity_on: String?
	var last_login: String?
	var verification_status: String?
	var isVerified: Bool {
		return (verification_status == "Verified")
	}
	var updated_on: String?
	var created_on: String?
	var status: String?
	var connectionCount: Int?
	var friendsCount: Int?
	var friendShipData: FriendShipData?
	var metrics: Metrics?
}
