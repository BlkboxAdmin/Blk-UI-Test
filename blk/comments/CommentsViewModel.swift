//
//  CommentsViewModel.swift
//  blk
//
//  Created by Nabeel Shafique on 05/12/2022.
//

import Foundation

class CommentsViewModel: BaseViewModel {
	
	@Published var comments: [Comment] = []
	@Published var newCommentText: String = ""
	
	func getComments(postId: String, type: CommentFor = .books, callback: callback)
	{
		if postId.isEmpty {
			callback?("Invalid ID", .error)
			return
		}
		
		let formData: [String: Any] = [
			"type": type.rawValue,
			"post_id": postId
		]
		postRequest(endPoint: "/api/comments/listing/1", params: formData) { data, status, message  in
			
			if (status == .success) {
				let response = try! JSONDecoder().decode(CommentData.self, from: data)
				let detail = response.data
				self.comments = detail.rows
			}
			
			callback?(message, status)
		}
	}
	
	func addComment(postId: String, type: CommentFor = .books , callback: callback) {
		
		let formData: [String: Any] = [
			"type": type.rawValue,
			"post_id": postId,
			"comment_text": newCommentText
		]
		postRequest(endPoint: "/api/comments/new", params: formData) { data, status, message  in
			
			if (status == .success) {
				self.newCommentText = ""
				self.getComments(postId: postId, type: type, callback: callback)
			}
			
			callback?(message, status)
		}
	}
}

enum CommentFor: String {
	case books = "books"
	case timeStories = "time_stories"
}
