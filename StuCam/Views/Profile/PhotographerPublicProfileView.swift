import SwiftUI

struct PhotographerPublicProfileView: View {
    let photographer: Photographer
    @Environment(\.dismiss) var dismiss
    @State private var selectedTab: ProfileTab = .portfolio
    @State private var isFollowing = false
    @State private var showAllPortfolio = false
    @State private var showBookingForm = false
    @State private var showChat = false
    @State private var selectedImageIndex: ImageIndex? = nil
    
    enum ProfileTab: String, CaseIterable {
        case portfolio = "Portfolio"
        case posts = "Posts"
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 0) {
                        // Cover Image
                        coverSection
                        
                        // Profile Avatar (overlapping cover and content)
                        ZStack(alignment: .top) {
                            // Profile Info
                            profileInfoSection
                                .padding(.top, 60) // Space for overlapping avatar
                            
                            // Profile Avatar centered and overlapping
                            VStack {
                                profileAvatar
                                    .offset(y: -60) // Overlap into cover section
                            }
                        }
                        
                        // Action Buttons (Follow, Message, Book Now)
                        actionButtonsSection
                        
                        // Stats
                        statsSection
                        
                        // Bio
                        bioSection
                        
                        // Tab Selector (Portfolio / Posts)
                        tabSelector
                        
                        // Content based on selected tab
                        if selectedTab == .portfolio {
                            portfolioSection
                        } else {
                            postsSection
                        }
                        
                        // Availability
                        availabilitySection
                        
                        // Reviews
                        reviewsSection
                    }
                }
                .navigationBarHidden(true)
                .background(Color(red: 0.95, green: 0.95, blue: 0.97))
                
                // Fixed Header Buttons
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                    
                    Spacer()
                    
                    Button {
                        // Share action
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                }
                .padding()
                .padding(.top, 8)
            }
            .navigationDestination(isPresented: $showChat) {
                ChatDetailView(thread: MessageThread.mock(for: photographer))
            }
            .fullScreenCover(item: $selectedImageIndex) { imageIndex in
                if let portfolioImages = photographer.portfolioImages {
                    ImageGalleryView(
                        images: portfolioImages,
                        startIndex: imageIndex.id,
                        isPresented: Binding(
                            get: { selectedImageIndex != nil },
                            set: { if !$0 { selectedImageIndex = nil } }
                        )
                    )
                }
            }
        }
    }
    
    private var coverSection: some View {
        ZStack(alignment: .bottom) {
            // Cover Image
            Group {
                if let coverImage = photographer.coverImage {
                    Image(coverImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    Rectangle()
                        .fill(photographer.headerColor)
                }
            }
            .frame(height: 180)
            .clipped()
        }
    }
    
    private var profileAvatar: some View {
        Group {
            if ["sharat", "p3", "lens", "sophia", "kalyan", "jessica"].contains(photographer.avatar.lowercased()) {
                Image(photographer.avatar)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: photographer.avatar)
                    .font(.system(size: 60))
            }
        }
        .frame(width: 120, height: 120)
        .background(Color.white)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color.white, lineWidth: 4)
        )
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
    }
    
    private var profileInfoSection: some View {
        VStack(spacing: 12) {
            // Name
            Text(photographer.name)
                .font(.title2.bold())
            
            // Specialties
            Text(photographer.specialties)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            // Location
            HStack(spacing: 4) {
                Image(systemName: "location.fill")
                    .font(.caption)
                Text(photographer.locationCity)
                    .font(.subheadline)
            }
            .foregroundStyle(.secondary)
        }
        .padding(.top, 8)
        .padding(.bottom)
    }
    
    private var actionButtonsSection: some View {
        HStack(spacing: 12) {
            // Follow Button
            Button {
                isFollowing.toggle()
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: isFollowing ? "checkmark" : "plus")
                        .font(.headline)
                    Text(isFollowing ? "Following" : "Follow")
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(isFollowing ? .blue : .white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isFollowing ? Color.white : Color.blue)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isFollowing ? Color.blue : Color.clear, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Message Button
            Button {
                showChat = true
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "message.fill")
                        .font(.headline)
                    Text("Message")
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(.blue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Book Now Button
            Button {
                showBookingForm = true
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.headline)
                    Text("Book")
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
        .fullScreenCover(isPresented: $showBookingForm) {
            BookingFormView(photographer: photographer)
        }
    }
    
    private var statsSection: some View {
        HStack(spacing: 0) {
            statItem(title: "Projects", value: "\(photographer.projectsCount)")
            
            Divider()
                .frame(height: 40)
            
            statItem(title: "Rating", value: String(format: "%.1f", photographer.rating))
            
            Divider()
                .frame(height: 40)
            
            statItem(title: "Reviews", value: "\(photographer.reviewsCount)")
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    private func statItem(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3.bold())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var bioSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About")
                .font(.headline)
            
            Text(photographer.bio)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineSpacing(4)
            
            // Rate
            HStack(spacing: 8) {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundStyle(.green)
                Text("Starting from \(photographer.rate)")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    private var availabilitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Availability")
                .font(.headline)
            
            // Calendar View
            VStack(spacing: 12) {
                // Month/Year Header
                HStack {
                    Text(currentMonthYear)
                        .font(.subheadline.weight(.semibold))
                    Spacer()
                }
                
                // Weekday Headers
                HStack(spacing: 0) {
                    ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // Calendar Grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 8) {
                    ForEach(calendarDays(), id: \.self) { day in
                        if day > 0 {
                            let isAvailable = isDayAvailable(day)
                            let isPastDay = isPast(day)
                            
                            Text("\(day)")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                                .frame(height: 36)
                                .background(
                                    isAvailable ? 
                                        Color.blue : 
                                        (isPastDay ? Color.gray.opacity(0.1) : Color.clear)
                                )
                                .foregroundStyle(
                                    isAvailable ? 
                                        .white : 
                                        (isPastDay ? .secondary : .primary)
                                )
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(
                                            isAvailable ? 
                                                Color.clear : 
                                                (isPastDay ? Color.clear : Color.gray.opacity(0.3)),
                                            lineWidth: 1
                                        )
                                )
                        } else {
                            Color.clear
                                .frame(height: 36)
                        }
                    }
                }
            }
            
            // Legend
            HStack(spacing: 16) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 12, height: 12)
                    Text("Available")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                HStack(spacing: 6) {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        .frame(width: 12, height: 12)
                    Text("Unavailable")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
        .padding(.top, 16)
        .padding(.bottom)
    }
    
    private var currentMonthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        // Show December 2025
        var components = DateComponents()
        components.year = 2025
        components.month = 12
        components.day = 1
        let december2025 = Calendar.current.date(from: components) ?? Date()
        return formatter.string(from: december2025)
    }
    
    private func calendarDays() -> [Int] {
        let calendar = Calendar.current
        
        // Use December 2025
        var components = DateComponents()
        components.year = 2025
        components.month = 12
        components.day = 1
        guard let december2025 = calendar.date(from: components) else { return [] }
        
        guard let monthInterval = calendar.dateInterval(of: .month, for: december2025),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }
        
        let daysInMonth = calendar.range(of: .day, in: .month, for: december2025)?.count ?? 31
        let firstWeekday = calendar.component(.weekday, from: monthInterval.start)
        
        var days: [Int] = []
        
        // Add empty spaces for days before month starts
        for _ in 1..<firstWeekday {
            days.append(0)
        }
        
        // Add actual days
        for day in 1...daysInMonth {
            days.append(day)
        }
        
        return days
    }
    
    private func isDayAvailable(_ day: Int) -> Bool {
        let calendar = Calendar.current
        
        // Create date for December 2025
        var components = DateComponents()
        components.year = 2025
        components.month = 12
        components.day = day
        
        guard let dayDate = calendar.date(from: components) else {
            return false
        }
        
        return photographer.availability.contains { availableDate in
            calendar.isDate(dayDate, inSameDayAs: availableDate)
        }
    }
    
    private func isPast(_ day: Int) -> Bool {
        let calendar = Calendar.current
        let today = Date()
        
        // Create date for December 2025
        var components = DateComponents()
        components.year = 2025
        components.month = 12
        components.day = day
        
        guard let dayDate = calendar.date(from: components) else {
            return false
        }
        
        return dayDate < calendar.startOfDay(for: today)
    }
    
    private var reviewsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Reviews")
                    .font(.headline)
                Spacer()
                Text("See All")
                    .font(.subheadline)
                    .foregroundStyle(.blue)
            }
            
            ForEach(photographer.reviews.prefix(2)) { review in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(review.author)
                            .font(.subheadline.weight(.semibold))
                        Spacer()
                        HStack(spacing: 2) {
                            ForEach(0..<review.rating, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                    .foregroundStyle(.yellow)
                            }
                        }
                    }
                    
                    Text(review.comment)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                    
                    Text(review.date)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    private func dayName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    private func dayNumber(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(ProfileTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 8) {
                        Text(tab.rawValue)
                            .font(.subheadline.weight(selectedTab == tab ? .semibold : .regular))
                            .foregroundStyle(selectedTab == tab ? .primary : .secondary)
                        
                        Rectangle()
                            .fill(selectedTab == tab ? Color.blue : Color.clear)
                            .frame(height: 2)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top)
        .background(.white)
    }
    
    private var portfolioSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Curated Work")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 8)
            ], spacing: 8) {
                if let portfolioImages = photographer.portfolioImages {
                    ForEach(0..<(showAllPortfolio ? portfolioImages.count : min(6, portfolioImages.count)), id: \.self) { index in
                        Button {
                            selectedImageIndex = ImageIndex(id: index)
                        } label: {
                            Image(portfolioImages[index])
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .aspectRatio(1, contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(Color.white, lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                } else {
                    ForEach(0..<(showAllPortfolio ? 12 : 6), id: \.self) { index in
                        Rectangle()
                            .fill(photographer.portfolioColors[index % photographer.portfolioColors.count])
                            .aspectRatio(1, contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(Color.white, lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal)
            
            // View All Text
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    showAllPortfolio.toggle()
                }
            } label: {
                HStack(spacing: 6) {
                    Text(showAllPortfolio ? "Show Less" : "View All")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                    Image(systemName: showAllPortfolio ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 12)
            }
        }
        .padding(.bottom, 16)
        .background(.white)
    }
    
    private var postsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Posts")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)
            
            LazyVStack(spacing: 24) {
                ForEach(0..<5, id: \.self) { index in
                    SocialPostCard(photographer: photographer, index: index)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
        .background(.white)
    }
}

private struct SocialPostCard: View {
    let photographer: Photographer
    let index: Int
    @State private var isLiked = false
    
    // Shuffled portfolio images for posts (without repeating) - deterministic per photographer
    private var shuffledPortfolioImages: [String] {
        guard let portfolioImages = photographer.portfolioImages, !portfolioImages.isEmpty else {
            return []
        }
        // Create a deterministic shuffle based on photographer name
        // This ensures consistent order per photographer but different for each
        var shuffled = portfolioImages
        let seed = abs(photographer.name.hashValue)
        // Simple deterministic shuffle using seed
        for i in 0..<shuffled.count {
            let j = (seed + i * 7) % shuffled.count
            shuffled.swapAt(i, j)
        }
        // For 5 posts, we'll use the first 5 shuffled images
        return Array(shuffled.prefix(5))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Large Post Image
            Group {
                if let portfolioImages = photographer.portfolioImages, !portfolioImages.isEmpty {
                    let shuffledImages = shuffledPortfolioImages
                    if index < shuffledImages.count {
                        Image(shuffledImages[index])
                            .resizable()
                            .scaledToFill()
                    } else {
                        Rectangle()
                            .fill(photographer.portfolioColors[index % photographer.portfolioColors.count])
                    }
                } else {
                    Rectangle()
                        .fill(photographer.portfolioColors[index % photographer.portfolioColors.count])
                }
            }
            .aspectRatio(1, contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // Action Buttons (Like, Comment, Share, Save)
            HStack {
                HStack(spacing: 16) {
                    // Like Button
                    Button {
                        isLiked.toggle()
                    } label: {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundStyle(isLiked ? .red : .primary)
                    }
                    
                    // Comment Button
                    Button {
                        // Comment action
                    } label: {
                        Image(systemName: "bubble.right")
                            .font(.title2)
                            .foregroundStyle(.primary)
                    }
                    
                    // Share Button
                    Button {
                        // Share action
                    } label: {
                        Image(systemName: "paperplane")
                            .font(.title2)
                            .foregroundStyle(.primary)
                    }
                }
                
                Spacer()
                
                // Save Button
                Button {
                    // Save action
                } label: {
                    Image(systemName: "bookmark")
                        .font(.title2)
                        .foregroundStyle(.primary)
                }
            }
            
            // Caption and Info
            VStack(alignment: .leading, spacing: 6) {
                // Time posted
                Text("Posted \(timeAgo(for: index)) ago")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                // Caption with hashtags
                Text("Amazing photoshoot session! 📸 Captured some incredible moments today. #Photography #Professional #\(photographer.specialties.replacingOccurrences(of: ", ", with: " #"))")
                    .font(.subheadline)
                    .lineSpacing(4)
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
    
    private func timeAgo(for index: Int) -> String {
        let times = ["2h", "5h", "1d", "2d", "3d"]
        return times[index % times.count]
    }
}

#Preview {
    PhotographerPublicProfileView(photographer: .mock)
}

