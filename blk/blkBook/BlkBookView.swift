//
//  BlkBookView.swift
//  blk
//
//  Created by Nabeel Shafique on 01/11/2022.
//

import SwiftUI

struct BlkBookView: View {
	
	@StateObject var viewModel = BookViewModel()
	@EnvironmentObject var toastControl: ToastControl
	
    var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
			
			ScrollView {
				
				LazyVStack(alignment: .leading, spacing: 21) {
					ForEach(viewModel.books, id: \.self) { item in
						
						BookView(book: item,
								 onLikeAction: { book in
							viewModel.like(book: book) {message,status in
								toastControl.toast(message, status)
							}
						},
								 onDislikeAction: { book in
							viewModel.dislike(book: book) {message,status in
								toastControl.toast(message, status)
							}
						},
								 onFollowAction: { book in
							viewModel.follow(book: book) {message,status in
								toastControl.toast(message, status)
							}
						})
					}
				}
				.margin(top: 130)
			}
			.padding(.horizontal, 22)
			
			CommonView(viewModel: .constant(viewModel))
		}
		.task {
			viewModel.getBookFeed()
		}
		.ignoresSafeArea()
		.navigationBarColor(ColorX.secondaryBg)
		.toolbar {
			ToolbarItemGroup(placement: .navigationBarTrailing) {
				NavigationLink(destination: AddBookView(), label: {
					Image(systemName: "plus")
						.foregroundColor(.white)
				})
			}
			ToolbarItemGroup(placement: .principal) {
				NavTitleView(title: "BlkBook")
			}
		}
    }
}

struct BlkBookView_Previews: PreviewProvider {
    static var previews: some View {
        BlkBookView()
    }
}
