//
//  CommentListView.swift
//  blk
//
//  Created by Nabeel Shafique on 05/12/2022.
//

import SwiftUI

struct CommentListView: View {
	
	@EnvironmentObject var viewModel: CommentsViewModel
	
    var body: some View {
		VStack(alignment: .leading) {
			Text("Comments")
				.foregroundColor(.white)
				.fontSize(23)
				.fontBold(.medium)
				.margin(bottom: 11)
			
			ScrollView {
				LazyVStack(alignment: .leading ,spacing: 15) {
					ForEach(viewModel.comments, id: \.self) { item in
						
						commentView(item)
						
						DividerView()
					}
				}
			}
		}
		.padding(.horizontal, 22)
    }
	
	func commentView(_ comment: Comment) -> some View {
		VStack(alignment: .leading) {
			Text(comment.comment_text)
				.foregroundColor(.white)
				.fontSize(15)
				.margin(bottom: 8)
			
			Text("@\(comment.user?.username ?? "") \(comment.created_on.toTimeAgo)")
				.foregroundColor(ColorX.primaryFg)
		}
	}
}

struct CommentListView_Previews: PreviewProvider {
	
	static var viewModel = CommentsViewModel()
	
    static var previews: some View {
        CommentListView()
			.environmentObject(viewModel)
    }
		
}
