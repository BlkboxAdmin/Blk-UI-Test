//
//  TimeStory.swift
//  blk
//
//  Created by Nabeel Shafique on 07/11/2022.
//

import Foundation

struct BlkTimeStoryData: Codable {
	let data: TimeStoryData
}

struct BlkTimeStorySingleData: Decodable {
	let data: TimeStory
}

struct TimeStoryData: Codable {
	let rows: [TimeStory]
	let page: Int
	let perPage: Int
	let offset: Int
	let totalRows: Int
	let totalPages: Int
}

struct TimeStory: Codable, Hashable, Identifiable {
	var id: String
	var description: String
	var liked_by: String
	var favCount: Int?
	var video: String
	var videoUrl: String {
		return UploadedVideo.getUrl(videoId: video)
	}
	var videoThumbnail: String {
		return UploadedVideo.getThumbnail(videoId: video)
	}
	var repost_count: Int
	var comment_count: Int?
	var parent_story: String
	var expiring_on: String
	var created_by: String
	var updated_on: String
	var created_on: String
	var status: String
	var user: User?	
}

struct Metrics: Codable, Hashable {
	var totalVideoViews: Int
	var totalVideoLikeCount: Int
	var totalVideoCommentCount: Int
	var videoCount: Int
}
