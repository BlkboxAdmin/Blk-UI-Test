//
//  NavTitleView.swift
//  blk
//
//  Created by Nabeel Shafique on 02/11/2022.
//

import SwiftUI

struct NavTitleView: View {
	
	var title: String = ""
	var icon: String = ""
	
    var body: some View {
		HStack{
			if !icon.isEmpty {
				Image(icon)
			}
			Text(title)
				.foregroundColor(.white)
				.fontSize(23)
				.frame(width: 210, height: 40)
				.truncationMode(.tail)
		}
    }
}

struct NavTitleView_Previews: PreviewProvider {
    static var previews: some View {
        NavTitleView(title: "Nabeel Shafique", icon: "online")
			.background(.black)
    }
}
