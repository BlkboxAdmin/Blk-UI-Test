//
//  LabelTextEditorView.swift
//  blk
//
//  Created by Nabeel Shafique on 26/11/2022.
//

import SwiftUI

struct LabelTextEditorView: View {
	
	@Binding var value: String
	var label: String = ""
	var height: CGFloat = .infinity
	
    var body: some View {
		VStack {
			ZStack {
				HStack {
					
					ZStack(alignment: .leading) {
						TextEditor(text: $value)
							.xBackground(.black)
							.foregroundColor(ColorX.primaryFg)
							.fontSize(18)
							.keyboardType(.default)
					}
				}
				.frame(height: height)
				.padding(.horizontal)
				.background(.black)
				.border(width: 1, cornerRadius: 8)
				
				GeometryReader { geo in
					HStack {
						Text(label)
							.foregroundColor(ColorX.selectedFg)
							.padding(.horizontal, 6)
							.background(.black)
							.fontSize(14)
					}
					.offset(x: 10,y: -9)
				}
			}
		}
		.frame(height: height)
    }
}

struct LabelTextEditorView_Previews: PreviewProvider {
    static var previews: some View {
		LabelTextEditorView(value: .constant( "Artist, producer, Engineer. Ive worked with many artist and have credits on various albums"), label: "Bio", height: 200)
    }
}
