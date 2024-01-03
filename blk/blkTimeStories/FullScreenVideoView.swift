//
//  FullScreenVideoView.swift
//  blk
//
//  Created by Nabeel Shafique on 05/12/2022.
//

import SwiftUI
import AVFoundation
import _AVKit_SwiftUI

struct FullScreenVideoView: View {
	
	var story: TimeStory
	
    var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
			
			let player = AVPlayer(url: URL(string: story.videoUrl)!)
			VideoPlayer(player: player)
				.onAppear() {
					player.play()
				}
			
		}
		.ignoresSafeArea()
		.navigationBarColor(ColorX.secondaryBg)
		.toolbar {
			ToolbarItemGroup(placement: .principal) {
				NavTitleView(title: "")
			}
		}
    }
}

struct FullScreenVideoView_Previews: PreviewProvider {
    static var previews: some View {
		let timeStories: [TimeStory] = load("time_stories.json")
        FullScreenVideoView(story: timeStories[3])
    }
}
