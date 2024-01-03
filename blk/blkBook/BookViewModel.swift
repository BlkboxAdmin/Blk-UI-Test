//
//  BookViewModel.swift
//  blk
//
//  Created by Nabeel Shafique on 02/11/2022.
//

import Foundation

class BookViewModel: BaseViewModel {
	
	@Published var books: [Book] = []
	
	func getBookFeed()
	{
		postRequest(endPoint: "/api/blkbooks/listing/1") { data, status, message  in

			if (status == .success) {

				let response = try! JSONDecoder().decode(BlkBookData.self, from: data)
				let detail = response.data

				DispatchQueue.main.async {
					self.books = detail.rows

				}

			}
		}
	}
	
	func like(book: Book, callback: callback)
	{
		putRequest(endPoint: "/api/blkbooks/like/\(book.id)") { data, status, message  in
			
			if (status == .success) {
				self.getBookFeed()
			}
			
			callback?(message, status)
		}
	}
	
	func dislike(book: Book, callback: callback)
	{
		putRequest(endPoint: "/api/blkbooks/dislike/\(book.id)") { data, status, message  in
			
			if (status == .success) {
				self.getBookFeed()
			}
			
			callback?(message, status)
		}
	}
	
	func follow(book: Book, callback: callback)
	{
		putRequest(endPoint: "/api/blkbooks/follow/\(book.id)") { data, status, message  in
			
			if (status == .success) {
				self.postRequest(endPoint: "/api/user/profile/\(Common.user!.id)") { data, status, message  in
					
					if (status == .success) {
						let detail = try! JSONDecoder().decode(UserProfile.self, from: data)
						Common.user = detail.data
						saveUserPref(Common.userKey, Common.user!)
						
						self.getBookFeed()
					}
				}
				
			}
			
			callback?(message, status)
		}
	}
}
