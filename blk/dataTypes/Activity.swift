//
//  Activity.swift
//  blk
//
//  Created by Nabeel Shafique on 02/11/2022.
//

import Foundation

struct ActivityListData: Decodable {
	let data: ActivityData
	
}

struct ActivityData: Decodable {
	let rows: [Activity]
	let page: Int
	let perPage: Int
	let offset: Int
	let totalRows: Int
	let totalPages: Int
}

struct Activity: Hashable, Codable, Identifiable {
	var id: String
	var type: String
	var text: String
	var user_id: String
	var template_id: String
	var created_by: String
	var created_on: String
	var status: String
}
