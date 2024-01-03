//
//  UserTimeStoriesView.swift
//  blk
//
//  Created by Nabeel Shafique on 03/12/2022.
//

import SwiftUI
import AVKit

struct UserTimeStoriesView: View {
	
	var userId: String
	@StateObject var viewModel = TimeStoriesViewModel()
	@EnvironmentObject var toastControl: ToastControl
	
	let columns = [
		GridItem(.flexible()),
		GridItem(.flexible()),
		GridItem(.flexible())
	]
	
    var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
			
			VStack {
				
				UserImageView( img: viewModel.profile?.imageUrlLG ?? "" ,isVerified: true, size: .large)
					.margin(bottom: 20)
				
				aboutView
				
				HStack {
					counterVeiw(viewModel.profile?.metrics?.totalVideoViews ?? 0, "Videos Watched")
						.frame(maxWidth: .infinity)
					DividerView(direction: .vertical)
						.frame(height: 21)
					counterVeiw(viewModel.profile?.metrics?.totalVideoLikeCount ?? 0, "Liked")
						.frame(maxWidth: 80)
					DividerView(direction: .vertical)
						.frame(height: 21)
					counterVeiw(viewModel.profile?.metrics?.totalVideoCommentCount ?? 0, "Commented on")
						.frame(maxWidth: .infinity)
				}
				.frame(maxWidth: .infinity)
				.margin(bottom: 42)
				
				videosView
				
				Spacer()
			}
			.margin(top: 130)
			
			CommonView(viewModel: .constant(viewModel))
		}
		.ignoresSafeArea()
		.navigationBarColor(ColorX.secondaryBg)
		.toolbar {
			ToolbarItemGroup(placement: .principal) {
				NavTitleView(title: viewModel.profile?.name ?? "")
			}
			
			ToolbarItemGroup(placement: .navigationBarTrailing) {
				NavigationLink(destination: SettingsView(), label: {
					Image("settings")
				})
			}
		}
		.task {
			viewModel.getProfile(userId: userId) {message,status in
				if status != .success {
					toastControl.toast(message, status)
				}
			}
			viewModel.getMyTimeStories(userId: userId)
		}
    }
	
	func counterVeiw(_ count: Int, _ label: String) -> some View {
		VStack {
			Text(count.shorted)
				.foregroundColor(.white)
				.fontBold(.semibold)
				.fontSize(23)
				.margin(bottom: 5)
			
			Text(label)
				.foregroundColor(ColorX.thirdFg)
				.fontSize(14)
		}
	}
	
	var videosView: some View {
		ScrollView {
			LazyVGrid(columns: columns, spacing: 0) {
				ForEach(viewModel.myTimeStories, id: \.self) { item in
					
					ZStack {
						AsyncImage(url: URL(string: item.videoThumbnail)){ image in
							image
								.resizable(resizingMode: .stretch)
								.aspectRatio(contentMode: .fit)
						} placeholder: {
							Image(systemName: "video")
								.imageScale(.large)
								.foregroundColor(.gray)
						}
						.frame(height: 100)
						
//						let player = AVPlayer(url: URL(string: item.videoUrl)!)
//						VideoPlayer(player: player)
//							.frame(height: 100)
//							.onAppear() {
//								player.isMuted = true
//								player.play()
//
//							}
						GeometryReader { geo in
							NavigationLink(destination: SingleTimeStoryView(story: item), label: {
								Text("")
									.frame(maxWidth: .infinity, maxHeight: .infinity)
							})
						}
					}
					
				}
			}
		}
	}
	
	var aboutView: some View {
		VStack {
			Text(viewModel.profile?.name ?? "")
				.foregroundColor(.white)
				.fontSize(23)
				.fontBold(.medium)
				.margin(bottom: 5)
			Text("@\(viewModel.profile?.username ?? "")")
				.foregroundColor(ColorX.secondaryFg)
				.fontSize(18)
				.margin(bottom: 15)
			Text("\(viewModel.profile?.metrics?.videoCount ?? 0) Videos")
				.padding(.horizontal, 20)
				.padding(.vertical, 10)
				.background(ColorX.secondaryBg)
				.foregroundColor(ColorX.secondaryFg)
				.cornerRadius(7)
				.fontSize(16)
				.margin(bottom: 41)
		}
	}
}

struct UserTimeStoriesView_Previews: PreviewProvider {
    static var previews: some View {
		UserTimeStoriesView(userId: "1")
    }
}
