import SwiftUI

// Wrapper for image index to conform to Identifiable
struct ImageIndex: Identifiable {
    let id: Int
}

struct PhotographerProfileView: View {
    let photographer: Photographer
    let onLogout: () -> Void
    @State private var selectedTab: ContentTab = .portfolio
    @State private var selectedSection: Section = .availability
    @State private var selectedImageIndex: ImageIndex? = nil
    
    enum ContentTab: String, CaseIterable {
        case portfolio = "Portfolio"
        case posts = "Posts"
    }
    
    enum Section: String, CaseIterable {
        case availability = "Availability"
        case reviews = "Reviews"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Custom Header at top
                HStack {
                    Text("Profile")
                        .font(.largeTitle.bold())
                    Spacer()
                    Menu {
                        Button {
                            // Edit Profile action
                        } label: {
                            Label("Edit Profile", systemImage: "pencil")
                        }
                        
                        Button {
                            // Manage Portfolio action
                        } label: {
                            Label("Manage Portfolio", systemImage: "photo.on.rectangle")
                        }
                        
                        Button {
                            // Manage Filters action
                        } label: {
                            Label("Manage Filters", systemImage: "slider.horizontal.3")
                        }
                        
                        Button {
                            // Payout Methods action
                        } label: {
                            Label("Payout Methods", systemImage: "creditcard")
                        }
                        
                        Button {
                            // Transaction History action
                        } label: {
                            Label("Transaction History", systemImage: "list.bullet.rectangle")
                        }
                        
                        Button {
                            // Settings action
                        } label: {
                            Label("Settings", systemImage: "gearshape")
                        }
                        
                        Button {
                            // Help Centre action
                        } label: {
                            Label("Help Centre", systemImage: "questionmark.circle")
                        }
                        
                        Divider()
                        
                        Button(role: .destructive) {
                            onLogout()
                        } label: {
                            Label("Logout", systemImage: "arrow.right.square")
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Circle()
                                .fill(Color.primary)
                                .frame(width: 4, height: 4)
                            Circle()
                                .fill(Color.primary)
                                .frame(width: 4, height: 4)
                            Circle()
                                .fill(Color.primary)
                                .frame(width: 4, height: 4)
                        }
                        .padding(8)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 12)
                .background(Color(.systemGroupedBackground))
                
                ScrollView {
                    VStack(spacing: 24) {
                        hero
                        portfolioPostsToggle
                        portfolioPostsContent
                        segmentedControl
                        sectionContent
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
            }
            .navigationBarHidden(true)
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
    
    private var hero: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .bottom) {
                Group {
                    if let coverImage = photographer.coverImage {
                        Image(coverImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        RoundedRectangle(cornerRadius: 32)
                            .fill(LinearGradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    }
                }
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 32))
                Circle()
                    .fill(.white)
                    .frame(width: 110, height: 110)
                    .overlay(
                        Group {
                            if ["sharat", "p3", "lens", "sophia", "kalyan", "jessica"].contains(photographer.avatar.lowercased()) {
                                Image(photographer.avatar)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Image(systemName: photographer.avatar)
                                    .font(.system(size: 50))
                                    .foregroundStyle(.blue)
                            }
                        }
                        .frame(width: 110, height: 110)
                        .clipShape(Circle())
                    )
                    .offset(y: 55)
            }
            .padding(.bottom, 55)
            
            VStack(spacing: 6) {
                Text(photographer.name)
                    .font(.title2.bold())
                Text(photographer.locationCity)
                    .foregroundStyle(.secondary)
                Text(photographer.bio)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            HStack(spacing: 24) {
                StatPill(title: "Projects", value: "\(photographer.projectsCount)+")
                StatPill(title: "Rating", value: String(format: "%.1f", photographer.rating))
                StatPill(title: "Rate", value: photographer.rate)
            }
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 32))
    }
    
    private var portfolioPostsToggle: some View {
        Picker("", selection: $selectedTab) {
            ForEach(ContentTab.allCases, id: \.self) { tab in
                Text(tab.rawValue).tag(tab)
            }
        }
        .pickerStyle(.segmented)
    }
    
    @ViewBuilder
    private var portfolioPostsContent: some View {
        switch selectedTab {
        case .portfolio:
            portfolioGrid
        case .posts:
            postsSection
        }
    }
    
    private var segmentedControl: some View {
        Picker("", selection: $selectedSection) {
            ForEach(Section.allCases, id: \.self) { section in
                Text(section.rawValue).tag(section)
            }
        }
        .pickerStyle(.segmented)
    }
    
    @ViewBuilder
    private var sectionContent: some View {
        switch selectedSection {
        case .availability:
            availabilityCalendar
        case .reviews:
            reviewsList
        }
    }
    
    private var portfolioGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Portfolio")
                .font(.headline)
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 12) {
                if let portfolioImages = photographer.portfolioImages {
                    ForEach(Array(portfolioImages.enumerated()), id: \.offset) { index, imageName in
                        Button {
                            selectedImageIndex = ImageIndex(id: index)
                        } label: {
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .aspectRatio(1, contentMode: .fill)
                                .frame(height: 160)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .buttonStyle(.plain)
                    }
                } else {
                    ForEach(Array(photographer.portfolioColors.enumerated()), id: \.offset) { _, color in
                        RoundedRectangle(cornerRadius: 20)
                            .fill(color)
                            .frame(height: 160)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.title)
                                    .foregroundStyle(.white.opacity(0.7))
                            )
                    }
                }
            }
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 28))
    }
    
    private var postsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Posts")
                .font(.headline)
            
            LazyVStack(spacing: 24) {
                ForEach(0..<5, id: \.self) { index in
                    SocialPostCard(photographer: photographer, index: index)
                }
            }
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 28))
    }
    
    private var availabilityCalendar: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Availability")
                .font(.headline)
            ProfileCalendarView(selectedDates: photographer.availability)
            Button("Update Availability") {}
                .buttonStyle(FilledPrimaryButtonStyle())
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 28))
    }
    
    private var reviewsList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Reviews")
                .font(.headline)
            ForEach(photographer.reviews) { review in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(review.author)
                            .font(.headline)
                        Spacer()
                        Text(review.date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    HStack(spacing: 2) {
                        ForEach(0..<5, id: \.self) { index in
                            Image(systemName: index < review.rating ? "star.fill" : "star")
                                .foregroundStyle(index < review.rating ? .yellow : .gray.opacity(0.4))
                        }
                    }
                    Text(review.comment)
                        .foregroundStyle(.secondary)
                }
                Divider()
            }
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 28))
    }
}

private struct StatPill: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 16))
    }
}

private struct ProfileCalendarView: View {
    let selectedDates: [Date]
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "chevron.left")
                Spacer()
                Text(monthTitle)
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
            }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                ForEach(calendarRange, id: \.self) { date in
                    Text(dayFormatter.string(from: date))
                        .frame(maxWidth: .infinity, minHeight: 32)
                        .padding(6)
                        .background(
                            selectedDates.contains(where: { calendar.isDate($0, inSameDayAs: date) }) ?
                            Circle().fill(Color.blue.opacity(0.2)) : nil
                        )
                        .foregroundStyle(
                            selectedDates.contains(where: { calendar.isDate($0, inSameDayAs: date) }) ?
                            Color.blue : Color.primary
                        )
                }
            }
        }
    }
    
    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: Date())
    }
    
    private var weekdays: [String] {
        ["S", "M", "T", "W", "T", "F", "S"]
    }
    
    private var calendarRange: [Date] {
        guard let interval = calendar.dateInterval(of: .month, for: Date()) else {
            return []
        }
        var dates: [Date] = []
        var date = interval.start
        while date < interval.end {
            dates.append(date)
            guard let next = calendar.date(byAdding: .day, value: 1, to: date) else { break }
            date = next
        }
        let weekday = calendar.component(.weekday, from: interval.start) - 1
        let paddingDates = (0..<weekday).compactMap {
            calendar.date(byAdding: .day, value: -($0 + 1), to: interval.start)
        }.reversed()
        return paddingDates + dates
    }
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
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

// MARK: - Image Gallery View
struct ImageGalleryView: View {
    let images: [String]
    let startIndex: Int
    @Binding var isPresented: Bool
    @State private var currentIndex: Int
    
    init(images: [String], startIndex: Int, isPresented: Binding<Bool>) {
        self.images = images
        self.startIndex = startIndex
        self._isPresented = isPresented
        self._currentIndex = State(initialValue: startIndex)
    }
    
    var body: some View {
        ZStack {
            // Blur background instead of black
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            
            // Image Carousel
            TabView(selection: $currentIndex) {
                ForEach(0..<images.count, id: \.self) { index in
                    Image(images[index])
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .id(startIndex) // Force TabView to recreate with correct starting index
            .onAppear {
                // Set the index immediately when view appears
                currentIndex = startIndex
            }
            
            // Close Button - Top Right
            VStack {
                HStack {
                    Spacer()
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundStyle(.primary)
                            .padding(12)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                    .padding()
                }
                Spacer()
            }
            
            // Image Counter
            VStack {
                Spacer()
                Text("\(currentIndex + 1) / \(images.count)")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(.bottom, 40)
            }
        }
    }
}

