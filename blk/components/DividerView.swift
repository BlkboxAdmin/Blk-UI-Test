//
//  DividerView.swift
//  blk
//
//  Created by Nabeel Shafique on 02/11/2022.
//

import SwiftUI

struct DividerView: View {
	
	var direction: Direction = .horizontal
	var thickness: CGFloat = 1.0
	var color: Color = ColorX.border
	
    var body: some View {
		
		if direction == .horizontal
		{
			VStack {
				Divider()
					.frame(height: thickness)
					.background(color)
			}
		}
		else {
			HStack {
				Divider()
					.frame(width: thickness)
					.background(color)
			}
		}
    }
}

enum Direction {
	case horizontal, vertical
}

struct DividerView_Previews: PreviewProvider {
    static var previews: some View {
        DividerView()
    }
}
