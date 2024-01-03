//
//  AddCommentView.swift
//  blk
//
//  Created by Nabeel Shafique on 05/12/2022.
//

import SwiftUI

struct AddCommentView: View {
	
	var postId: String
	var type: CommentFor = .books
	@EnvironmentObject var viewModel: CommentsViewModel
	@EnvironmentObject var toastControl: ToastControl
	
    var body: some View {
		VStack {
			Spacer()
				.frame(height: 100)
			TextFieldView(value: $viewModel.newCommentText, placeholder: "Add comment", customIcon: "send") {
				hideKeyboard()
				viewModel.addComment(postId: postId, type: type) {message,status in
					if status == .error {
						toastControl.toast(message, status)
					}
				}
			}
			.onTapGesture {
				hideKeyboard()
			}
			.padding(.horizontal, 25)
			.margin(bottom: 45)
		}
		.background(
			LinearGradient(gradient: Gradient(colors: [.clear, .black, .black]), startPoint: .top, endPoint: .bottom)
		)
    }
}

struct AddCommentView_Previews: PreviewProvider {
    static var previews: some View {
		AddCommentView(postId: "")
    }
}
