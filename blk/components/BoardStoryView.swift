//
//  BoardStoryView.swift
//  blk
//
//  Created by Nabeel Shafique on 02/11/2022.
//

import SwiftUI

struct BoardStoryView: View {
	
	var story: Story
	
    var body: some View {
		ZStack {
			
			AsyncImage(url: URL(string: story.imageUrl)) { image in
				image
					.resizable()
					.aspectRatio(contentMode: .fill)
			} placeholder: {
				Image(story.imageDefault)
					.resizable(resizingMode: .stretch)
					.aspectRatio(contentMode: .fill)
			}
			.frame(maxWidth: .infinity, maxHeight: 172.0)
			.clipped()
			.cornerRadius(10)
			.allowsHitTesting(false)
			
			GeometryReader { geo in
				Text( story.created_on.toTimeAgo )
					.foregroundColor(ColorX.primaryFg)
					.position(x: geo.frame(in: .local).midX - 120, y: geo.frame(in: .local).midY + 60)
			}

			GeometryReader { geo in
				VStack(alignment: .trailing) {
					HStack {
						Spacer()

						BadgeCountView(count: story.repostCount, icon: .repost)

						BadgeCountView(count: story.favCount, icon: .heart)
							.margin(left: 18)
					}

				}
				.position(x: geo.frame(in: .local).midX - 17, y: geo.frame(in: .local).midY + 60)
			}
		}
    }
}

struct BoardStoryView_Previews: PreviewProvider {
    static var previews: some View {
		let stories: [Story] = load("stories.json")
        BoardStoryView(story: stories[0])
    }
}
