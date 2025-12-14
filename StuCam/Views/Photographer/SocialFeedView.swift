import SwiftUI

struct SocialFeedView: View {
    let posts: [FeedPost]
    let role: UserRole
    @State private var searchText = ""
    @State private var showNotifications = false
    @State private var selectedFeedTab = 0
    @State private var showUploadPost = false
    
    private var filteredPosts: [FeedPost] {
        switch selectedFeedTab {
        case 0: // Following
            return posts.filter { $0.isFollowing }
        case 1: // Trending
            return posts.sorted { $0.likes > $1.likes }
        case 2: // Near You
            return posts.filter { $0.isNearby }
        default:
            return posts
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Custom Header at top
                HStack {
                    Text("Explore")
                        .font(.largeTitle.bold())
                    Spacer()
                    HStack(spacing: 16) {
                        if role == .photographer {
                            Button {
                                showUploadPost = true
                            } label: {
                                Image(systemName: "plus")
                                    .font(.title2)
                                    .foregroundStyle(.primary)
                            }
                        }
                        Button {
                            showNotifications = true
                        } label: {
                            Image(systemName: "bell")
                                .font(.title2)
                                .foregroundStyle(.primary)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 12)
                .background(Color(.systemGroupedBackground))
                
            ScrollView {
                VStack(spacing: 16) {
                        // Search Bar
                        HStack(spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "magnifyingglass")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                TextField("Search photographers or tags…", text: $searchText)
                                    .font(.subheadline)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(.thickMaterial)
                            .clipShape(Capsule())
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
                            
                            if !searchText.isEmpty {
                                Button {
                                    searchText = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title3)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 0)
                        
                        // Segmented Control
                        Picker("", selection: $selectedFeedTab) {
                        Text("Following").tag(0)
                            Text("Trending").tag(1)
                            Text("Near You").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                        ForEach(filteredPosts) { post in
                        FeedCard(post: post)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showNotifications) {
                NotificationView(role: role)
            }
            .fullScreenCover(isPresented: $showUploadPost) {
                UploadPostView()
            }
        }
    }
}

// MARK: - Upload Post View (Placeholder)
private struct UploadPostView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Upload Post")
                    .font(.largeTitle.bold())
                    .padding()
                
                Text("Post upload functionality coming soon!")
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

private struct FeedCard: View {
    let post: FeedPost
    @State private var isLiked = false
    @State private var isSaved = false
    @State private var showProfile = false
    
    // Map author names to their profile image assets
    private var profileImageName: String? {
        let authorLower = post.authorName.lowercased()
        if authorLower.contains("jessica") {
            return "jessica"
        } else if authorLower.contains("sharat") {
            return "sharat"
        } else if authorLower.contains("peram") {
            return "peram"
        } else if authorLower.contains("p3") {
            return "p3"
        } else if authorLower.contains("lens") || authorLower.contains("light") {
            return "lens"
        } else if authorLower.contains("sophia") {
            return "sophia"
        }
        return nil
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header - Author Info
            HStack(spacing: 12) {
                Button {
                    showProfile = true
                } label: {
                    HStack(spacing: 12) {
                        Group {
                            if let imageName = profileImageName {
                                Image(imageName)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(.blue)
                            }
                        }
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 2) {
                    Text(post.authorName)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary)
                    Text(post.handle)
                                .font(.caption)
                        .foregroundStyle(.secondary)
                        }
                    }
                }
                .buttonStyle(.plain)
                
                Spacer()
                Button {
                    // Follow action
                } label: {
                    Text("Follow")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Capsule())
            }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            // Large Image - Priority
            Group {
                if ["graduation", "couple", "tech", "potrait", "landscape", "fashion", "product", "downtown"].contains(post.imageName.lowercased()) {
                    Image(post.imageName)
                        .resizable()
                        .scaledToFill()
                } else {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            Image(systemName: post.imageName)
                                .font(.system(size: 80))
                                .foregroundStyle(.white.opacity(0.9))
                        )
                }
            }
            .frame(height: 400)
            .clipped()
            
            // Action Buttons
            HStack(spacing: 20) {
                Button {
                    isLiked.toggle()
                } label: {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.title3)
                        .foregroundStyle(isLiked ? .red : .primary)
                }
                
                Button {
                    // Comment action
                } label: {
                    Image(systemName: "bubble.left")
                        .font(.title3)
                        .foregroundStyle(.primary)
                }
                
                Button {
                    // Share action
                } label: {
                    Image(systemName: "paperplane")
                        .font(.title3)
                        .foregroundStyle(.primary)
                }
                
                Spacer()
                
                Button {
                    isSaved.toggle()
                } label: {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        .font(.title3)
                        .foregroundStyle(isSaved ? .blue : .primary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            // Engagement Stats
            VStack(alignment: .leading, spacing: 6) {
                if post.likes > 0 {
                    Text("\(post.likes) likes")
                        .font(.subheadline.weight(.semibold))
                }
                
                // Caption - Below author name
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.authorName)
                        .font(.caption.weight(.semibold))
                    Text(post.body)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                }
                
                if post.comments > 0 {
                    Text("View all \(post.comments) comments")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 2)
                }
                
                Text("2h ago")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            
            // Tags - Minimal
            if !post.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(post.tags, id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.caption2)
                                .foregroundStyle(.blue)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.08))
                                .clipShape(Capsule())
                }
            }
                    .padding(.horizontal, 16)
        }
                .padding(.bottom, 12)
            }
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal)
        .fullScreenCover(isPresented: $showProfile) {
            PhotographerPublicProfileView(photographer: getPhotographerForPost())
        }
    }
    
    // Helper function to get photographer for the post
    private func getPhotographerForPost() -> Photographer {
        // Map post author to photographer
        switch post.authorName {
        case "Jessica Park":
            return .jessicaPark
        case "Sharat Photography":
            return .sharatPhotography
        case "P3 Productions":
            return .p3Productions
        case "Peram Photography":
            return .peramPhotography
        case "Urban Shots":
            return .lensAndLight
        default:
            return .mock
        }
    }
}

