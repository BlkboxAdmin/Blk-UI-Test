//
//  PrivacyView.swift
//  blk
//
//  Created by Nabeel Shafique on 05/11/2022.
//

import SwiftUI

struct PrivacyView: View {
    var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
			
			VStack(alignment: .leading) {
				Text("Privacy Text goes here")
					.foregroundColor(.white)
				
				Spacer()
			}
			.margin(top: 130)
		}
		.ignoresSafeArea()
		.navigationBarColor(ColorX.secondaryBg)
		.toolbar {
			ToolbarItemGroup(placement: .principal) {
				NavTitleView(title: "BlkBook")
			}
		}
    }
}

struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyView()
    }
}
