//
//  TimeStoriesView.swift
//  blk
//
//  Created by Nabeel Shafique on 01/11/2022.
//

import SwiftUI
import AVKit

struct TimeStoriesView: View {
	
	@StateObject var viewModel = TimeStoriesViewModel()
	
    var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
			
			VStack {
				ScrollView {
					LazyVStack(spacing: 15) {
						ForEach(viewModel.timeStories, id: \.self) { item in
							
							TimeStoryView(story: item, isList: true , onFavAction: { storyId in
								viewModel.fav(storyId: storyId) {message,status in
								}
							}, onRepostAction: { story in
								viewModel.repost(story: story) {message,status in
								}
							})
						}
					}
				}
			}
			.margin(top: 100)
			.task {
				viewModel.getTimeStories()
			}
			
			CommonView(viewModel: .constant(viewModel))
		}
		.ignoresSafeArea()
		.navigationBarColor(ColorX.secondaryBg)
		.toolbar {
			ToolbarItemGroup(placement: .principal) {
				NavTitleView(title: "Fades")
			}
			ToolbarItemGroup(placement: .navigationBarTrailing) {
				NavigationLink(destination: AddTimeStoryView(), label: {
					Image("plus-circle")
				})
			}
		}
    }
}

struct TimeStoriesView_Previews: PreviewProvider {
    static var previews: some View {
        TimeStoriesView()
    }
}
