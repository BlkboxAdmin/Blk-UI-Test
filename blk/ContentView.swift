//
//  ContentView.swift
//  blk
//
//  Created by Nabeel Shafique on 30/10/2022.
//

import SwiftUI

struct ContentView: View {
	
	@ObservedObject var appState = AppState.shared
	@StateObject var viewModel = MainViewModel()
	@StateObject var signInViewModel: SignInViewModel
	@State private var viewAllNotifications: Bool = false
	@State private var activeTab: Int = 0
	@EnvironmentObject var toastControl: ToastControl
	
	var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
			NavigationView {
				ZStack {
					
					// push notificaitons redirects
					if viewModel.navigate {
						NavigationLink(destination: BlkTalksView(), isActive: $viewModel.isNewMessage) { EmptyView() }
						NavigationLink(destination: BlkBoardView(userId: appState.profileId), isActive: $viewModel.isNewFriendRequest) { EmptyView() }
					}
					
					TabView {
						
						mainView
							.onAppear() {
								activeTab = 0
							}
							.onDisappear() {
								activeTab = 1
							}
						
						BlkTopView()
					}
					.background(Color.black)
					.tabViewStyle(.page(indexDisplayMode: .never))
					.ignoresSafeArea()
					
					if activeTab == 0 {
						swipeInfoView
					}
				}
				.navigationBarHidden(true)
				.onReceive(appState.$notificationType) { type in
					if type == .message {
						viewModel.isNewMessage = !appState.sender_user_id.isEmpty && !appState.receiver_user_id.isEmpty
					}
					
					if type == .friendRequest {
						viewModel.isNewFriendRequest = !appState.profileId.isEmpty
					}
					
					viewModel.navigate = true
				}
			}
			.accentColor(.white)
			CommonView(viewModel: .constant(viewModel))
		}
	}
	
	var mainView: some View {
		VStack {
			headerView
				.margin(bottom: 40)
			
			ScrollView {
				VStack {
					VStack {
						notificationsView
							.margin(bottom: 36)
						
						DividerView()
					}
					.padding(.horizontal, 22)
					.margin(bottom: 45)
					
					dashboardBoxView
					
					Spacer()
				}
			}
		}
		.ignoresSafeArea()
	}
	
	var dashboardBoxView: some View {
		ZStack {
			Color.black.edgesIgnoringSafeArea(.all)
			VStack {
				HStack {
					NavigationLink(destination: BlkTalksView(), label: {
						boxButtonView(icon: "users", title: "BlkBox Talks")
					})
					
					NavigationLink(destination: BlkBookView(), label: {
						boxButtonView(icon: "book-open", title: "Blk Book")
					})
				}
				HStack {
					NavigationLink(destination: BlkBoardView(), label: {
						boxButtonView(icon: "columns", title: "Blk Board")
					})
					
					NavigationLink(destination: TimeStoriesView(), label: {
						boxButtonView()
					})
				}
			}
		}
	}
	
	func boxButtonView(icon: String = "", title: String = "") -> some View {
		
		VStack(alignment: .leading) {
			if icon.isEmpty && title.isEmpty {
				Image("time-stories")
					.padding(.leading, 21)
			}
			else {
				Image(icon)
					.margin(bottom: 28 ,left: 23)
				Text(title)
					.foregroundColor(ColorX.primaryFg)
					.fontSize(25)
					.multilineTextAlignment(.leading)
					.fontBold(.semibold)
					.frame(maxWidth: 85, alignment: .leading)
					.margin(left: 23)
			}
		}
		.frame(width: 178, height: 185, alignment: .leading)
		.background(ColorX.secondaryBg)
		.border(width: 1, cornerRadius: 14)
		
	}
	
	var notificationsView: some View {
		VStack {
			HStack {
				Image("bell")
				Text("Notifications")
					.fontSize(23)
					.fontBold(.medium)
					.foregroundColor(.white)
				Spacer()
				Button("View All", action: {
					viewAllNotifications.toggle()
				})
				.fontSize(18)
				.foregroundColor(ColorX.selectedFg)
			}
			
			ScrollView {
				LazyVStack(spacing: 15) {
					ForEach(viewModel.notifications, id: \.self) { notification in
						
						NotificationRowView(notification: notification)
					}
				}
			}
			.frame(maxHeight: viewAllNotifications ? .infinity : 105)
			.margin(top: 20)
			
		}
		.onAppear() {
			viewModel.getNotifications()
		}
	}
	
	var swipeInfoView: some View {
		GeometryReader { geo in
			HStack {
				Text("Swipe right to go to")
					.foregroundColor(ColorX.primaryFg)
				Text("BlkTop")
					.foregroundColor(ColorX.selectedFg)
					.fontBold(.bold)
					.fontSize(18)
			}
			.position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).maxY - 15)
		}
	}
	
	var headerView: some View {
		VStack {
			HStack {
				NavigationLink(destination: BlkCardView(userId: Common.user!.id), label: {
					UserImageView(img: viewModel.userImage)
						.margin(left: 22)
				})
				
				Spacer()
				
				Image("logo-grey-166x70")
					.blendMode(.lighten)
				
				Spacer()
				
				Button(action: {
					signInViewModel.logout()
				}, label: {
					Image("log-out")
				})
				.margin(right: 12)
			}
			.margin(top: 51, bottom: 5)
		}
		.onAppear() {
			viewModel.renderUser()
		}
		.frame(maxWidth: .infinity)
		.background(ColorX.secondaryBg)
		.cornerRadius(22)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		
		ContentView(signInViewModel: SignInViewModel())
    }
}
