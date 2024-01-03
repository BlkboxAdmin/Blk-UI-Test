//
//  BlkTopView.swift
//  blk
//
//  Created by Nabeel Shafique on 01/11/2022.
//

import SwiftUI

struct BlkTopView: View {
	
	@StateObject var viewModel = BlkTopViewModel()
	@EnvironmentObject var toastControl: ToastControl
	
	var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
			VStack(alignment: .leading) {
				headerView
					.margin(bottom: 30)
				VStack {
					connectionsInfoView
						.margin(bottom: 49)
					feedView
					
					Spacer()
				}
				.padding(.horizontal, 22)
			}
			
			GeometryReader { geo in
				NavigationLink(destination: AddBookView(type: .story), label: {
					Image("add-button")
				})
				.position(x: geo.frame(in: .local).maxX - 52, y: geo.frame(in: .local).maxY - 72)
			}
			
			CommonView(viewModel: .constant(viewModel))
		}
		.ignoresSafeArea()
		.onAppear() {
			viewModel.getFeed()
		}
	}
	
	var feedView: some View {
		VStack(alignment: .leading) {
			Text("Your Feed")
				.foregroundColor(.white)
				.fontSize(23)
				.margin(bottom: 24)
				.multilineTextAlignment(.leading)
			
			ScrollView {
				LazyVStack(spacing: 28) {
					ForEach(viewModel.feed, id: \.self) { item in
						
						StoryView(story: item,
								  onFavAction: { id in
							viewModel.fav(storyId: id) {message,status in
								toastControl.toast(message, status)
							}
						},
								  onRepostAction: { story in
							viewModel.repost(story: story) {message,status in
								toastControl.toast(message, status)
							}
							
						})
					}
				}
			}
		}
	}
	
	var connectionsInfoView: some View {
		VStack(spacing: 11) {
			connectionView(icon: "people", title: "Connections", count: viewModel.connectionCount)
			connectionView(icon: "friends", title: "Friends", count: viewModel.friendsCount)
		}
		.onAppear() {
			viewModel.renderUser()
		}
	}
	
	func connectionView(icon: String, title: String, count: Int) -> some View {
		
		return HStack {
			Image(icon)
				.margin(right: 21)
			Text(title)
				.foregroundColor(.white)
				.fontSize(20)
			Spacer()
			Text(count.toString)
				.foregroundColor(.white)
				.fontSize(20)
				.fontBold()
		}
		.padding(.leading, 18)
		.padding(.trailing, 23)
		.padding(.top, 19)
		.padding(.bottom, 23)
		.background(ColorX.secondaryBg)
		.cornerRadius(11)
	}
	
	var headerView: some View {
		VStack {
			HStack {
				
				NavigationLink(destination: SettingsView(), label: {
					Image("settings")
						.margin(left: 12)
				})
				
				Spacer()
				
				NavTitleView(title: "The BlkTop")
				
				Spacer()
				
				Button(action: {
					
				}, label: {
					Image("credit-card")
				})
				.frame(width: 30)
				.margin(right: 12)
			}
			.margin(top: 70, bottom: 22)
		}
		.frame(maxWidth: .infinity)
		.background(ColorX.secondaryBg)
		.cornerRadius(22)
	}
}

struct BlkTopView_Previews: PreviewProvider {
    static var previews: some View {
        BlkTopView()
    }
}
