//
//  AddTimeStoryView.swift
//  blk
//
//  Created by Nabeel Shafique on 08/11/2022.
//

import SwiftUI

struct AddTimeStoryOldView: View {
	@Environment(\.presentationMode) var presentationMode
	
    var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
			
			VStack {
				Spacer()
				
				HStack {
					Button(action: {
						self.presentationMode.wrappedValue.dismiss()
					}, label: {
						Image("home")
					})
					.frame(maxWidth: .infinity)
					
					Button(action: {
						//@TODO: search
					}, label: {
						Image("search")
					})
					.frame(maxWidth: .infinity)
					
					Button(action: {
						//@TODO: play
					}, label: {
						Image("play")
					})
					.frame(maxWidth: .infinity)
					
					Button(action: {
						
					}, label: {
						Image("record")
					})
					.frame(maxWidth: .infinity)
				}
				.frame(maxWidth: .infinity)
				.margin(bottom: 30)
			}
			
			//CommonView(viewModel: .constant(viewModel))
		}
		.ignoresSafeArea()
		.navigationBarColor(ColorX.secondaryBg)
    }
}

struct AddTimeStoryOldView_Previews: PreviewProvider {
    static var previews: some View {
        AddTimeStoryView()
    }
}
