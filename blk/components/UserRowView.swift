//
//  ChatRowView.swift
//  blk
//
//  Created by Nabeel Shafique on 05/11/2022.
//

import SwiftUI

struct UserRowView: View {
	
	var user: User
	var showRemoveBtn: Bool = false
	var action: ((String) -> Void)? = nil
	
    var body: some View {
		HStack {
			AsyncImage(url: URL(string: user.imageUrlMD)){ image in
				image
					.resizable(resizingMode: .stretch)
					.aspectRatio(contentMode: .fit)
			} placeholder: {
				Image(user.imageDefault)
					.resizable(resizingMode: .stretch)
					.aspectRatio(contentMode: .fit)
			}
			.frame(maxWidth: 60, maxHeight: 60)
			.clipped()
			.cornerRadius(7)
			
			VStack(alignment: .leading) {
				Text(user.fullname!)
					.foregroundColor(.white)
					.fontSize(20)
					.fontBold(.semibold)
				Text("Active \(user.last_activity_on!.toTimeAgo)")
					.foregroundColor(ColorX.thirdFg)
					.fontSize(13)
				
			}
			.margin(left: 21)
			
			Spacer()
			
			if showRemoveBtn {
				Button {
					action?(user.id)
				} label: {
					Text("X Remove")
						.foregroundColor(ColorX.block)
						.fontSize(14)
				}
			}

		}
    }
}

struct UserRowView_Previews: PreviewProvider {
    static var previews: some View {
		let blockList: [User] = load("block_list.json")
		UserRowView(user: blockList[0], showRemoveBtn: true)
    }
}
