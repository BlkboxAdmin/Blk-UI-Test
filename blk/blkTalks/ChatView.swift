//
//  ChatView.swift
//  blk
//
//  Created by Nabeel Shafique on 04/11/2022.
//

import SwiftUI

struct ChatView: View {
	
	var chat: Chat
	@StateObject var viewModel = TalksViewModel()
	@EnvironmentObject var toastControl: ToastControl
	
    var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
			
			VStack {
				messagesListView
				Spacer()
				sendMessageView
			}
			.adaptsToKeyboard()
			.padding(.horizontal, 22)
			.task {
				viewModel.openChat(chat: chat) {message,status in
					if status != .success {
						toastControl.toast(message, status)
					}
				}
				
				repeat {
					viewModel.checkNewMeessage()
					
					try? await Task.sleep(nanoseconds: 5_000_000_000)
				} while (viewModel.task)
				
			}
		}
		.navigationBarColor(ColorX.secondaryBg)
		.toolbar {
			ToolbarItemGroup(placement: .principal) {
				NavTitleView(title: chat.user!.fullname!)
			}
		}
		.onDisappear() {
			viewModel.task = false
		}
    }
	
	func singleMessage(_ message: Message) -> some View {
		VStack {
			if message.isOtherUserMsg {
				HStack(alignment: .top) {
					AsyncImage(url: URL(string: message.user.imageUrlSM)) { image in
						image
							.resizable(resizingMode: .stretch)
							.aspectRatio(contentMode: .fit)
					} placeholder: {
						Image(message.user.imageDefault)
							.resizable(resizingMode: .stretch)
							.aspectRatio(contentMode: .fit)
					}
					.frame(width: 38, height: 38)
					.clipped()
					.cornerRadius(5)
					
					HStack(alignment: .top) {
						Image(systemName: "arrowtriangle.left.fill")
							.frame(width: 17, height: 17)
							.foregroundColor(ColorX.selectedFg)
							.offset(x: 15, y: 12)
						
						VStack (alignment: .leading) {
							Text(message.message_text)
								.padding(.leading, 16)
								.padding(.bottom, 16)
								.padding(.top, 13)
								.padding(.trailing, 13)
								.background(ColorX.selectedFg)
								.cornerRadius(11)
								.fontSize(13)
							
							Text(message.created_on.toTimeAgo)
								.foregroundColor(ColorX.thirdFg)
								.fontSize(11)
						}
					}
					.offset(x: -15)
					Spacer()
				}
			} else {
				HStack(alignment: .top) {
					Spacer()
					HStack(alignment: .top) {
						VStack(alignment: .trailing) {
							Text(message.message_text)
								.padding(.leading, 16)
								.padding(.bottom, 16)
								.padding(.top, 13)
								.padding(.trailing, 13)
								.background(ColorX.secondaryBg)
								.foregroundColor(.white)
								.cornerRadius(11)
								.fontSize(13)
							
							Text(message.created_on.toTimeAgo)
								.foregroundColor(ColorX.thirdFg)
								.fontSize(11)
						}
						
						Image(systemName: "arrowtriangle.right.fill")
							.frame(width: 17, height: 17)
							.foregroundColor(ColorX.secondaryBg)
							.offset(x: -15, y: 12)
					}
					.offset(x: 15)
					
					AsyncImage(url: URL(string: message.user.imageUrlSM)) { image in
						image
							.resizable(resizingMode: .stretch)
							.aspectRatio(contentMode: .fit)
					} placeholder: {
						Image(message.user.imageDefault)
							.resizable(resizingMode: .stretch)
							.aspectRatio(contentMode: .fit)
					}
					.frame(width: 38, height: 38)
					.clipped()
					.cornerRadius(5)
				}
			}
		}
	}
	
	var messagesListView: some View {
		
		ScrollView {
			ScrollViewReader { value in
				LazyVStack(spacing: 33) {
					ForEach(viewModel.messages, id: \.self) { item in
						singleMessage(item)
							.id(item.id)
					}
				}
				.onChange(of: viewModel.messages.count) { _ in
					value.scrollTo(viewModel.messages.last?.id)
				}
			}
		}
	}
	
	var sendMessageView: some View {
		VStack {
			TextFieldView(value: $viewModel.newMessage, placeholder: "Type Message", customIcon: "send") {
				viewModel.createMessage() {message,status in
					if status != .success {
						toastControl.toast(message, status)
					}
				}
			}
		}
		.margin(bottom: 35)
		.background(.black)
	}
	
	func getIdx(_ i: Int) -> Int {
		return i + 1
	}
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
		let chats: [Chat] = load("chats.json")
        ChatView(chat: chats[0])
    }
}
