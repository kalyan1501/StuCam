import SwiftUI

struct NotificationView: View {
    @Environment(\.dismiss) var dismiss
    let role: UserRole
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Header
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title3)
                        .foregroundStyle(.primary)
                        .frame(width: 44, height: 44)
                }
                
                Text("Notifications")
                    .font(.largeTitle.bold())
                
                Spacer()
                
                Button {
                    // Mark all as read
                } label: {
                    Image(systemName: "checkmark.circle")
                        .font(.title3)
                        .foregroundStyle(.primary)
                        .frame(width: 44, height: 44)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 12)
            .background(Color(.systemGroupedBackground))
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // Today Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Today")
                            .font(.title3.bold())
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            ForEach(todayNotifications) { notification in
                                NotificationRow(notification: notification)
                            }
                        }
                    }
                    
                    // This Week Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("This Week")
                            .font(.title3.bold())
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            ForEach(thisWeekNotifications) { notification in
                                NotificationRow(notification: notification)
                            }
                        }
                    }
                    
                    // This Month Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("This Month")
                            .font(.title3.bold())
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            ForEach(thisMonthNotifications) { notification in
                                NotificationRow(notification: notification)
                            }
                        }
                    }
                }
                .padding(.vertical, 16)
            }
            .background(Color(.systemGroupedBackground))
        }
        .navigationBarHidden(true)
    }
    
    private var todayNotifications: [FeedNotification] {
        if role == .photographer {
            return [
                FeedNotification(
                    id: "1",
                    userName: "Sarah Chen",
                    userAvatar: "person.crop.circle.fill",
                    message: "sent you a new booking request for 'Graduation Photoshoot'.",
                    timeAgo: "15m ago",
                    type: .booking,
                    actionButton: nil,
                    thumbnailImages: []
                ),
                FeedNotification(
                    id: "2",
                    userName: "Maya Garcia",
                    userAvatar: "person.crop.circle.fill",
                    message: "liked a photo in your 'Cityscapes' album.",
                    timeAgo: "1h ago",
                    type: .like,
                    actionButton: nil,
                    thumbnailImages: ["photo.fill"]
                ),
            ]
        } else {
            return [
                FeedNotification(
                    id: "1",
                    userName: "Sarah Chen",
                    userAvatar: "person.crop.circle.fill",
                    message: "accepted your booking request for 'Graduation Photoshoot'.",
                    timeAgo: "15m ago",
                    type: .booking,
                    actionButton: nil,
                    thumbnailImages: []
                ),
                FeedNotification(
                    id: "2",
                    userName: "Maya Garcia",
                    userAvatar: "person.crop.circle.fill",
                    message: "liked your comment: \"Stunning shots!\"",
                    timeAgo: "1h ago",
                    type: .like,
                    actionButton: nil,
                    thumbnailImages: []
                ),
            ]
        }
    }
    
    private var thisWeekNotifications: [FeedNotification] {
        if role == .photographer {
            return [
                FeedNotification(
                    id: "3",
                    userName: "Alex Johnson",
                    userAvatar: "person.crop.circle.fill",
                    message: "left a new 5-star review on your profile.",
                    timeAgo: "2d ago",
                    type: .review,
                    actionButton: nil,
                    thumbnailImages: []
                ),
                FeedNotification(
                    id: "4",
                    userName: "Liam O'Connell",
                    userAvatar: "person.crop.circle.fill",
                    message: "rejected your booking proposal for 'Family Portraits'.",
                    timeAgo: "4d ago",
                    type: .booking,
                    actionButton: nil,
                    thumbnailImages: []
                ),
                FeedNotification(
                    id: "5",
                    userName: "Jessica Park",
                    userAvatar: "person.crop.circle.fill",
                    message: "from your contacts is now on StuCam.",
                    timeAgo: "6d ago",
                    type: .follow,
                    actionButton: nil,
                    thumbnailImages: []
                ),
            ]
        } else {
            return [
                FeedNotification(
                    id: "3",
                    userName: "Alex Johnson",
                    userAvatar: "person.crop.circle.fill",
                    message: "posted 3 new photos.",
                    timeAgo: "2d ago",
                    type: .post,
                    actionButton: nil,
                    thumbnailImages: ["photo.fill", "photo.fill"]
                ),
                FeedNotification(
                    id: "4",
                    userName: "Liam O'Connell",
                    userAvatar: "person.crop.circle.fill",
                    message: "sent you a new message.",
                    timeAgo: "4d ago",
                    type: .message,
                    actionButton: nil,
                    thumbnailImages: []
                ),
            ]
        }
    }
    
    private var thisMonthNotifications: [FeedNotification] {
        if role == .photographer {
            return [
                FeedNotification(
                    id: "6",
                    userName: "Jessica Park",
                    userAvatar: "person.crop.circle.fill",
                    message: "commented on your post: \"Love the lighting here!\"",
                    timeAgo: "2w ago",
                    type: .comment,
                    actionButton: nil,
                    thumbnailImages: ["photo.fill"]
                ),
            ]
        } else {
            return [
                FeedNotification(
                    id: "5",
                    userName: "Jessica Park",
                    userAvatar: "person.crop.circle.fill",
                    message: "from your contacts is now on StuCam.",
                    timeAgo: "2w ago",
                    type: .follow,
                    actionButton: "Follow",
                    thumbnailImages: []
                ),
            ]
        }
    }
}

private struct NotificationRow: View {
    let notification: FeedNotification
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                // Avatar with badge
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(notification.avatarColor.opacity(0.2))
                        .frame(width: 56, height: 56)
                        .overlay(
                            Image(systemName: notification.userAvatar)
                                .font(.title2)
                                .foregroundStyle(notification.avatarColor)
                        )
                    
                    // Type badge
                    if notification.type != .none {
                        Circle()
                            .fill(notification.type.color)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Image(systemName: notification.type.iconName)
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(.white)
                            )
                    }
                }
                
                // Content
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            // Message
                            Text(notification.attributedMessage)
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                                .lineLimit(3)
                            
                            // Time
                            Text(notification.timeAgo)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        // Action button
                        if let actionButton = notification.actionButton {
                            Button {
                                // Action
                            } label: {
                                Text(actionButton)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.blue)
                                    .clipShape(Capsule())
                            }
                        }
                        
                        // Thumbnails
                        if !notification.thumbnailImages.isEmpty {
                            HStack(spacing: 6) {
                                ForEach(notification.thumbnailImages.prefix(2), id: \.self) { image in
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.15))
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Image(systemName: image)
                                                .font(.title3)
                                                .foregroundStyle(.gray.opacity(0.5))
                                        )
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

struct FeedNotification: Identifiable {
    let id: String
    let userName: String
    let userAvatar: String
    let message: String
    let timeAgo: String
    let type: NotificationType
    let actionButton: String?
    let thumbnailImages: [String]
    
    var avatarColor: Color {
        let colors: [Color] = [.blue, .purple, .orange, .pink, .teal, .indigo, .green, .cyan]
        return colors[abs(userName.hashValue) % colors.count]
    }
    
    var attributedMessage: AttributedString {
        var result = AttributedString(userName)
        result.font = .subheadline.bold()
        result.append(AttributedString(" " + message))
        return result
    }
    
    enum NotificationType {
        case booking
        case like
        case comment
        case follow
        case message
        case post
        case review
        case none
        
        var iconName: String {
            switch self {
            case .booking: return "checkmark"
            case .like: return "heart.fill"
            case .comment: return "bubble.left.fill"
            case .follow: return "person.fill"
            case .message: return "envelope.fill"
            case .post: return "photo.fill"
            case .review: return "star.fill"
            case .none: return ""
            }
        }
        
        var color: Color {
            switch self {
            case .booking: return .green
            case .like: return .red
            case .comment: return .blue
            case .follow: return .purple
            case .message: return .orange
            case .post: return .cyan
            case .review: return .yellow
            case .none: return .clear
            }
        }
    }
}

#Preview {
    NotificationView(role: .photographer)
}

