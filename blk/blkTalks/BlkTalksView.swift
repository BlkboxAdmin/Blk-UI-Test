//
//  BlkTalksView.swift
//  blk
//
//  Created by Nabeel Shafique on 01/11/2022.
//

import SwiftUI

struct BlkTalksView: View {
	
	//@ObservedObject var appState = AppState.shared
	@StateObject var viewModel = TalksViewModel()
	
    var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
			
//			if viewModel.navigate {
//				NavigationLink(destination: ChatView(chat: appState.chat!), isActive: $viewModel.navigate) { EmptyView() }
//			}
			
			VStack(alignment: .leading) {

				
				TextFieldView(value: $viewModel.query, placeholder: "Search")
					.margin(bottom: 36)
					.onSubmit {
						viewModel.getChats(nil)
					}
				
				chatListView
				
				Spacer()
			}
			.padding(.horizontal, 22)
			.margin(top: 30)
			.onAppear() {
				viewModel.getChats() {message,status in
//					if appState.notificationType == .message {
//						appState.chat = viewModel.chats.first { ($0.sender_user_id == appState.sender_user_id && $0.receiver_user_id == appState.receiver_user_id) || ($0.sender_user_id == appState.receiver_user_id && $0.receiver_user_id == appState.sender_user_id) }
//					}
				}
			}
//			.onReceive(appState.$chat) { chat in
//
//				viewModel.navigate = (chat != nil)
//			}
			
			CommonView(viewModel: .constant(viewModel))
		}
		.navigationBarColor(ColorX.secondaryBg)
		.toolbar {
			ToolbarItemGroup(placement: .principal) {
				NavTitleView(title: "Chats")
			}
		}
    }
	
	var chatListView: some View {
		ScrollView {
			LazyVStack(alignment: .leading ,spacing: 27) {
				ForEach(viewModel.chats, id: \.self) { item in
					NavigationLink(destination: ChatView(chat: item), label: {
						UserRowView(user: item.user!)
					})
				}
			}
		}
	}
}

struct BlkTalksView_Previews: PreviewProvider {
    static var previews: some View {
        BlkTalksView()
    }
}
