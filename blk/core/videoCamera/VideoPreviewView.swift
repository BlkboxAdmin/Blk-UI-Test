//
//  VideoPreviewView.swift
//  ReelsCamera
//
//  Created by Nabeel Shafique on 04/12/2022.
//

import SwiftUI
import AVKit

struct VideoPreviewView: View {
	
	var url: URL
	@Binding var showPreview: Bool
	
    var body: some View {
		GeometryReader { geo in
			VideoPlayer(player: AVPlayer(url: url))
				.aspectRatio(contentMode: .fill)
				.frame(width: geo.size.width, height: geo.size.height)
				.clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
				.overlay(alignment: .topLeading) {
					Button {
						showPreview.toggle()
					} label: {
						Image(systemName: "xmark")
							.font(.title)
							.foregroundColor(.white)
					}
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
					.padding()
					.padding(.top, 25)

				}
		}
    }
}

struct VideoPreviewView_Previews: PreviewProvider {
    static var previews: some View {
		VideoPreviewView(url: URL(string: "")!, showPreview: .constant(true))
    }
}
