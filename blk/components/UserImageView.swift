//
//  UserImageView.swift
//  blk
//
//  Created by Nabeel Shafique on 04/11/2022.
//

import SwiftUI

struct UserImageView: View {
	
	var img: String = "user117x117"
	var isVerified: Bool = false
	var size: UserImgSize = .small
	var verifyImg: String = "checkmark35x35"
	
    var body: some View {
		VStack {
			ZStack {
				AsyncImage(url: URL(string: img)) { image in
					image
						.resizable(resizingMode: .stretch)
						.aspectRatio(contentMode: .fit)
				} placeholder: {
					Image("user-default")
						.resizable(resizingMode: .stretch)
						.aspectRatio(contentMode: .fit)
				}
				.frame(width: size.rawValue, height: size.rawValue)
				.cornerRadius(8)
				
				if isVerified {
					GeometryReader { geo in
						Image(verifyImg)
							.resizable()
							.frame(width: verifyImgSize(), height: verifyImgSize())
							.clipped()
							.position(x: geo.frame(in: .local).maxX - 3, y: geo.frame(in: .local).maxY - 5)
					}
				}
			}
		}
		.frame(width: size.rawValue, height: size.rawValue)
    }
	
	private func verifyImgSize() -> CGFloat {
		
		var iconSize: CGFloat = 15
		
		switch size {
		case .medium:
			iconSize = 25
		case .large:
			iconSize = 35
		default:
			iconSize = 15
		}
		
		return iconSize
	}
}

struct UserImageView_Previews: PreviewProvider {
    static var previews: some View {
		UserImageView(isVerified: true, size: .large)
    }
}
