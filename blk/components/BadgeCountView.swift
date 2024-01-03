//
//  BadgeCountView.swift
//  blk
//
//  Created by Nabeel Shafique on 02/11/2022.
//

import SwiftUI

struct BadgeCountView: View {
	
	var count: Int = 0
	var icon: Badge = .repost
	
    var body: some View {
		HStack {
			Image(icon.rawValue)
				.resizable()
				.frame(width: 22, height: 23)
				.margin(right: 8)
			
			Text(count.shorted)
				.foregroundColor(.white)
				.fontSize(17)
		}
    }
}

enum Badge: String {
	case repost = "repeat"
	case heart = "heart"
	case like = "like"
	case unlike = "unlike"
	case comments = "message-square"
}

struct BadgeCountView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeCountView()
			.background(.black)
    }
}
