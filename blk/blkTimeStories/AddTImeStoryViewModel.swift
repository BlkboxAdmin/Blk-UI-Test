//
//  AddTImeStoryViewModel.swift
//  blk
//
//  Created by Nabeel Shafique on 03/12/2022.
//

import Foundation

class AddTimeStoryViewModel: BaseViewModel {
	
	@Published var description: String = ""
	@Published var video: String = ""
	var videoUrl: String {
		return UploadedVideo.getUrl(videoId: video)
	}
	@Published var expiringOn: String = "2022-12-09 00:00:00"
	@Published var parentStory: String = ""
	
	func getStory(storyId: String, callback: callback)
	{
		postRequest(endPoint: "/api/time_stories/single/\(storyId)") { data, status, message  in
			
			if (status == .success) {
				let detail = try! JSONDecoder().decode(BlkTimeStorySingleData.self, from: data)
				self.description = detail.data.description
				self.video = detail.data.video
				self.expiringOn = detail.data.expiring_on
				self.parentStory = detail.data.parent_story
			}
			
			callback?(message, status)
		}
	}
	
	func addStory(callback: callback)
	{
		if video.isEmpty {
			callback?("Please upload a video", .error)
			return
		}
		
		let formData: [String: Any] = [
			"description": description,
			"video": video,
			"expiring_on": expiringOn,
			"parent_story": parentStory
		]
		postRequest(endPoint: "/api/time_stories/new", params: formData) { data, status, message  in
			
			if (status == .success) {
				self.resetForm()
			}
			
			callback?(message, status)
		}
	}
	
	func uploadVideo(video: String, callback: callBackUploadData)
	{
		uploadVideoRequest(video: URL(string: video)! , fileName: UploadedVideo.getFileName(entity: .story), callback)
	}
	
	func resetForm()
	{
		description = ""
		video = ""
		expiringOn = ""
		parentStory = ""
	}
}
