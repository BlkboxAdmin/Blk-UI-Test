//
//  SingleBookView.swift
//  blk
//
//  Created by Nabeel Shafique on 02/11/2022.
//

import SwiftUI

struct SingleBookView: View {
	
	@StateObject var viewModel = BookViewModel()
	@StateObject var commentsModel = CommentsViewModel()
	@EnvironmentObject var toastControl: ToastControl
	
	var book: Book
	
    var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
			
			VStack {
				BookView(book: book, isListView: false)
				VStack {
					DividerView()
						.margin(bottom: 29)
					
					Spacer()
					
					if book.isFollowed {
						CommentListView()
					}
				}
				.background(ColorX.secondaryBg)
			}
			.margin(top: 100)
			.onAppear(){
				if book.isFollowed {
					commentsModel.getComments(postId: book.id) {message,status in
						if status != .success {
							
						}
					}
				}
			}
			
			if book.isFollowed {
				AddCommentView(postId: book.id)
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
			}
			
			CommonView(viewModel: .constant(viewModel))
		}
		.environmentObject(commentsModel)
		.adaptsToKeyboard()
		.ignoresSafeArea()
		.navigationBarColor(ColorX.secondaryBg)
		.toolbar {
			ToolbarItemGroup(placement: .principal) {
				NavTitleView(title: "BlkBook")
			}
		}
    }
}

struct SingleBookView_Previews: PreviewProvider {
    static var previews: some View {
		let books: [Book] = load("books.json")
		SingleBookView(book: books[0])
    }
}
