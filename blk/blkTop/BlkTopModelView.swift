//
//  BlkTopModelView.swift
//  blk
//
//  Created by Nabeel Shafique on 02/11/2022.
//

import Foundation

class BlkTopViewModel: BaseViewModel {
	
	@Published var connectionCount: Int = 0
	@Published var friendsCount: Int = 0
	@Published var feed: [Story] = []
	
	func renderUser()
	{
		connectionCount = Common.user?.connectionCount ?? 0
		friendsCount = Common.user?.friendsCount ?? 0
	}
	
	func getFeed()
	{
		let formData: [String: Any] = [
			"type": "both"
		]
		postRequest(endPoint: "/api/stories/listing/1", params: formData) { data, status, message in

			if (status == .success) {

				let response = try! JSONDecoder().decode(BlkStoryData.self, from: data)
				let detail = response.data

				DispatchQueue.main.async {
					self.feed = detail.rows
				}

			}
			else {
				print(message)
			}
		}
		
	}
	
	func fav(storyId: String, callback: callback)
	{
		putRequest(endPoint: "/api/stories/fav/\(storyId)") { data, status, message  in
			
			if (status == .success) {
				self.getFeed()
			}
			
			callback?(message, status)
		}
	}
	
	func repost(story: Story, callback: callback)
	{
		let formData: [String: Any] = [
			"description": story.description,
			"image": story.image
		]
		putRequest(endPoint: "/api/stories/repost/\(story.id)", params: formData) { data, status, message  in
			
			if (status == .success) {
				self.getFeed()
			}
			
			callback?(message, status)
		}
	}
}
