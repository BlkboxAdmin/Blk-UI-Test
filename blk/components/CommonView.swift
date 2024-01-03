//
//  CommonView.swift
//  blk
//
//  Created by Nabeel Shafique on 27/11/2022.
//

import SwiftUI

struct CommonView: View {
	
	@Binding var viewModel: BaseViewModel
	
    var body: some View {
		
		if viewModel.isLoading {
			ProgressView()
				.progressViewStyle(CircularProgressViewStyle(tint: ColorX.borderLight))
				.scaleEffect(x: 1, y: 1, anchor: .center)
		}
		
		if viewModel.isUploading {
			ProgressView("Upload progress \(Int(viewModel.uploadProgress))%" ,value: viewModel.uploadProgress, total: 100)
					.padding(.horizontal, 10)
					.padding(.vertical, 20)
					.tint(ColorX.selectedFg)
					.background(ColorX.secondaryBg)
					.foregroundColor(ColorX.primaryFg)
					.scaleEffect(x: 1, y: 1, anchor: .center)
					.cornerRadius(6)
					.margin(left: 20, right: 20)
		}
    }
}

struct CommonView_Previews: PreviewProvider {
    static var previews: some View {
		CommonView(viewModel: .constant(BaseViewModel()) )
    }
}
