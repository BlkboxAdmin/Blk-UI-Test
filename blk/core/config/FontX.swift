//
//  FontX.swift
//  blk
//
//  Created by Nabeel Shafique on 31/10/2022.
//

import SwiftUI

struct FontX {
	static let primary: String = "Inter"
	
	static func fontSize(_ fixedSize: CGFloat, fontFamily: String = FontX.primary) -> Font {
		return .custom(fontFamily, fixedSize: 23)
	}
}
