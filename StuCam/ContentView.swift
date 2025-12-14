//
//  ContentView.swift
//  StuCam
//
//  Created by M Kalyan on 11/16/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedRole: UserRole?
    
    var body: some View {
        if let role = selectedRole {
            MainAppView(role: role, resetRole: { selectedRole = nil })
        } else {
            NavigationStack {
                RoleSelectionView { role in
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        selectedRole = role
                    }
                }
            }
        }
    }
}

private struct MainAppView: View {
    let role: UserRole
    let resetRole: () -> Void
    
    @State private var selectedTab: AppTab = .home
    private let photographer = Photographer.mock
    private let events = BookingEvent.sample
    private let activities = ActivityItem.sample
    private let posts = FeedPost.sample
    @State private var threads = MessageThread.sampleThreads
    @State private var hasUnreadMessages = true
    
    private var unreadMessages: Int {
        hasUnreadMessages ? max(1, threads.count / 2) : 0
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            homeScreen
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(AppTab.home)
            
            feedScreen
                .tabItem {
                    Label("Feed", systemImage: "square.grid.2x2")
                }
                .tag(AppTab.feed)
            
            bookingsScreen
                .tabItem {
                    Label("Bookings", systemImage: "calendar")
                }
                .tag(AppTab.bookings)
            
            Group {
                if unreadMessages > 0 {
                    MessagingView(threads: threads)
                        .tabItem {
                            Label("Messages", systemImage: "bubble.left.and.bubble.right")
                        }
                        .badge(unreadMessages)
                } else {
                    MessagingView(threads: threads)
                        .tabItem {
                            Label("Messages", systemImage: "bubble.left.and.bubble.right")
                        }
                }
            }
            .tag(AppTab.messages)
            
            profileScreen
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(AppTab.profile)
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            if newValue == .messages {
                hasUnreadMessages = false
            }
        }
    }
    
    @ViewBuilder
    private var homeScreen: some View {
        if role == .client {
            DiscoveryView(photographer: photographer)
        } else {
            PhotographerHomeView(
                photographer: photographer,
                todaysEvents: events,
                activityItems: activities
            )
        }
    }
    
    private var feedScreen: some View {
        SocialFeedView(posts: posts, role: role)
    }
    
    @ViewBuilder
    private var bookingsScreen: some View {
        if role == .client {
            NavigationStack {
                ClientBookingsView(bookings: events)
            }
        } else {
            PhotographerBookingsView(events: events)
        }
    }
    
    @ViewBuilder
    private var profileScreen: some View {
        if role == .client {
            NavigationStack {
                ClientProfileView(onLogout: resetRole)
        }
        } else {
            NavigationStack {
                PhotographerProfileView(photographer: photographer, onLogout: resetRole)
    }
        }
    }
}

private enum AppTab: Hashable {
    case home, feed, bookings, messages, profile
}

#Preview {
    ContentView()
}
