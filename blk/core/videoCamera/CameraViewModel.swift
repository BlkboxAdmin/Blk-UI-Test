//
//  CameraViewModel.swift
//  ReelsCamera
//
//  Created by Nabeel Shafique on 04/12/2022.
//

import Foundation
import AVFoundation
import UIKit

class CameraViewModel: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate {
	
	@Published var alert: Bool = false
	@Published var session = AVCaptureSession()
	@Published var output = AVCaptureMovieFileOutput()
	@Published var preview: AVCaptureVideoPreviewLayer!
	@Published var videoDeviceInput: AVCaptureDeviceInput!
	@Published var audioDeviceInput: AVCaptureDeviceInput!
	
	// MARK: Vidoe recording properties
	private var isFrontCam: Bool = false
	@Published var isRecording: Bool = false
	@Published var recordedURLs: [URL] = []
	@Published var previewURL: URL?
	@Published var previewImage: UIImage?
	@Published var showPreview: Bool = false
	
	@Published var recordedDuration: CGFloat = 0
	@Published var maxDuration: CGFloat = 20
	
	func checkPermission()
	{
		switch AVCaptureDevice.authorizationStatus(for: .video) {
		case .authorized:
			setUp()
			return
		case .notDetermined:
			
			AVCaptureDevice.requestAccess(for: .video) { status in
				if status {
					self.setUp()
				}
			}
			
			setUp()
			return
		case .denied:
			self.alert.toggle()
			return
		default:
			return
		}
	}
	
	func setUp() {
		do {
			self.session.beginConfiguration()
			let cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: isFrontCam ? .front : .back)
			let videoInput = try AVCaptureDeviceInput(device: cameraDevice!)
			let audioDevice = AVCaptureDevice.default(for: .audio)
			let audioInput = try AVCaptureDeviceInput(device: audioDevice!)
			
			if self.session.canAddInput(videoInput) && self.session.canAddInput(audioInput) {
				self.session.addInput(videoInput)
				videoDeviceInput = videoInput
				self.session.addInput(audioInput)
				audioDeviceInput = audioInput
			}
			
			if self.session.canAddOutput(self.output) {
				self.session.addOutput(self.output)
			}
			
			self.session.commitConfiguration()
		}
		catch {
			print(error.localizedDescription)
		}
	}
	
	func changeCamera() {
		isFrontCam = !isFrontCam
		self.session.removeInput(videoDeviceInput)
		self.session.removeInput(audioDeviceInput)
		setUp()
	}
	
	func startRecording() {
		// MARK: Temparay url for recording video
		let tempUrl = NSTemporaryDirectory() + "\(Date()).mov"
		
		output.startRecording(to: getTempUrl(filePath: tempUrl), recordingDelegate: self)
		
		isRecording = true
	}
	
	func stopRecording() {
		output.stopRecording()
		isRecording = false
	}
	
	func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
		
		if let error = error {
			print(error.localizedDescription)
			return
		}
		
		recordedURLs.append(outputFileURL)
		
		if recordedURLs.count == 1 {
			previewURL = outputFileURL
			previewImage = self.generateThumbnail(self.previewURL!)
			return
		}
		
		previewURL = nil
		
		// converting urls to assets
		let assets = recordedURLs.compactMap { url -> AVURLAsset in
			return AVURLAsset(url: url)
		}
		
		mergeVideos(assets: assets) { exporter in
			exporter.exportAsynchronously {
				if exporter.status == .failed {
					print(exporter.error!)
				}
				else {
					if let finalURL = exporter.outputURL {
						print(finalURL)
						DispatchQueue.main.async {
							self.previewURL = finalURL
							self.previewImage = self.generateThumbnail(self.previewURL!)
						}
					}
				}
			}
		}
	}
	
	func mergeVideos(assets: [AVURLAsset], completion: @escaping ( _ exporter: AVAssetExportSession) -> () ) {
		let composition = AVMutableComposition()
		var lastTime: CMTime = .zero
		
		guard let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { return }
		guard let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { return }
		
		for asset in assets {
			
			getAssetDuration(asset: asset) { assetDuration in
				
				self.getAssetTracks(asset: asset, mediaType: .video) { tracks in
					do {
						try videoTrack.insertTimeRange(CMTimeRange(start: .zero, duration: assetDuration), of: tracks[0], at: lastTime)
					} catch {
						print(error.localizedDescription)
					}
				}
				
				self.getAssetTracks(asset: asset, mediaType: .audio) { tracks in
					do {
						if !tracks.isEmpty {
							try audioTrack.insertTimeRange(CMTimeRange(start: .zero, duration: assetDuration), of: tracks[0], at: lastTime)
						}
					} catch {
						print(error.localizedDescription)
					}
				}
				
				lastTime = CMTimeAdd(lastTime, assetDuration)
			}
		}
		
		let tempURL = getTempUrl(filePath: NSTemporaryDirectory() + "reel-\(Date()).mp4")
		
		let layerInstructions = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
		
		// rotate video
		var transform = CGAffineTransform.identity
		transform = transform.rotated(by: 90 * (.pi / 180))
		transform = transform.translatedBy(x: 0, y: -videoTrack.naturalSize.height)
		layerInstructions.setTransform(transform, at: .zero)
		
		let instructions = AVMutableVideoCompositionInstruction()
		instructions.timeRange = CMTimeRange(start: .zero, duration: lastTime)
		instructions.layerInstructions = [layerInstructions]
		
		let videoComposition = AVMutableVideoComposition()
		videoComposition.renderSize = CGSize(width: videoTrack.naturalSize.height, height: videoTrack.naturalSize.width)
		videoComposition.instructions = [instructions]
		videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
		
		guard let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else { return }
		exporter.outputFileType = .mp4
		exporter.outputURL = tempURL
		exporter.videoComposition = videoComposition
		completion(exporter)
	}
	
	func getTempUrl(filePath: String ) -> URL {
		if #available(iOS 16.0, *) {
			return URL(filePath: NSTemporaryDirectory() + "reel-\(Date()).mp4")
		} else {
			return URL(fileURLWithPath: NSTemporaryDirectory() + "reel-\(Date()).mp4")
		}
	}
	
	func getAssetTracks(asset: AVURLAsset, mediaType: AVMediaType , callback: (([AVAssetTrack]) throws -> ())? = nil ) {
		if #available(iOS 16.0, *) {
			Task {
				do {
					let tracks = try await asset.loadTracks(withMediaType: mediaType)
					try callback?(tracks)
				}
				catch {
				 	try callback?([])
				}
			}
		} else {
			try! callback?(asset.tracks(withMediaType: mediaType))
		}
	}
	
	func getAssetDuration(asset: AVURLAsset, callback: ((CMTime) -> Void)? = nil ) {
		if #available(iOS 16.0, *) {
			Task {
				let duration = try! await asset.load(.duration)
				callback?(duration)
			}
		} else {
			callback?(asset.duration)
		}
	}
	
	func generateThumbnail(_ url: URL) -> UIImage? {
		do {
			let asset = AVURLAsset(url: url)
			let imageGenerator = AVAssetImageGenerator(asset: asset)
			imageGenerator.appliesPreferredTrackTransform = true
			
			// Swift 5.3
			let cgImage = try imageGenerator.copyCGImage(at: .zero,
														 actualTime: nil)
			
			return UIImage(cgImage: cgImage)
		} catch {
			print(error.localizedDescription)
			
			return nil
		}
	}
	
	func reset() {
		recordedDuration = 0
		previewURL = nil
		previewImage = nil
		recordedURLs.removeAll()
	}
	
}
