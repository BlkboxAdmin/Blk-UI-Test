//
//  Auth.swift
//  blk
//
//  Created by Nabeel Shafique on 23/11/2022.
//

import Foundation


struct Auth: Decodable {
	let data: AuthData
	
}

struct AuthData: Decodable {
	let accessToken: String
	let user: User
}
