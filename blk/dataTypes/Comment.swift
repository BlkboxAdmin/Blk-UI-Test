//
//  Comment.swift
//  blk
//
//  Created by Nabeel Shafique on 03/11/2022.
//

import Foundation

struct CommentData: Decodable {
	let data: CommentsData
	
}

struct CommentsData: Decodable {
	let rows: [Comment]
	let page: Int
	let perPage: Int
	let offset: Int
	let totalRows: Int
	let totalPages: Int
}

struct Comment: Codable, Hashable, Identifiable {
	var id: String
	var comment_text: String
	var post_id: String
	var created_by: String
	var updated_on: String
	var created_on: String
	var status: String
	var user: User?
	
}
