//
//  BlkBoardView.swift
//  blk
//
//  Created by Nabeel Shafique on 01/11/2022.
//

import SwiftUI

struct BlkBoardView: View {
	
	var userId: String = ""
	@StateObject var viewModel = BoardViewModel()
	@State private var viewAllActivities: Bool = false
	@State private var showingOptions = false
	@EnvironmentObject var toastControl: ToastControl
	
    var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
			
			VStack (alignment: .leading) {
				
				aboutView
					.margin(bottom: 40)
				ScrollView {
					VStack {
						recentActivityView
							.margin(bottom: 30)
						
						boardView
					}
				}
				.padding(.horizontal, 22)
			}
			
			CommonView(viewModel: .constant(viewModel))
		}
		.navigationBarColor(ColorX.secondaryBg)
		.toolbar {
			ToolbarItemGroup(placement: .navigationBarTrailing) {
				let isOtherUser = (viewModel.profile?.id ?? userId) != Common.user!.id
				if isOtherUser {
					rightNavButtonView
				}
			}
			ToolbarItemGroup(placement: .principal) {
				NavTitleView(title: viewModel.profile?.name ?? "", icon: (viewModel.profile?.showOnline ?? false) ? "online" : "")
			}
		}
    }
	
	var boardView: some View {
		VStack(alignment: .leading) {
			Text("BlkBoard")
				.fontSize(23)
				.foregroundColor(.white)
				.fontBold(.medium)
				.margin(bottom: 16)
			
			LazyVStack(spacing: 16) {
				ForEach(viewModel.stories, id: \.self) { item in
					
					BoardStoryView(story: item)
				}
			}
		}
		.task {
			viewModel.getBoardData(userId: userId)
		}
	}
	
	var recentActivityView: some View {
		VStack (alignment: .leading) {
			Text("Recent Activity")
				.foregroundColor(.white)
				.fontSize(23)
				.fontBold(.medium)
				.multilineTextAlignment(.leading)
				.margin(bottom: 16)
			
			ScrollView {
				LazyVStack(alignment: .leading, spacing: 16) {
					ForEach(viewModel.activities, id: \.self) { item in
						Text(item.text)
							.foregroundColor(ColorX.primaryFg)
							.fontSize(18)
					}
				}
			}
			.frame(maxHeight: viewAllActivities ? .infinity : 105)
			.margin(bottom: 28)
			
			HStack {
				Button(action: {
					viewAllActivities.toggle()
				}, label: {
					
					Text("View More")
						.foregroundColor(ColorX.selectedFg)
						.fontSize(18)
					Image(systemName: viewAllActivities ? "chevron.up" : "chevron.down")
						.foregroundColor(ColorX.selectedFg)
				})
				
				DividerView()
			}
		}
		.task {
			viewModel.getActivities(userId: userId)
		}
	}
	
	var aboutView: some View {
		HStack(alignment: .top) {
			AsyncImage(url: URL(string: viewModel.profile?.imageUrlLG ?? "")) { image in
				image
					.resizable(resizingMode: .stretch)
					.aspectRatio(contentMode: .fit)
			} placeholder: {
				Image(viewModel.profile?.imageDefault ?? "user-default")
					.resizable(resizingMode: .stretch)
					.aspectRatio(contentMode: .fit)
			}
			.frame(width: 107, height: 107)
			.cornerRadius(8)
				
			VStack(alignment: .leading) {
				Text("Who I Am")
					.foregroundColor(.white)
					.fontSize(16)
					.margin(bottom: 6)
				Text("@\(viewModel.profile?.username ?? "")\n\(viewModel.profile?.bio ?? "")")
					.foregroundColor(ColorX.primaryFg)
					.fontSize(16)
					.fixedSize(horizontal: false, vertical: true)
			}
			.margin(left: 25)
		}
		.task {
			viewModel.getProfile(userId: userId) {message,status in
				if status != .success {
					toastControl.toast(message, status)
				}
			}
		}
		.margin(left: 20, right: 15)
	}
	
	var rightNavButtonView: some View {
		Button(action: {
			showingOptions = true
		}, label: {
			Image("more-vertical")
				.font(.title)
				.foregroundColor(.white)
		})
		.confirmationDialog("Actions", isPresented: $showingOptions, titleVisibility: .visible) {
			
			if !(viewModel.profile?.isBlocking ?? true) {
				if (viewModel.profile?.friendShipData?.isInviter ?? true) {
					Button(action: {
						if viewModel.friendBtnTxt() == .addFriend {
							viewModel.invite() {message,status in
								toastControl.toast(message, status)
							}
						}
						
						if viewModel.friendBtnTxt() == .unfriend {
							viewModel.unfriend() {message,status in
								toastControl.toast(message, status)
							}
						}
					}, label: {
						HStack {
							Image("user-plus")
							Text(viewModel.friendBtnTxt().rawValue)
								.fontSize(20)
						}
					})
				}
				else {
					Button(action: {
						viewModel.accept(answer: .accept) {message,status in
							toastControl.toast(message, status)
						}
					}, label: {
						HStack {
							Image("user-plus")
							Text("Accept")
								.fontSize(20)
						}
					})
					
					Button(action: {
						viewModel.accept(answer: .decline) {message,status in
							toastControl.toast(message, status)
						}
					}, label: {
						HStack {
							Image("user-plus")
							Text("Decline")
								.fontSize(20)
						}
					})
				}
			}
			
			if (viewModel.profile?.isBlocked ?? false) {
				Button(action: {
					viewModel.unblockUser() {message,status in
						toastControl.toast(message, status)
					}
				}, label: {
					HStack {
						Image("slash")
						Text("Unblock this user")
							.foregroundColor(ColorX.block)
							.fontSize(20)
					}
				})
			}
			else {
				Button(action: {
					viewModel.blockUser() {message,status in
						toastControl.toast(message, status)
					}
				}, label: {
					HStack {
						Image("slash")
						Text("Block this user")
							.foregroundColor(ColorX.block)
							.fontSize(20)
					}
				})
			}
		}
	}

}

struct BlkBoardView_Previews: PreviewProvider {
    static var previews: some View {
        BlkBoardView()
    }
}
