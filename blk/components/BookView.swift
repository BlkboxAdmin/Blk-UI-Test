//
//  BookView.swift
//  blk
//
//  Created by Nabeel Shafique on 02/11/2022.
//

import SwiftUI

struct BookView: View {
	var book: Book
	var isListView: Bool = true
	var onLikeAction: ((Book) -> Void)? = nil
	var onDislikeAction: ((Book) -> Void)? = nil
	var onFollowAction: ((Book) -> Void)? = nil
	
	@State var isShowingEdit: Bool = false
	
	var body: some View {
		VStack{
			VStack(alignment: .leading) {
				NavigationLink(destination: AddBookView(type: .book, id: book.id), isActive: $isShowingEdit) {
					EmptyView()
				}
				HStack {
					NavigationLink(destination: BlkBoardView(userId: book.created_by), label: {
						UserImageView(img: book.user?.imageUrlSM ?? "", isVerified: book.user?.isVerified ?? false)
					})
					VStack(alignment: .leading) {
						Text(book.user?.name ?? "")
							.foregroundColor(.white)
							.fontSize(16)
						Text("@\(book.user?.username ?? "")")
							.foregroundColor(ColorX.primaryFg)
							.fontSize(14)
					}
					Spacer()
					Menu {
						if book.isEditable {
							Button(action: {
								isShowingEdit = true
							}, label: {
								Text("Edit")
									.foregroundColor(.black)
							})
						}
						
						Button(action: {
							onFollowAction?(book)
						}, label: {
							Text(book.isFollowed ? "Unfollow" : "Follow")
								.foregroundColor(.black)
						})

					} label: {
						Image("more-vertical-grey")
					}
				}
				.margin(bottom: 23)
				
				if isListView {
					NavigationLink(destination: SingleBookView(book: book), label: {
						textView
					})
				}
				else {
					textView
				}
				
				HStack {
					Button {
						onLikeAction?(book)
					} label: {
						BadgeCountView(count: book.like_count, icon: .like)
							.margin(right: 22)
					}

					Button {
						onDislikeAction?(book)
					} label: {
						BadgeCountView(count: book.dislike_count, icon: .unlike)
							.margin(right: 22)
					}

					NavigationLink(destination: SingleBookView(book: book), label: {
						BadgeCountView(count: book.comment_count, icon: .comments)
					})
					Spacer()
					Text(book.created_on.toTimeAgo)
						.foregroundColor(ColorX.primaryFg)
						.fontSize(14)
				}
			}
			.padding(.leading, 23)
			.padding(.trailing, 19)
			.padding(.top, 19)
			.padding(.bottom, 26)
			.background(ColorX.secondaryBg)
		}
		.cornerRadius(isListView ? 11 : 0)
	}
	
	var textView: some View {
		Text(book.description)
			.foregroundColor(.white)
			.multilineTextAlignment(.leading)
			.fontSize( isListView ? 16 : 18)
			.margin(bottom: 49)
	}
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
		let feed: [Book] = load("books.json")
		BookView(book: feed[0], isListView: true)
    }
}
