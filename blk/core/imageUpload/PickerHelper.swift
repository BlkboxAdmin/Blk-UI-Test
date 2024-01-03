//
//  PickerHelper.swift
//  blk
//
//  Created by Nabeel Shafique on 03/11/2022.
//

import SwiftUI

// ImagePicker & CameraPicker
func loadImage(pInputImage: UIImage?) -> Image? {
	guard let inputImage = pInputImage else { return nil }
	return Image(uiImage: inputImage)
}
