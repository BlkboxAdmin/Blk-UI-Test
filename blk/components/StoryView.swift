//
//  TileStoryView.swift
//  blk
//
//  Created by Nabeel Shafique on 02/11/2022.
//

import SwiftUI

struct StoryView: View {
	
	var story: Story
	var onFavAction: ((String) -> Void)? = nil
	var onRepostAction: ((Story) -> Void)? = nil
	
	var body: some View {
		VStack {
			HStack {
				NavigationLink(destination: BlkBoardView(userId: story.user!.id), label: {
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
			
			Text(story.description)
				.foregroundColor(.white)
				.fontSize(20)
				.margin(bottom: 49)
			
			if !story.image.isEmpty
			{
				AsyncImage(url: URL(string: UploadedImage.getUrl(imageId: story.image))){ image in
					image
						.resizable(resizingMode: .stretch)
						.aspectRatio(contentMode: .fit)
				} placeholder: {
					Image("default-img")
				}
				.clipped()
				.cornerRadius(10)
				.margin(bottom: 23)
			}
			
			HStack {
				
				Button(action: {
					onFavAction?(story.id)
				}, label: {
					BadgeCountView(count: story.favCount, icon: .heart)
						.margin(right: 22)
				})
				
				Button(action: {
					onRepostAction?(story)
				}, label: {
					BadgeCountView(count: story.repostCount, icon: .repost)
				})
				Spacer()
			}
		}
		.padding(.leading, 23)
		.padding(.trailing, 19)
		.padding(.top, 19)
		.padding(.bottom, 26)
		.background(ColorX.secondaryBg)
		.cornerRadius(11)
	}
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
		let feed: [Story] = load("stories.json")
		StoryView(story: feed[0])
    }
}
