//
//  TimeStoryView.swift
//  blk
//
//  Created by Nabeel Shafique on 03/12/2022.
//

import SwiftUI
import AVFoundation
import _AVKit_SwiftUI

struct TimeStoryView: View {
	
	var story: TimeStory
	var isList: Bool = false
	var onFavAction: ((String) -> Void)? = nil
	var onRepostAction: ((TimeStory) -> Void)? = nil
	
    var body: some View {
		VStack {
			HStack {
				NavigationLink(destination: UserTimeStoriesView(userId: story.user!.id), label: {
					UserImageView(img: story.user?.imageUrlSM ?? "", isVerified: story.user?.isVerified ?? false)
				})
				VStack(alignment: .leading) {
					Text(story.user?.name ?? "")
						.foregroundColor(.white)
						.fontSize(16)
					Text("@\(story.user?.username ?? "")")
						.foregroundColor(ColorX.primaryFg)
						.fontSize(14)
				}
				Spacer()
				Text(story.created_on.toTimeAgo)
					.foregroundColor(ColorX.primaryFg)
			}
			.margin(bottom: 23)
				
			if !isList {
				Text(story.description)
					.foregroundColor(.white)
					.fontSize(20)
					.margin(bottom: 49)
			}
			
			let player = AVPlayer(url: (URL(string: story.videoUrl) ?? URL(string: ""))!)
			
			ZStack {
				VideoPlayer(player: player)
					.frame(height: 256)
					.onAppear() {
						player.isMuted = true
						player.pause()
						
					}
//				GeometryReader { geo in
//					NavigationLink(destination: SingleTimeStoryView(story: story), label: {
//						Text("")
//							.frame(maxWidth: .infinity, maxHeight: .infinity)
//					})
//				}
			}
			
			HStack {
				
				Button(action: {
					onFavAction?(story.id)
				}, label: {
					BadgeCountView(count: story.favCount!, icon: .heart)
						.margin(right: 22)
				})
				
				NavigationLink(destination: SingleTimeStoryView(story: story), label: {
					BadgeCountView(count: story.comment_count!, icon: .comments)
						.margin(right: 22)
				})
				
				Button(action: {
					onRepostAction?(story)
				}, label: {
					BadgeCountView(count: story.repost_count, icon: .repost)
				})
				
				Spacer()
				
				if !isList {
					NavigationLink(destination: FullScreenVideoView(story: story), label: {
						Image(systemName: "camera.metering.multispot")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.foregroundColor(.white)
							.frame(height: 23)
							.margin(right: 8)
					})
				}
			}
			.margin(top: 20 ,bottom: 23)
			
			if isList {
				DividerView()
			}
		}
		.padding(.leading, 23)
		.padding(.trailing, 19)
		.padding(.top, 19)
		.padding(.bottom, 26)
		.background(.black)
    }
}

struct TimeStoryView_Previews: PreviewProvider {
    static var previews: some View {
		let feed: [TimeStory] = load("time_stories.json")
		TimeStoryView(story: feed[0])
    }
}
