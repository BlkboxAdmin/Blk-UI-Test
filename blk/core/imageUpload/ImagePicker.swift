//
//  ImagePicker.swift
//  blk
//
//  Created by Nabeel Shafique on 03/11/2022.
//

import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
	var image: Binding<UIImage?>? = nil
	var videoUrl: Binding<URL?>? = nil
	var mediaType: PHPickerFilter = .images
	
	func makeUIViewController(context: Context) -> PHPickerViewController {
		var config = PHPickerConfiguration()
		config.filter = mediaType
		let picker = PHPickerViewController(configuration: config)
		picker.delegate = context.coordinator
		return picker
	}
	
	func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
		
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	class Coordinator: NSObject, PHPickerViewControllerDelegate {
		let parent: ImagePicker
		
		init(_ parent: ImagePicker) {
			self.parent = parent
		}
		
		func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
			picker.dismiss(animated: true)
			
			guard let provider = results.first?.itemProvider else { return }
			
			if parent.mediaType == .images {
				if provider.canLoadObject(ofClass: UIImage.self) {
					provider.loadObject(ofClass: UIImage.self) { image, _ in
						self.parent.image?.wrappedValue = (image as? UIImage)!
					}
				}
			}
			
			if parent.mediaType == .videos {
				provider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
					if let url = url {
						
						let fileName = "\(Int(Date().timeIntervalSince1970)).\(url.pathExtension)"
						// create new URL
						let newUrl = URL(fileURLWithPath: NSTemporaryDirectory() + fileName)
						// copy item to APP Storage
						try? FileManager.default.copyItem(at: url, to: newUrl)
						
						self.parent.videoUrl?.wrappedValue = newUrl
					}
				}
			}
			
		}
	}
}
