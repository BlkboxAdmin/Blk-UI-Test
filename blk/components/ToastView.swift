//
//  ToastView.swift
//  blk
//
//  Created by Nabeel Shafique on 13/11/2022.
//

import SwiftUI

class ToastControl: ObservableObject {
	@Published var showToast: Bool = false
	@Published var type: ToastType = .info
	@Published var message: String = "Message text goes here"
	
	func toast(_ message: String, _ type: ResponseStatus = .success)
	{
		self.type = (type == .success) ? .info : .error
		self.message = message
		showToast = true
	}
}

enum ToastType: String {
	case info = "info.circle"
	case error = "xmark.circle"
}

struct ToastView: View {
	@EnvironmentObject var control: ToastControl
	@State private var opacity: Double = 0
	var duration: Double = 0.5
	
    var body: some View {
		GeometryReader { geo in
			VStack (alignment: .leading) {
				HStack {
					Image(systemName: control.type.rawValue)
					Text(control.message)
						.foregroundColor(.white)
						.fontSize(14)
				}
			}
			.frame(maxWidth: .infinity)
			.padding(8)
			.background(ColorX.border)
			.position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).maxY - 60)
		}
		.opacity(opacity)
		.onChange(of: control.showToast) { newValue in
			if newValue {
				withAnimation(.easeIn(duration: duration)) {
					self.opacity = 1
				}
				DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
					withAnimation(.easeOut(duration: duration)) {
						opacity = 0
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
							control.showToast = false
						}
					}
				}
			}
		}
    }
}

struct ToastView_Previews: PreviewProvider {
	static let myEnvObject = ToastControl()
    static var previews: some View {
		
		ToastView()
			.environmentObject(myEnvObject)
    }
}
