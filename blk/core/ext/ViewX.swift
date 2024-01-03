//
//  ViewX.swift
//  blk
//
//  Created by Nabeel Shafique on 03/11/2022.
//

import Foundation
import SwiftUI

extension View {
	func hideKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}
