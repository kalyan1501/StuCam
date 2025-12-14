import Foundation
import CoreLocation
import SwiftUI

enum UserRole {
    case client
    case photographer
}

struct Photographer: Identifiable {
    let id = UUID()
    let name: String
    let avatar: String
    let specialties: String
    let rating: Double
    let reviewsCount: Int
    let rate: String
    let projectsCount: Int
    let bio: String
    let locationCity: String
    let locationDescription: String
    let location: CLLocationCoordinate2D
    let headerColor: Color
    let coverImage: String?
    let portfolioColors: [Color]
    let portfolioImages: [String]?
    let availability: [Date]
    let reviews: [PhotographerReview]
    
    static let mock: Photographer = .init(
        name: "Sophia Carter",
        avatar: "sophia",
        specialties: "Portraits, Events",
        rating: 4.9,
        reviewsCount: 128,
        rate: "$50/hr",
        projectsCount: 54,
        bio: "I'm a photography student offering affordable portrait and event sessions while building my portfolio. Let's capture something beautiful together.",
        locationCity: "San Francisco, USA",
        locationDescription: "Union Square, San Francisco, CA",
        location: CLLocationCoordinate2D(latitude: 37.7879, longitude: -122.4075),
        headerColor: Color.blue.opacity(0.4),
        coverImage: "cover3",
        portfolioColors: [
            .blue.opacity(0.3),
            .pink.opacity(0.3),
            .purple.opacity(0.3),
            .green.opacity(0.3),
            .orange.opacity(0.3),
            .indigo.opacity(0.3)
        ],
        portfolioImages: ["sc1", "sc2", "sc3", "sc4", "sc5", "sc6", "sc7", "sc8", "sc9", "sc10", "sc11", "sc12"],
        availability: Photographer.mockAvailability,
        reviews: Photographer.mockReviews
    )
    
    static let sharatPhotography: Photographer = .init(
        name: "Sharat Photography",
        avatar: "sharat",
        specialties: "Wedding, Lifestyle",
        rating: 4.7,
        reviewsCount: 95,
        rate: "$40/hr",
        projectsCount: 42,
        bio: "Specializing in candid wedding moments and lifestyle photography. I focus on natural light and authentic emotions to tell your story.",
        locationCity: "San Francisco, USA",
        locationDescription: "Golden Gate Park, SF",
        location: CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094),
        headerColor: Color.purple.opacity(0.4),
        coverImage: "cover1",
        portfolioColors: [
            .purple.opacity(0.3),
            .pink.opacity(0.3),
            .orange.opacity(0.3),
            .yellow.opacity(0.3),
            .green.opacity(0.3),
            .blue.opacity(0.3)
        ],
        portfolioImages: ["sp1", "sp2", "sp3", "sp4", "sp5", "sp6", "sp7", "sp8", "sp9", "sp10", "sp11", "sp12"],
        availability: Photographer.mockAvailability,
        reviews: [
            .init(author: "Maya Patel", date: "July 10, 2024", rating: 5, comment: "Amazing work! Captured our wedding beautifully."),
            .init(author: "James Wilson", date: "June 5, 2024", rating: 5, comment: "Professional and creative. Highly recommend!")
        ]
    )
    
    static let p3Productions: Photographer = .init(
        name: "P3 Productions",
        avatar: "p3",
        specialties: "Fashion, Product",
        rating: 4.8,
        reviewsCount: 156,
        rate: "$45/hr",
        projectsCount: 67,
        bio: "Creative studio specializing in fashion editorials and commercial product photography. We bring brands to life through stunning visuals.",
        locationCity: "San Francisco, USA",
        locationDescription: "Fisherman's Wharf, SF",
        location: CLLocationCoordinate2D(latitude: 37.7899, longitude: -122.4014),
        headerColor: Color.green.opacity(0.4),
        coverImage: "cover2",
        portfolioColors: [
            .black.opacity(0.3),
            .gray.opacity(0.3),
            .red.opacity(0.3),
            .blue.opacity(0.3),
            .green.opacity(0.3),
            .yellow.opacity(0.3)
        ],
        portfolioImages: ["b1", "b2", "b3", "b4", "b5", "b6", "b7", "b8", "b9", "b10", "b11", "b12"],
        availability: Photographer.mockAvailability,
        reviews: [
            .init(author: "Sarah Kim", date: "August 2, 2024", rating: 5, comment: "Best product shots I've ever received!"),
            .init(author: "Alex Chen", date: "July 18, 2024", rating: 4, comment: "Great quality and fast turnaround.")
        ]
    )
    
    static let lensAndLight: Photographer = .init(
        name: "Lens & Light Studio",
        avatar: "lens",
        specialties: "Studio, Portrait",
        rating: 4.9,
        reviewsCount: 203,
        rate: "$55/hr",
        projectsCount: 89,
        bio: "Professional studio with state-of-the-art equipment. Specializing in high-end portraits, headshots, and editorial photography.",
        locationCity: "San Francisco, USA",
        locationDescription: "Mission District, SF",
        location: CLLocationCoordinate2D(latitude: 37.7799, longitude: -122.4194),
        headerColor: Color.orange.opacity(0.4),
        coverImage: "cover4",
        portfolioColors: [
            .orange.opacity(0.3),
            .red.opacity(0.3),
            .pink.opacity(0.3),
            .purple.opacity(0.3),
            .blue.opacity(0.3),
            .teal.opacity(0.3)
        ],
        portfolioImages: ["ls1", "ls2", "ls3", "ls4", "ls5", "ls6", "ls7", "ls8", "ls9", "ls10", "ls11", "ls12"],
        availability: Photographer.mockAvailability,
        reviews: [
            .init(author: "Emma Rodriguez", date: "August 15, 2024", rating: 5, comment: "Top-notch studio experience. Professional team!"),
            .init(author: "Michael Brown", date: "July 30, 2024", rating: 5, comment: "Best headshots in the city. Worth every penny!")
        ]
    )
    
    static let jessicaPark: Photographer = .init(
        name: "Jessica Park",
        avatar: "jessica",
        specialties: "Graduation, Portrait",
        rating: 4.8,
        reviewsCount: 142,
        rate: "$45/hr",
        projectsCount: 58,
        bio: "Capturing life's milestone moments with a fresh, creative perspective. Specializing in graduation, senior portraits, and lifestyle photography.",
        locationCity: "San Francisco, USA",
        locationDescription: "Presidio, San Francisco, CA",
        location: CLLocationCoordinate2D(latitude: 37.7989, longitude: -122.4662),
        headerColor: Color.pink.opacity(0.4),
        coverImage: "cover5",
        portfolioColors: [
            .pink.opacity(0.3),
            .purple.opacity(0.3),
            .blue.opacity(0.3),
            .teal.opacity(0.3),
            .green.opacity(0.3),
            .yellow.opacity(0.3)
        ],
        portfolioImages: ["a1", "a2", "a3", "a4", "a5", "a6", "a7", "a8", "a9", "a10", "a11", "a12"],
        availability: Photographer.mockAvailability,
        reviews: [
            .init(author: "Amanda Chen", date: "July 25, 2024", rating: 5, comment: "Jessica made my graduation photos absolutely stunning!"),
            .init(author: "Ryan Martinez", date: "June 12, 2024", rating: 5, comment: "Professional and creative. Highly recommended!")
        ]
    )
    
    static let peramPhotography: Photographer = .init(
        name: "Peram Photography",
        avatar: "person.crop.circle.fill",
        specialties: "Corporate, Landscape",
        rating: 4.7,
        reviewsCount: 118,
        rate: "$48/hr",
        projectsCount: 71,
        bio: "Professional photographer with expertise in corporate events and breathtaking landscape photography. Delivering high-quality images for businesses and nature lovers.",
        locationCity: "San Francisco, USA",
        locationDescription: "Financial District, SF",
        location: CLLocationCoordinate2D(latitude: 37.7946, longitude: -122.3999),
        headerColor: Color.teal.opacity(0.4),
        coverImage: nil,
        portfolioColors: [
            .teal.opacity(0.3),
            .blue.opacity(0.3),
            .green.opacity(0.3),
            .cyan.opacity(0.3),
            .indigo.opacity(0.3),
            .purple.opacity(0.3)
        ],
        portfolioImages: nil,
        availability: Photographer.mockAvailability,
        reviews: [
            .init(author: "David Lee", date: "August 5, 2024", rating: 5, comment: "Perfect corporate event coverage. Very professional!"),
            .init(author: "Lisa Wang", date: "July 8, 2024", rating: 4, comment: "Beautiful landscape shots. Great eye for detail.")
        ]
    )
    
    private static var mockAvailability: [Date] {
        let calendar = Calendar.current
        
        // Create dates in December 2025
        var dateComponents = DateComponents()
        dateComponents.year = 2025
        dateComponents.month = 12
        
        // Random available dates throughout December 2025: more natural pattern
        let availableDays = [2, 4, 6, 9, 11, 13, 15, 18, 20, 23, 25, 27, 29, 31]
        
        return availableDays.compactMap { day in
            dateComponents.day = day
            return calendar.date(from: dateComponents)
        }
    }
    
    private static let mockReviews: [PhotographerReview] = [
        .init(author: "Ethan Harper", date: "June 15, 2024", rating: 5, comment: "Sophia captured the essence of our event perfectly. Professional and creative."),
        .init(author: "Olivia Bennett", date: "May 20, 2024", rating: 4, comment: "Friendly, punctual, and delivered beautiful photos.")
    ]
}

struct PhotographerReview: Identifiable {
    let id = UUID()
    let author: String
    let date: String
    let rating: Int
    let comment: String
}

