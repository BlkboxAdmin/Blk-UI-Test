//
//  BlockListView.swift
//  blk
//
//  Created by Nabeel Shafique on 04/11/2022.
//

import SwiftUI

struct BlockListView: View {
	
	@StateObject var viewModel = SettingsViewModel()
	@EnvironmentObject var toastControl: ToastControl
	
    var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
			
			VStack(alignment: .leading) {
				
				ScrollView {
					LazyVStack(alignment: .leading ,spacing: 27) {
						ForEach(viewModel.blockList, id: \.self) { item in
							UserRowView(user: item, showRemoveBtn: true) { userId in
								viewModel.unblockUser(userId) {message,status in 
									toastControl.toast(message, status)
								}
							}
						}
					}
				}
				
				Spacer()
			}
			.padding(.horizontal, 22)
			.margin(top: 130)
			.onAppear() {
				viewModel.getBlockList()
			}
			
			CommonView(viewModel: .constant(viewModel))
		}
		.ignoresSafeArea()
		.navigationBarColor(ColorX.secondaryBg)
		.toolbar {
			ToolbarItemGroup(placement: .principal) {
				NavTitleView(title: "Blocklist")
			}
		}
    }
}

struct BlockListView_Previews: PreviewProvider {
    static var previews: some View {
        BlockListView()
    }
}
