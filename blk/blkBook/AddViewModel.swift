//
//  AddViewModel.swift
//  blk
//
//  Created by Nabeel Shafique on 23/11/2022.
//

import Foundation
import UIKit


class AddViewModel: BaseViewModel {
	
	@Published var description: String = "Add body text"
	@Published var imageId: String = ""
	var imageUrl: String {
		return UploadedImage.getUrl(imageId: imageId)
	}
	@Published var parentStory: String = ""
	
	func addBook(callback: callback)
	{
		if (description.isEmpty || description == "Add body text") {
			callback?("Please add some text", .error)
			return
		}
		
		let formData: [String: Any] = [
			"description": description
		]
		postRequest(endPoint: "/api/blkbooks/new", params: formData) { data, status, message  in
			
			if (status == .success) {
				self.resetForm()
			}
			
			callback?(message, status)
		}
	}
	
	func updateBook(id: String, callback: callback)
	{
		if (description.isEmpty || description == "Add body text") {
			callback?("Please add some text", .error)
			return
		}
		
		let formData: [String: Any] = [
			"description": description
		]
		putRequest(endPoint: "/api/blkbooks/\(id)", params: formData) { data, status, message  in
			
			if (status == .success) {
				self.resetForm()
			}
			
			callback?(message, status)
		}
	}
	
	func addStory(callback: callback)
	{
		if (description.isEmpty || description == "Add body text") && imageId.isEmpty {
			callback?("Please add some text or image", .error)
			return
		}
		
		let formData: [String: Any] = [
			"description": description == "Add body text" ? "" : description ,
			"image": imageId,
			"parent_story": parentStory
		]
		postRequest(endPoint: "/api/stories/new", params: formData) { data, status, message  in
			
			if (status == .success) {
				self.resetForm()
			}
			
			callback?(message, status)
		}
	}
	
	func getBook(bookId: String, callback: callback)
	{
		postRequest(endPoint: "/api/blkbooks/single/\(bookId)") { data, status, message  in
			
			if (status == .success) {
				let detail = try! JSONDecoder().decode(BlkBookSingleData.self, from: data)
				self.description = detail.data.description
			}
			
			callback?(message, status)
		}
	}
	
	func uploadImage(image: UIImage, callback: callBackUploadData)
	{
		uploadImageRequest(image: image , fileName: UploadedImage.getFileName(entity: .story), callback)
	}
	
	func resetForm()
	{
		description = ""
		imageId = ""
		parentStory = ""
	}
}
