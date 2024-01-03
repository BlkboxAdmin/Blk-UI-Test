//
//  Upload.swift
//  blk
//
//  Created by Nabeel Shafique on 26/11/2022.
//

import Foundation

struct GenericUpload: Decodable {
	let result: UploadResult
	let success: Bool
	let errors: [String]
	let messages: [String]
}

struct UploadResult: Codable {
	var id: String
	var filename: String?
	var uploaded: String?
	var requireSignedURLs: Bool?
	var variants: [String]?
}

struct UploadUrlData: Decodable {
	let data: UploadUrlInfo
}

struct UploadUrlInfo: Identifiable, Codable {
	var id: String?
	var uploadURL: String?
	var uid: String?
	var media: MediaHost?
}

struct MediaHost: Codable {
	var cf_account_hash: String
	var cf_image_host: String
	var cf_video_host: String
}

struct UploadedImage {
	
	static func getFileName(entity: Entity) -> String {
		
		var fileName: String = "user-id--\(Common.user!.id)"
		
		if entity == .story {
			fileName = "story-\(fileName)"
		}
		
		return fileName
	}
	
	static func getUrl(imageId: String, variant: ImgSize = .original) -> String {
		
		if imageId.isEmpty {
			return ""
		}
		
		return "\(Common.CF_IMG_HOST)/\(Common.CF_ACCOUNT_HASH)/\(imageId)/\(variant.rawValue)"
	}
}

struct UploadedVideo {
	
	static func getFileName(entity: Entity) -> String {
		
		var fileName: String = "user-id--\(Common.user!.id)"
		
		if entity == .story {
			fileName = "timestory-\(fileName)"
		}
		
		return fileName
	}

	static func getThumbnail(videoId: String) -> String {
		
		if videoId.isEmpty {
			return ""
		}
		
		return "\(Common.CF_VIDEO_HOST)/\(videoId)/thumbnails/thumbnail.jpg"
	}
	
	static func getUrl(videoId: String) -> String {
		
		if videoId.isEmpty {
			return ""
		}
		
		return "\(Common.CF_VIDEO_HOST)/\(videoId)/manifest/video.m3u8"
	}
}

enum Entity {
	case user, story
}

enum ImgSize: String {
	case small = "38x38"
	case medium = "60x60"
	case large = "117x117"
	case original = "public"
}
