//
//  BlkCardView.swift
//  blk
//
//  Created by Nabeel Shafique on 01/11/2022.
//

import SwiftUI

struct BlkCardView: View {
	var userId: String = ""
	@State var isTilesTab: Bool = true
	@StateObject var viewModel = CardViewModel()
	@EnvironmentObject var toastControl: ToastControl
	
    var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
			
			ScrollView {
				VStack {
					
					profileInfoView
					
					connectionInfoView
					
					DividerView()
						.margin(top: 28, bottom: 37)
					
					bioView
						.margin(bottom: 33)
					
					tabContentView
					
					Spacer()
				}
				.padding(.horizontal, 22)
				.margin(top: 100)
			}
			
			
			CommonView(viewModel: .constant(viewModel))
		}
		.task {
			viewModel.getProfile(userId: userId) {message,status in
				if status != .success {
					toastControl.toast(message, status)
				}
				else {
					viewModel.getFrameFeed(userId: userId)
					viewModel.getTileFeed(userId: userId)
				}
			}
		}
		.ignoresSafeArea()
		.navigationBarColor(ColorX.secondaryBg)
		.toolbar {
			ToolbarItemGroup(placement: .principal) {
				NavTitleView(title: "BlkCard")
			}
		}
    }
	
	var tabContentView: some View {
		VStack {
			HStack {
				tilesTab
				framesTab
			}
			.margin(bottom: 33)
			
			if isTilesTab {
				tilesContentView
			}
			else {
				framesContentView
			}
		}
	}
	
	var tilesContentView: some View {
		LazyVStack(spacing: 22) {
			ForEach(viewModel.tiles, id: \.self) { item in
				
				StoryView(story: item)
			}
		}
	}
	
	var framesContentView: some View {
		LazyVStack(spacing: 22) {
			ForEach(viewModel.frames, id: \.self) { item in
				
				StoryView(story: item)
			}
		}
	}
	
	var tilesTab: some View {
		Button {
			isTilesTab.toggle()
		} label: {
			Text("Tiles")
				.foregroundColor(!isTilesTab ? ColorX.thirdFg : ColorX.selectedFg)
				.tabStyle(.bottom)
				.singleBorder(.bottom, !isTilesTab ? 1 : 4, !isTilesTab ? ColorX.border : ColorX.selectedFg)
		}
	}
	
	var framesTab: some View {
		Button {
			isTilesTab.toggle()
		} label: {
			Text("Frames")
				.foregroundColor(isTilesTab ? ColorX.thirdFg : ColorX.selectedFg)
				.tabStyle(.bottom)
				.singleBorder(.bottom, isTilesTab ? 1 : 4, isTilesTab ? ColorX.border : ColorX.selectedFg)
		}
	}
	
	var bioView: some View {
		VStack(alignment: .leading) {
			Text("Bio")
				.foregroundColor(.white)
				.fontSize(23)
				.fontBold()
				.margin(bottom: 8)
			
			Text("@\(viewModel.profile?.username ?? "")\n\(viewModel.profile?.bio ?? "")")
				.foregroundColor(ColorX.thirdFg)
		}
	}
	
	var connectionInfoView: some View {
		HStack {
			connectionView(icon: "people40x40", title: "Connections", count: viewModel.profile?.connectionCount ?? 0)
			Spacer()
			connectionView(icon: "friends44x44", title: "Friends", count: viewModel.profile?.friendsCount ?? 0)
		}
	}
	
	func connectionView(icon: String, title: String, count: Int) -> some View {
		HStack{
			Image(icon)
				.margin(right: 16)
			VStack(alignment: .leading) {
				Text(count.toString)
					.foregroundColor(.white)
					.fontSize(20)
					.fontBold(.semibold)
				Text(title)
					.foregroundColor(.white)
					.fontSize(16)
			}
		}
	}
	
	var profileInfoView: some View {
		VStack {
			UserImageView(img: viewModel.profile?.imageUrlLG ?? "", isVerified: true ,size: .large)
			Text(viewModel.profile?.name ?? "")
				.foregroundColor(.white)
				.fontSize(23)
				.fontBold(.semibold)
			
			Text("@\(viewModel.profile?.username ?? "")")
				.foregroundColor(ColorX.thirdFg)
				.fontSize(18)
				.margin(bottom: 47)
		}
	}
}

struct BlkCardView_Previews: PreviewProvider {
    static var previews: some View {
        BlkCardView()
    }
}
