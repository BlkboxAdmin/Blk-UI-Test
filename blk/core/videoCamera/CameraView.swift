//
//  CameraView.swift
//  ReelsCamera
//
//  Created by Nabeel Shafique on 04/12/2022.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
	
	@EnvironmentObject var cameraModel: CameraViewModel
	
    var body: some View {
		
		GeometryReader { geo in
			CameraPreview(size: geo.size)
				.environmentObject(cameraModel)
			
			ZStack(alignment: .leading) {
				Rectangle()
					.fill(.black.opacity(0.25))
				
				Rectangle()
					.fill(.pink)
					.frame(width: geo.size.width * (cameraModel.recordedDuration / cameraModel.maxDuration))
			}
			.frame(height: 8)
			.frame(maxHeight: .infinity, alignment: .top)
		}
		.onAppear(){
			cameraModel.checkPermission()
		}
		.alert(isPresented: $cameraModel.alert) {
			Alert(title: Text( "Please Enable Camera Access or Microphone Access."))
		}
		.onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) {_ in
			if cameraModel.recordedDuration <= cameraModel.maxDuration && cameraModel.isRecording {
				cameraModel.recordedDuration += 0.01
			}
			
			if cameraModel.recordedDuration >= cameraModel.maxDuration && cameraModel.isRecording {
				cameraModel.stopRecording()
				cameraModel.isRecording = false
			}
		}
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}

struct CameraPreview: UIViewRepresentable {
	
	@EnvironmentObject var cameraModel: CameraViewModel
	var size: CGSize
	
	func makeUIView(context: Context) -> UIView {
		let view = UIView()
		cameraModel.preview = AVCaptureVideoPreviewLayer(session: cameraModel.session)
		cameraModel.preview.frame.size = size
		cameraModel.preview.videoGravity = .resizeAspectFill
		view.layer.addSublayer(cameraModel.preview)
		
		DispatchQueue.main.async {
			cameraModel.session.startRunning()
		}
	
		return view
	}
	
	func updateUIView(_ uiView: UIView ,context: Context) {
		
	}
}
