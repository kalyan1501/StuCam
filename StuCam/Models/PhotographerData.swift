import Foundation
import SwiftUI

struct BookingEvent: Identifiable, Equatable {
    enum Status: CaseIterable, Equatable {
        case confirmed
        case pending
        case completed
        
        var title: String {
            switch self {
            case .confirmed: return "Confirmed"
            case .pending: return "Pending"
            case .completed: return "Completed"
            }
        }
        
        var color: Color {
            switch self {
            case .confirmed: return .green
            case .pending: return .orange
            case .completed: return .gray
            }
        }
    }
    
    let id = UUID()
    let title: String
    let clientName: String
    let photographerName: String
    let date: Date
    let location: String
    let icon: String
    let status: Status
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
    static let sample: [BookingEvent] = [
        BookingEvent(
            title: "Wedding Session",
            clientName: "Samantha",
            photographerName: "Sharat Photography",
            date: Date().addingTimeInterval(60 * 60 * 2),
            location: "St. Paul's Cathedral",
            icon: "camera.fill",
            status: .confirmed
        ),
        BookingEvent(
            title: "Portrait Session",
            clientName: "Mike",
            photographerName: "P3 Productions",
            date: Date().addingTimeInterval(60 * 60 * 6),
            location: "Greenwich Park",
            icon: "person.crop.square",
            status: .pending
        ),
        BookingEvent(
            title: "Brand Shoot",
            clientName: "Kalyan",
            photographerName: "Peram Photography",
            date: Date().addingTimeInterval(-60 * 60 * 24),
            location: "Studio Loft",
            icon: "camera.metering.center.weighted",
            status: .completed
        )
    ]
}

struct ActivityItem: Identifiable {
    enum Kind {
        case like
        case comment
        case booking
    }
    
    let id = UUID()
    let title: String
    let subtitle: String
    let timeAgo: String
    let icon: String
    let color: Color
    
    static let sample: [ActivityItem] = [
        .init(title: "Jane Doe liked your photo", subtitle: "'Sunset Portrait'", timeAgo: "2m ago", icon: "heart.fill", color: .pink),
        .init(title: "New comment", subtitle: "“Loved the edits on this set!”", timeAgo: "10m ago", icon: "text.bubble.fill", color: .blue),
        .init(title: "New booking request", subtitle: "Graduation Shoot • June 20", timeAgo: "25m ago", icon: "calendar.badge.plus", color: .orange)
    ]
}

struct FeedPost: Identifiable {
    let id = UUID()
    let authorName: String
    let handle: String
    let title: String
    let body: String
    let imageName: String
    let likes: Int
    let comments: Int
    let saves: Int
    let tags: [String]
    let isFollowing: Bool
    let isNearby: Bool
    
    static let sample: [FeedPost] = [
        .init(
            authorName: "Jessica Park",
            handle: "@jessica_photography",
            title: "Samantha's Graduation Photos",
            body: "So excited to share these shots from Samantha's graduation day! The energy was incredible.",
            imageName: "graduation",
            likes: 1200,
            comments: 243,
            saves: 78,
            tags: ["portrait", "graduation", "studentphotographer"],
            isFollowing: true,
            isNearby: true
        ),
        .init(
            authorName: "Sharat Photography",
            handle: "@sharat_photos",
            title: "Golden Hour Wedding Shots",
            body: "Captured this beautiful couple during golden hour. The lighting was absolutely perfect! 🌅",
            imageName: "couple",
            likes: 2340,
            comments: 456,
            saves: 189,
            tags: ["wedding", "goldenhour", "love"],
            isFollowing: true,
            isNearby: false
        ),
        .init(
            authorName: "Peram Photography",
            handle: "@peram_lens",
            title: "Corporate Event Coverage",
            body: "Had an amazing time covering this tech conference. The energy and innovation were inspiring!",
            imageName: "tech",
            likes: 1580,
            comments: 198,
            saves: 92,
            tags: ["corporate", "event", "business"],
            isFollowing: true,
            isNearby: true
        ),
        .init(
            authorName: "P3 Productions",
            handle: "@p3_productions",
            title: "Fashion Week Behind the Scenes",
            body: "Taking you behind the scenes of fashion week! The energy backstage is always electric. ⚡",
            imageName: "fashion",
            likes: 3200,
            comments: 567,
            saves: 234,
            tags: ["fashion", "runway", "bts"],
            isFollowing: false,
            isNearby: false
        ),
        .init(
            authorName: "Urban Shots",
            handle: "@urban_shots",
            title: "City Vibes Photoshoot",
            body: "Loved the textures downtown for this editorial set.",
            imageName: "downtown",
            likes: 892,
            comments: 150,
            saves: 45,
            tags: ["urban", "fashion", "studentphotographer"],
            isFollowing: false,
            isNearby: true
        ),
        .init(
            authorName: "Sharat Photography",
            handle: "@sharat_photos",
            title: "Lifestyle Portrait Session",
            body: "Sometimes the best portraits happen in natural moments. Love this candid series! 📸",
            imageName: "potrait",
            likes: 1890,
            comments: 312,
            saves: 145,
            tags: ["portrait", "lifestyle", "candid"],
            isFollowing: true,
            isNearby: false
        ),
        .init(
            authorName: "P3 Productions",
            handle: "@p3_productions",
            title: "Product Photography Tips",
            body: "Here's how we achieve that clean, professional look for product shots. Swipe for setup details!",
            imageName: "product",
            likes: 2670,
            comments: 423,
            saves: 567,
            tags: ["product", "commercial", "tips"],
            isFollowing: false,
            isNearby: true
        ),
        .init(
            authorName: "Peram Photography",
            handle: "@peram_lens",
            title: "Nature's Canvas",
            body: "Early morning landscape shoot. The mist rolling over the hills was breathtaking! 🏔️",
            imageName: "landscape",
            likes: 2100,
            comments: 289,
            saves: 178,
            tags: ["landscape", "nature", "morning"],
            isFollowing: true,
            isNearby: true
        )
    ]
}

