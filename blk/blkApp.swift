//
//  blkApp.swift
//  blk
//
//  Created by Nabeel Shafique on 30/10/2022.
//

import SwiftUI

@main
struct blkApp: App {
	
	@UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
	
    var body: some Scene {
		
        WindowGroup {
            SplashScreenView()
        }
    }
}
