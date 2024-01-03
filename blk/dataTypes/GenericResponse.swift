//
//  GenericResponse.swift
//  blk
//
//  Created by Nabeel Shafique on 12/11/2022.
//

import Foundation

struct GenericResponse: Decodable {
	let statusCode: Int
	let statusMessage: String
	let message: String
	//let data: AnyObject
}
