//
//  UrlX.swift
//  blk
//
//  Created by Nabeel Shafique on 03/12/2022.
//

import Foundation
import UniformTypeIdentifiers

extension URL {
	var mimeType: String {
		if let mimeType = UTType(filenameExtension: self.pathExtension)?.preferredMIMEType {
			return mimeType
		}
		else {
			return "application/octet-stream"
		}
	}
}
