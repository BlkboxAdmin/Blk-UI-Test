//
//  APIManager.swift
//  blk
//
//  Created by Nabeel Shafique on 24/11/2022.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper
import UIKit

enum ResponseStatus {
	case success, warning, error
}

typealias callBackData = ((_ data: Data, _ status: ResponseStatus, _ message: String) -> Void)?
typealias callBackUploadData = ((_ data: UploadResult?, _ status: ResponseStatus, _ message: String) -> Void)?
typealias callBackUploadProgress = ((Progress) -> Void)?
typealias callback = ((_ message: String, _ status: ResponseStatus) -> Void)?


class APIManager {
	public static let shared = APIManager()
	
	private let host: String = Common.baseUrl
	
	func request( method: HTTPMethod, params: Parameters?, endPoint: String, authorization: Bool = true, _ callback: callBackData = nil)  {
		
		let token: String? = KeychainWrapper.standard.string(forKey: Common.jwtKey) ?? "none"
		let headers: HTTPHeaders? = authorization ? [.authorization(bearerToken: token!)] : nil
		let encoding: ParameterEncoding = (method == .get) ? URLEncoding.default : JSONEncoding.default
		let request = AF.request("\(host)\(endPoint)",
								 method: method,
								 parameters: params,
								 encoding: encoding,
								 headers: headers
		)
		
		request.responseData { response in
			
			switch response.result {
			case .success:
				let detail = try? JSONDecoder().decode(GenericResponse.self, from: response.data!)
				let message = detail?.message ?? "Server Error! Please try again later"
				let statusCode = detail?.statusCode ?? 503
				var status: ResponseStatus = .success
				
				if statusCode > 202 {
					status = .warning
				}
				
				if statusCode > 403 {
					status = .error
				}
				
				//print(String(decoding: response.data!, as: UTF8.self))
				//print(detail ?? "nil")
				//debugPrint(detail ?? "nil")
				
				callback?(response.data!, status, message)
				
			case let .failure(error):
				print(error)
			}
		}
	}
	
	func imageUpload(endPoint: String, image: UIImage, fileName: String? = "file", params : [String: String] = [:] , uploadProgress: callBackUploadProgress, _ callback: callBackUploadData = nil) {
		
		let imgData: Data = image.pngData()!
		
		AF.upload(multipartFormData: { multipartFormData in
			
			multipartFormData.append(imgData, withName: "file", fileName: "\(fileName!).png", mimeType: "image/png")
			
			for (key, value) in params {
				multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
			}
		}, to: endPoint)
		
		.uploadProgress(closure: { (progress) in
			uploadProgress?(progress)
		})
		.responseData() { response in
			
			switch response.result {
			case .success:
				let detail = try? JSONDecoder().decode(GenericUpload.self, from: response.data!)
				
				if detail == nil {
					callback?(nil, .error, "Upload failed")
					return
				}
				
				if !detail!.success {
					
					debugPrint(detail?.errors ?? "nil")
					debugPrint(detail?.messages ?? "nil")
					
					callback?(nil, .error, "Upload failed")
					
					return
				}
				
				callback?(detail!.result, .success, "Uploaded successfully")
				
				
			case .failure(let encodingError):
				print(encodingError)
				callback?(nil, .error, "Uploaded with errors")
			}
		}
	}
	
	func videoUpload(endPoint: String, video: URL, fileName: String? = "file", params : [String: String] = [:] , uploadProgress: callBackUploadProgress, _ callback: callBackUploadData = nil) {
		
		//let imgData: Data = image.pngData()!
		
		AF.upload(multipartFormData: { multipartFormData in
			
			multipartFormData.append(video, withName: "file", fileName: "\(fileName!).\(video.pathExtension)", mimeType: video.mimeType)
			
			for (key, value) in params {
				multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
			}
		}, to: endPoint)
		
		.uploadProgress(closure: { (progress) in
			uploadProgress?(progress)
		})
		.responseData() { response in
			
			switch response.result {
			case .success:
				let detail = try? JSONDecoder().decode(GenericUpload.self, from: response.data!)
				
				if detail == nil {
					callback?(nil, .error, "Upload failed")
					return
				}
				
				if !detail!.success {
					
					debugPrint(detail?.errors ?? "nil")
					debugPrint(detail?.messages ?? "nil")
					
					callback?(nil, .error, "Upload failed")
					
					return
				}
				
				callback?(nil, .success, "Uploaded successfully")
				
				
			case .failure(let encodingError):
				print(encodingError)
				callback?(nil, .error, "Uploaded with errors")
			}
		}
	}
}
