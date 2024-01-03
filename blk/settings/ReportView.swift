//
//  ReportView.swift
//  blk
//
//  Created by Nabeel Shafique on 05/11/2022.
//

import SwiftUI

struct ReportView: View {
	
	@State private var description: String = ""
	@StateObject var viewModel = SettingsViewModel()
	@EnvironmentObject var toastControl: ToastControl
	
    var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
			
			VStack(alignment: .leading, spacing: 10) {
				
				Text("Tell us about the issue")
					.margin(left: 10)
					.multilineTextAlignment(.leading)
					.foregroundColor(.white)
					.fontBold()
				
				TextEditor(text: $description)
					.xBackground(ColorX.secondaryBg)
					.foregroundColor(ColorX.primaryFg)
					.fontSize(20)
					.frame(maxHeight: 200)
					.cornerRadius(10)
				
				Spacer()
			}
			.frame(maxWidth: .infinity)
			.padding(.horizontal, 20)
			.margin(top: 50)
			
		}
		.navigationBarColor(ColorX.secondaryBg)
		.toolbar {
			ToolbarItemGroup(placement: .principal) {
				NavTitleView(title: "Report a Problem")
			}
			
			ToolbarItemGroup(placement: .navigationBarTrailing) {
				
				Button {
					viewModel.report(description) {message,status in
						toastControl.toast(message, status)
					}
				} label: {
					Text("Submit")
						.foregroundColor(.white)
				}
			}
		}
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
