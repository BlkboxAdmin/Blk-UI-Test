//
//  CameraTimeStoryView.swift
//  blk
//
//  Created by Nabeel Shafique on 05/12/2022.
//

import SwiftUI

struct CameraTimeStoryView: View {
	
	@Environment(\.presentationMode) var presentationMode
	@EnvironmentObject var cameraModel: CameraViewModel
	
	var onUpload: () -> Void
	
    var body: some View {
		ZStack {
			ZStack(alignment: .bottom) {
				CameraView()
				// MARK: Controls
				
				ZStack {
					
					recordButtonView
					
					// Preview button
					previewButtonView
				}
				.frame(maxHeight: .infinity, alignment: .bottom)
				.padding(.bottom, 10)
				.padding(.bottom, 30)
				
				if !cameraModel.isRecording {
					changeCameraView
				}
				
				closeButtonView
			}
			.overlay(content: {
				if let url = cameraModel.previewURL, cameraModel.showPreview {
					VideoPreviewView(url: url, showPreview: $cameraModel.showPreview)
						.transition(.move(edge: .trailing))
				}
			})
			.animation(.easeOut, value: cameraModel.showPreview)
			.preferredColorScheme(.dark)
			
			if !cameraModel.isRecording && cameraModel.previewURL != nil {
				uploadButtonView
				
				deleteButtonView
			}
		}
    }
	
	var recordButtonView: some View {
		Button {
			if cameraModel.isRecording {
				cameraModel.stopRecording()
			}
			else {
				cameraModel.startRecording()
			}
		} label: {
			Circle()
				.fill( cameraModel.isRecording ? .red : .white)
				.padding(8)
				.frame(width: 82, height: 82)
				.background {
					Circle().fill( ColorX.borderLight )
				}
		}
	}
	
	var previewButtonView: some View {
		Button {
			if let _ = cameraModel.previewURL {
				cameraModel.showPreview.toggle()
			}
		} label: {
			
			Group {
				if cameraModel.previewURL == nil && !cameraModel.recordedURLs.isEmpty {
					ProgressView()
						.frame(width: 54, height: 54)
						.tint(.white)
				}
				else {
					
					if cameraModel.previewImage != nil {
						Image(uiImage: cameraModel.previewImage!)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 54, height: 54)
							.cornerRadius(5)
							.clipped()
					}
					else {
						Image("cam-preview")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 54, height: 54)
							.cornerRadius(5)
							.clipped()
					}
				}
			}
			.padding(4)
			.border(cornerRadius: 9, color: .white)
			.padding(.horizontal, 20)
			.padding(.vertical, 8)
		}
		.frame(maxWidth: .infinity, alignment: .bottomLeading)
		.padding(.leading)
		.opacity((cameraModel.previewURL == nil && cameraModel.recordedURLs.isEmpty) || cameraModel.isRecording ? 0 : 1)
	}
	
	var closeButtonView: some View {
		Button {
			cameraModel.reset()
			presentationMode.wrappedValue.dismiss()
		} label: {
			Image(systemName: "xmark")
				.font(.title)
				.foregroundColor(.white)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
		.padding()
		.padding(.top, 25)
	}
	
	var deleteButtonView: some View {
		Button {
			cameraModel.reset()
		} label: {
			Image(systemName: "trash")
				.font(.title)
				.foregroundColor(.white)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
		.padding()
		.padding(.top, 22)
		.padding(.trailing, 90)
	}
	
	var uploadButtonView: some View {
		Button {
			onUpload()
		} label: {
			
			Image(systemName: "icloud.and.arrow.up")
				.font(.title)
				.foregroundColor(.white)
				.padding(8)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
		.padding()
		.padding(.top)
		.padding(.trailing)
	}
	
	var changeCameraView: some View {
		Button {
			cameraModel.changeCamera()
		} label: {
			Image("rotation")
				.padding(8)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
		.padding()
		.padding(.bottom, 25)
		.padding(.trailing, 25)
	}
}

struct CameraTimeStoryView_Previews: PreviewProvider {
	static let cameraModel = CameraViewModel()
    static var previews: some View {
		CameraTimeStoryView(){
			
		}
		.environmentObject(cameraModel)
    }
}
