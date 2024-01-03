//
//  Story.swift
//  blk
//
//  Created by Nabeel Shafique on 02/11/2022.
//

import Foundation

struct BlkStoryData: Codable {
	let data: StoryData
}

struct StoryData: Codable {
	let rows: [Story]
	let page: Int
	let perPage: Int
	let offset: Int
	let totalRows: Int
	let totalPages: Int
}

struct Story: Codable, Hashable, Identifiable {
	var id: String
	var type: String
	var description: String
	var imageDefault: String {
		return "default-img"
	}
	var image: String
	var imageUrl: String {
		return UploadedImage.getUrl(imageId: image)
	}
	var parent_story: String?
	var favs: String?
	var favCount: Int
	var repost_count: Int?
	var repostCount: Int {
		return repost_count ?? 0
	}
	var created_by: String
	var updated_on: String
	var created_on: String
	var status: String
	var user: User?
	
}
