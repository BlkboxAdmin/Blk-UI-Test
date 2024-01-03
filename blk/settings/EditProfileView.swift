//
//  EditProfileView.swift
//  blk
//
//  Created by Nabeel Shafique on 04/11/2022.
//

import SwiftUI

struct EditProfileView: View {
	
	@StateObject var viewModel = SettingsViewModel()
	@State private var username: String = ""
	@State private var name: String = ""
	@State private var phone: String = ""
	@State private var birthDate: Date = Date()
	@State private var email: String = ""
	@State private var bio: String = ""
	@State private var showDatePicker: Bool = false
	@State private var showAddImageView = false
	@State private var showDropBack = false
	
	@EnvironmentObject var toastControl: ToastControl
	
	// Target canvas
	@State private var image: Image?
	// ImagePicker
	@State private var showingImagePicker = false
	@State private var inputImage: UIImage?
	// CameraPicker
	@State private var showCameraPicker = false
	// Cropper
	@State private var croppedImage: UIImage?
	@State private var showingCropper = false
	
    var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
				.onTapGesture {
					showDatePicker = false
				}
			ScrollView {
				VStack {
					
					editPicureView
						.margin(bottom: 64)
					// Cropper
						.fullScreenCover(isPresented: $showingCropper, content: {
							ImageCropper(image: $croppedImage,
										 cropShapeType: .constant(.square),
										 presetFixedRatioType: .constant(.alwaysUsingOnePresetFixedRatio(ratio: 1)))
							.ignoresSafeArea()
						})
					
					VStack(spacing: 28) {
						LabelTextFieldView(value: $username, label: "Username")
						LabelTextFieldView(value: $name, label: "Full Name")
						LabelTextFieldView(value: $phone, label: "Phone Number", keyboardType: .phonePad)
						LabelTextFieldView(value: $email, label: "Email Address", isReadOnly: true)
						LabelTextFieldView(value: $birthDate.toString(),
										   label: "Date of Birth",
										   icon: "calendar",
										   isReadOnly: true
						) {
							showDatePicker.toggle()
						}
						
						LabelTextEditorView(value: $bio, label: "Bio", height: 200)
					}
					
					Spacer(minLength: 300)
					
				}
				.padding(.horizontal, 22)
				.margin(top: 130)
				.onAppear() {
					viewModel.getSettings()
					image = Image(viewModel.settings?.imageDefault ?? "")
					username = (viewModel.settings?.username) ?? ""
					name = (viewModel.settings?.fullname) ?? ""
					phone = (viewModel.settings?.phone) ?? ""
					email = (viewModel.settings?.email) ?? ""
					birthDate = (viewModel.settings?.dob?.toDate(format: "yyyy-MM-dd HH:mm:ss Z")) ?? Date()
					bio = (viewModel.settings?.bio) ?? ""
				}
				.onTapGesture {
					showDatePicker = false
				}
			}
			
			if showDropBack {
				DropBackView()
					.onTapGesture {
						showDropBack = false
						showAddImageView = false
					}
			}
			
			if showDatePicker {
				DatePicker("", selection: $birthDate)
					.datePickerDesign()
			}
			
			if showAddImageView {
				addImageView
			}
			
			CommonView(viewModel: .constant(viewModel))
		}
		.ignoresSafeArea()
		.navigationBarColor(ColorX.secondaryBg)
		.toolbar {
			ToolbarItemGroup(placement: .navigationBarTrailing) {
				Button(action: {
					viewModel.settings?.username = username
					viewModel.settings?.fullname = name
					viewModel.settings?.phone = phone
					viewModel.settings?.dob = birthDate.toString(format: "yyyy-MM-dd HH:mm:ss Z")
					viewModel.settings?.bio = bio
					
					viewModel.saveProfile() {message,status in
						toastControl.toast(message, status)
					}
					
				}, label: {
					Image("check-square")
				})
			}
			ToolbarItemGroup(placement: .principal) {
				NavTitleView(title: "Edit Profile")
			}
		}
		// After selection ImagePicker & CameraPicker
		.onChange(of: inputImage) { _ in
			// bringing selected image for cropping
			croppedImage = inputImage!
			DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
				showingCropper = true
			})
		}
		// After cropping
		.onChange(of: croppedImage) { _ in
			if croppedImage != inputImage {
				
				viewModel.uploadProfileImage(image: croppedImage!) {data,status,message in
					viewModel.settings?.image = data?.id
				}
				
				//image = loadImage(pInputImage: croppedImage)
				showAddImageView = false
				showDropBack = false
			}
		}
    }
	
	var editPicureView: some View {
		VStack {
			ZStack {
				// Target Image Start
				AsyncImage(url: URL(string: viewModel.settings?.imageUrlLG ?? "")) { image in
					image
						.resizable(resizingMode: .stretch)
						.aspectRatio(contentMode: .fit)
				} placeholder: {
					image?
						.resizable(resizingMode: .stretch)
						.aspectRatio(contentMode: .fit)
				}
				.frame(width: 149, height: 149)
				.clipped()
				.cornerRadius(8)
				// Target Image End
				
				GeometryReader { geo in
					Button(action: {
						showDropBack = true
						showAddImageView = true
					}, label: {
						VStack {
							Image("camera")
						}
						.padding(11)
						.background(ColorX.secondaryBg)
						.border(width: 2, cornerRadius: 20, color: .black)
						.cornerRadius(24)
						.clipped()
					})
					.position(x: geo.frame(in: .local).maxX - 8, y: geo.frame(in: .local).maxY - 15)
				}
			}
		}
		.frame(maxWidth: 149, maxHeight: 149)
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
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
