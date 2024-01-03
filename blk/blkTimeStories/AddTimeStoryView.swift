//
//  AddTimeStoryView.swift
//  blk
//
//  Created by Nabeel Shafique on 03/12/2022.
//

import SwiftUI
import AVFoundation
import _AVKit_SwiftUI

struct AddTimeStoryView: View {
	
	var id: String = ""
	
	@Environment(\.presentationMode) var presentationMode
	@StateObject var viewModel = AddTimeStoryViewModel()
	@StateObject var cameraModel = CameraViewModel()
	@EnvironmentObject var toastControl: ToastControl
	
	@State private var showDatePicker: Bool = false
	@State private var expiryDate: Date = Date()
	
	// VideoPicker
	@State private var showingVideoPicker = false
	@State private var inputVideo: URL? = nil
	@State private var video: String?
	// CameraPicker
	@State private var showCameraPicker = false
	
    var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
				.onTapGesture {
					showDatePicker = false
				}
			
			VStack (alignment: .leading) {
				
				let isPreviewExists: Bool = !viewModel.video.isEmpty
				
				if isPreviewExists
				{
					previewView
				}
				
				TextEditor(text: $viewModel.description)
					.xBackground(.black)
					.foregroundColor(ColorX.primaryFg)
					.fontSize(20)
					.padding(.horizontal)
				
				Spacer()
			}
			.onTapGesture {
				hideKeyboard()
			}
			.margin(top: 130)
			.padding(.horizontal, 22)
			
			toolBoxView
			
			if showDatePicker {
				DatePicker("", selection: $expiryDate, in: Date.now...)
					.datePickerDesign()
			}
			
			CommonView(viewModel: .constant(viewModel))
			
		}
		.adaptsToKeyboard()
		.task {
			if !id.isEmpty {
				viewModel.getStory(storyId: id) {message,status in
					if status != .success {
						toastControl.toast(message, status)
					}
				}
			}
		}
		.ignoresSafeArea()
		.navigationBarColor(ColorX.secondaryBg)
		.toolbar {
			ToolbarItemGroup(placement: .principal) {
				NavTitleView(title: "Upload New Fade")
			}
			ToolbarItemGroup(placement: .navigationBarTrailing) {
				Button(action: {
					
					viewModel.expiringOn = expiryDate.toString(format: "yyyy-MM-dd HH:mm:ss Z")
					
					viewModel.addStory() {message,status in
						if status == .success {
							presentationMode.wrappedValue.dismiss()
						}
						toastControl.toast(message, status)
					}
				}, label: {
					Text("Publish")
						.foregroundColor(.white)
				})
			}
		}
		// ImagePicker & CameraPicker
		.onChange(of: inputVideo) { _ in
			viewModel.uploadVideo(video: inputVideo?.absoluteString ?? "") {data,status,message in
				
				viewModel.isLoading = true
				
				// creating delay to give time to server to prepare video url
				DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
					viewModel.isLoading = false
					viewModel.video = data!.id
				}
			}
		}
    }
	
	
	var previewView: some View {
		VStack(alignment: .leading) {
			Text("Preview")
				.foregroundColor(.white)
				.fontSize(20)
				.fontBold()
				.margin(bottom: 10)
			
			Text(.init(viewModel.description))
				.foregroundColor(ColorX.primaryFg)
			
			// Target Image Start
			let player = AVPlayer(url: URL(string: UploadedVideo.getUrl(videoId: viewModel.video))! )
			VideoPlayer(player: player)
				.frame(height: 256)
				.onAppear() {
					player.isMuted = false
					player.play()
					
				}
			.frame(maxWidth: .infinity)
			// Target Image End
			
			DividerView()
				.margin(top: 10, bottom: 10)
		}
	}
	
	var toolBoxView: some View {
		GeometryReader { geo in
			VStack {
				
				Text("What do you want to post")
					.fontSize(14)
					.foregroundColor(.white)
					.fontBold()
					.margin(bottom: 44)
				
				HStack {
					
					// CameraPicker
					ToolButtonView(icon: "youtube", label: "Camera", isOn: .constant(true)) {
						showCameraPicker = true
					}
					.sheet(isPresented: $showCameraPicker) {
						CameraTimeStoryView() {
							inputVideo = cameraModel.previewURL
							showCameraPicker = false
						}
						.environmentObject(cameraModel)
					}
					
					// ImagePicker
					ToolButtonView(icon: "image", label: "Gallery", isOn: .constant(true)) {
						showingVideoPicker = true
					}
					.sheet(isPresented: $showingVideoPicker) {
						ImagePicker(videoUrl: $inputVideo, mediaType: .videos)
					}
					
					ToolButtonView(icon: "time", label: "Fade Time", isOn: .constant(true)) {
						showDatePicker.toggle()
					}
					
					Spacer()
				}
			}
			.padding(.vertical, 19)
			.padding(.horizontal, 11)
			.background(ColorX.secondaryBg)
			.frame(maxWidth: .infinity)
			.position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).maxY - 100)
		}
	}
}

struct AddTimeStoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddTimeStoryView()
    }
}
