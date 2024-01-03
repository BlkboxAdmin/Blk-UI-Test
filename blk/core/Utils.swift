//
//  Utils.swift
//  blk
//
//  Created by Nabeel Shafique on 01/11/2022.
//

import Foundation

func saveUserPref(_ key: String, _ value: User) {
	
	do {
		// Create JSON Encoder
		let encoder = JSONEncoder()
		
		// Encode Note
		let data = try encoder.encode(value)
		
		// Write/Set Data
		UserDefaults.standard.set(data, forKey: key)
		
	} catch {
		print("Unable to Encode User (\(error))")
	}
}

func getUserPref(_ key: String) -> User? {
	var user: User?
	if let data = UserDefaults.standard.data(forKey: key) {
		do {
			// Create JSON Decoder
			let decoder = JSONDecoder()
			
			// Decode Note
			user = try decoder.decode(User.self, from: data)
			
		} catch {
			print("Unable to Decode User (\(error))")
		}
	}
	
	return user
}

func removeUserPref(_ key: String) {
	UserDefaults.standard.removeObject(forKey: key)
}

func load<T: Decodable>(_ filename: String) -> T {
	let data: Data
	
	guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
	else {
		fatalError("Couldn't find \(filename) in main bundle.")
	}
	
	do {
		data = try Data(contentsOf: file)
	} catch {
		fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
	}
	
	do {
		let decoder = JSONDecoder()
		return try decoder.decode(T.self, from: data)
	} catch {
		fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
	}
}
