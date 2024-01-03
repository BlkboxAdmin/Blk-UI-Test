//
//  App.swift
//  blk
//
//  Created by Nabeel Shafique on 23/11/2022.
//

import Foundation

struct Common {
	static let baseUrl = "http://blkboxtest-env.eba-u3majsyf.us-west-1.elasticbeanstalk.com"
	static let siteUrl = "http://blkboxtest-env.eba-u3majsyf.us-west-1.elasticbeanstalk.com/"
	static let jwtKey = "blkboxJWT"
	static let userKey = "USER"
	static var deviceTokenKey = "APN_DEVICE_TOKEN"
	static var CF_ACCOUNT_HASH = ""
	static var CF_IMG_HOST = ""
	static var CF_VIDEO_HOST = ""
	static var user: User? = nil
}
