//
//  NotificationRowView.swift
//  blk
//
//  Created by Nabeel Shafique on 01/11/2022.
//

import SwiftUI

struct NotificationRowView: View {
	
	var notification: Notification
	
    var body: some View {
		HStack{
			Text(notification.text)
				.foregroundColor(ColorX.primaryFg)
				.fontSize(18)
			
			Spacer()
			VStack(alignment: .center) {
				if !notification.isRead {
					Image("notification-unread")
						.margin(top: 8)
				}
				Spacer()
			}
		}
		.background(Color.black)
    }
}

struct NotificationRowView_Previews: PreviewProvider {
    static var previews: some View {
		
		let notifications: [Notification] = load("notifications.json")
		NotificationRowView(notification: notifications[0])
    }
}
