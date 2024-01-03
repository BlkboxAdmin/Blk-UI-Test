//
//  Book.swift
//  blk
//
//  Created by Nabeel Shafique on 02/11/2022.
//

import Foundation

struct BlkBookData: Decodable {
	let data: BookData
}

struct BlkBookSingleData: Decodable {
	let data: Book
}

struct BookData: Decodable {
	let rows: [Book]
	let page: Int
	let perPage: Int
	let offset: Int
	let totalRows: Int
	let totalPages: Int
}

struct Book: Codable, Hashable, Identifiable {
	var id: String
	var description: String
	var liked_by: String
	var disliked_by: String
	var like_count: Int
	var dislike_count: Int
	var comment_count: Int
	var isFollowed: Bool {
		let bookIdArr = Common.user?.followed_books?.components(separatedBy: ",")
		let idx = bookIdArr?.firstIndex(of: id)
		return (idx != nil)
	}
	var isEditable: Bool {
		return (created_by == Common.user!.id)
	}
	var created_by: String
	var updated_on: String
	var created_on: String
	var status: String
	var user: User?
	
}
