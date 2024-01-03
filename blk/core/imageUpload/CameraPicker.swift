//
//  ImagePicker.swift
//  blk
//
//  Created by Nabeel Shafique on 03/11/2022.
//

import SwiftUI

struct CameraPicker: UIViewControllerRepresentable {
	@Environment(\.presentationMode) private var presentationMode
	var sourceType: UIImagePickerController.SourceType = .camera
	@Binding var selectedImage: UIImage?
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<CameraPicker>) -> UIImagePickerController {
		
		let imagePicker = UIImagePickerController()
		imagePicker.allowsEditing = false
		imagePicker.sourceType = sourceType
		imagePicker.delegate = context.coordinator
		
		return imagePicker
	}
	
	func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraPicker>) {
		
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
		
		var parent: CameraPicker
		
		init(_ parent: CameraPicker) {
			self.parent = parent
		}
		
		func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
			
			if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
				parent.selectedImage = image
			}
			
			parent.presentationMode.wrappedValue.dismiss()
		}
		
	}
}
