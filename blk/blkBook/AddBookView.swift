//
//  AddBookView.swift
//  blk
//
//  Created by Nabeel Shafique on 02/11/2022.
//

import SwiftUI

struct AddBookView: View {
	
	var type: AddType = .book
	var id: String = ""
	
	@Environment(\.presentationMode) var presentationMode
	
	@State private var linkName: String = ""
	@State private var linkUrl: String = ""
	@State private var isText: Bool = true
	@State private var isLink: Bool = false
	@State private var isImage: Bool = false
	@State private var showAddLinkView = false
	@State private var showAddImageView = false
	@State private var showDropBack = false
	@StateObject var viewModel = AddViewModel()
	@EnvironmentObject var toastControl: ToastControl
	
	// ImagePicker
	@State private var showingImagePicker = false
	@State private var inputImage: UIImage?
	@State private var image: Image?
	// CameraPicker
	@State private var showCameraPicker = false
	
	var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
			
			VStack (alignment: .leading) {
				
				let isPreviewExists: Bool = (!viewModel.description.isEmpty && viewModel.description != "Add body text") || !viewModel.imageId.isEmpty
				
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
			.margin(top: 130)
			.padding(.horizontal, 22)
			.onTapGesture {
				hideKeyboard()
			}
			
			toolBoxView
			
			if showDropBack {
				DropBackView()
					.onTapGesture {
						showDropBack = false
						showAddImageView = false
						showAddLinkView = false
					}
			}
			
			if showAddLinkView {
				addLinkView
			}
			
			if showAddImageView {
				addImageView
			}
			
			CommonView(viewModel: .constant(viewModel))
			
		}
		.task {
			if !id.isEmpty {
				if type == .book {
					viewModel.getBook(bookId: id) {message,status in
						if status != .success {
							toastControl.toast(message, status)
						}
					}
				}
			}
		}
		.ignoresSafeArea()
		.navigationBarColor(ColorX.secondaryBg)
		.toolbar {
			ToolbarItemGroup(placement: .navigationBarTrailing) {
				Button(action: {
					
					switch type {
					case .book:
						if id.isEmpty {
							viewModel.addBook() {message,status in
								toastControl.toast(message, status)
								presentationMode.wrappedValue.dismiss()
							}
						}
						else {
							viewModel.updateBook(id: id) {message,status in
								toastControl.toast(message, status)
								presentationMode.wrappedValue.dismiss()
							}
						}
					default:
						viewModel.addStory() {message,status in
							toastControl.toast(message, status)
							presentationMode.wrappedValue.dismiss()
						}
					}
					
					
				}, label: {
					Text("Publish")
						.foregroundColor(.white)
				})
			}
		}
		// ImagePicker & CameraPicker
		.onChange(of: inputImage) { _ in
			
			viewModel.uploadImage(image: inputImage!) {data,status,message in
				viewModel.isLoading = true
				
				// creating delay to give time to server to prepare video url
				DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
					viewModel.isLoading = false
					viewModel.imageId = data!.id
					toggleButtons(.text)
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
			
			if type == .story {
				// Target Image Start
				AsyncImage(url: URL(string: viewModel.imageUrl)) { image in
					image
						.resizable(resizingMode: .stretch)
						.aspectRatio(contentMode: .fit)
				} placeholder: {
					image?
						.hidden()
					Image("default-img")
						.resizable(resizingMode: .stretch)
						.aspectRatio(contentMode: .fit)
				}
				.frame(maxWidth: .infinity)
				.clipped()
				.cornerRadius(10)
				.background(Color.black.opacity(0.2))
				// Target Image End
			}
			
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
					ToolButtonView(icon: "type", label: "Text", isOn: $isText) {
						toggleButtons(.text)
					}
					
					ToolButtonView(icon: "link", label: "Link", isOn: $isLink) {
						toggleButtons(.link)
					}
					
					if type == .story {
						ToolButtonView(icon: "image", label: "Image", isOn: $isImage) {
							toggleButtons(.image)
						}
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
	
	var addImageView: some View {
		GeometryReader { geo in
			VStack {
				HStack {
					// CameraPicker
					ToolButtonView(icon: "video", label: "Camera", isOn: .constant(true)) {
						showCameraPicker = true
					}
					.sheet(isPresented: $showCameraPicker) {
						CameraPicker(selectedImage: $inputImage)
					}
					
					// ImagePicker
					ToolButtonView(icon: "image", label: "Gallery", isOn: .constant(true)) {
						showingImagePicker = true
					}
					.sheet(isPresented: $showingImagePicker) {
						ImagePicker(image: $inputImage)
					}
					
				}
			}
			.padding(20)
			.background(ColorX.secondaryBg)
			.cornerRadius(10)
			.margin(left: 22, right: 22)
			.position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY + 0)
		}
	}
	
	var addLinkView: some View {
		GeometryReader { geo in
			VStack {
				TextFieldView(value: $linkName, placeholder: "Link Name")
				TextFieldView(value: $linkUrl, placeholder: "URL")
				HStack {
					PrimaryButtonView(title: "Cancel") {
						toggleButtons(.text)
					}
					PrimaryButtonView(title: "Add") {
						viewModel.description = "\(viewModel.description) [\(linkName)](\(linkUrl))"
						linkName = ""
						linkUrl = ""
						toggleButtons(.text)
					}
				}
			}
			.padding(20)
			.background(ColorX.secondaryBg)
			.cornerRadius(10)
			.margin(left: 22, right: 22)
			.position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY + 0)
		}
	}
	
	func toggleButtons(_ btn: ToolButton)
	{
		switch btn {
		case .text:
			isLink = false
			isText = true
			isImage = false
			showDropBack = false
			showAddLinkView = false
			showAddImageView = false
		case .link:
			isLink = true
			isText = false
			isImage = false
			showDropBack = true
			showAddLinkView = true
		case .image:
			isLink = false
			isText = false
			isImage = true
			showDropBack = true
			showAddImageView = true
		}
		
	}
}

enum AddType {
	case book, story
}

enum ToolButton {
	case text, link, image
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
