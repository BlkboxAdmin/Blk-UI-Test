//
//  DropBackView.swift
//  blk
//
//  Created by Nabeel Shafique on 06/11/2022.
//

import SwiftUI

struct DropBackView: View {
    var body: some View {
		VStack {
			Spacer()
		}
		.frame(maxWidth: .infinity)
		.background(.black)
		.opacity(0.7)
    }
}

struct DropBackView_Previews: PreviewProvider {
    static var previews: some View {
        DropBackView()
    }
}
