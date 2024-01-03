//
//  SingleTimeStoryView.swift
//  blk
//
//  Created by Nabeel Shafique on 07/11/2022.
//

import SwiftUI
import _AVKit_SwiftUI

struct SingleTimeStoryView: View {
	
	var story: TimeStory
	@StateObject var viewModel = TimeStoriesViewModel()
	@StateObject var commentsModel = CommentsViewModel()
	
    var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
			
			ScrollView {
				VStack {
					TimeStoryView(story: story, isList: false)
					
					DividerView()
						.margin(bottom: 29)
					
					CommentListView()
						.margin(bottom: 130)
				}
			}
			.margin(top: 100)
						
			AddCommentView(postId: story.id, type: .timeStories)
				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
			
			CommonView(viewModel: .constant(commentsModel))
		}
		.environmentObject(commentsModel)
		.adaptsToKeyboard()
		.ignoresSafeArea()
		.navigationBarColor(ColorX.secondaryBg)
		.toolbar {
			ToolbarItemGroup(placement: .principal) {
				NavTitleView(title: "")
			}
		}
		.onAppear(){
			
			viewModel.viewStory(story)
			
			commentsModel.getComments(postId: story.id, type: .timeStories) {message,status in
				if status != .success {
					
				}
			}
		}
    }
}

struct SingleTimeStoryView_Previews: PreviewProvider {
    static var previews: some View {
		let timeStories: [TimeStory] = load("time_stories.json")
		SingleTimeStoryView(story: timeStories[3])
    }
}
