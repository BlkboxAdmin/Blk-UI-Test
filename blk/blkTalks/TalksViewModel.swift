//
//  TalksViewModel.swift
//  blk
//
//  Created by Nabeel Shafique on 04/11/2022.
//

import Foundation

class TalksViewModel: BaseViewModel {
	
	@Published var task: Bool = true
	@Published var query: String = ""
	@Published var newMessage: String = ""
	@Published var activeThreadId: String = ""
	@Published var chats: [Chat] = []
	@Published var messages: [Message] = []
	
	func getChats(_ callback: callback)
	{
		postRequest(endPoint: "/api/blktalks/search_recipients?q=\(query)") { data, status, message  in
			
			if (status == .success) {
				let detail = try! JSONDecoder().decode(ChatData.self, from: data)
				self.chats = detail.data
			}
			
			callback?(message, status)
		}
	}
	
	func openChat(chat: Chat ,callback: callback) {
		let formData: [String: Any] = [
			"recipient_user_id": chat.user!.id
		]
		postRequest(endPoint: "/api/blktalks/thread", params: formData) { data, status, message  in
			
			if (status == .success) {
				let detail = try! JSONDecoder().decode(ThreadData.self, from: data)
				self.activeThreadId = detail.data.id
				self.task = true
				self.getMessages()
			}
			
			callback?(message, status)
		}
	}
	
	func getMessages()
	{
		let formData: [String: Any] = [
			"threadId": activeThreadId
		]
		postRequest(endPoint: "/api/blktalks/thread_messages/1", params: formData) { data, status, message  in
			
			if (status == .success) {
				let detail = try! JSONDecoder().decode(MessageListData.self, from: data)
				let response = detail.data
				self.messages = response.rows
			}
		}
	}
	
	func createMessage(callback: callback) {
		let formData: [String: Any] = [
			"thread_id": activeThreadId,
			"message_text": newMessage
		]
		postRequest(endPoint: "/api/blktalks/message", params: formData) { data, status, message  in
			
			if (status == .success) {
				self.newMessage = ""
			}
			
			callback?(message, status)
		}
	}
	
	func checkNewMeessage()
	{
		let formData: [String: Any] = [
			"threadId": activeThreadId,
			"lastMessageId": messages.last?.id ?? "anything"
		]
		postRequest(endPoint: "/api/blktalks/thread_new_message", params: formData) { data, status, message  in
			
			if (status == .success) {
				let detail = try! JSONDecoder().decode(NewMessageData.self, from: data)
				if detail.data {
					self.getMessages()
				}
			}
			
		}
	}
}
