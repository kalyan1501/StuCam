import SwiftUI

struct PhotographerHomeView: View {
    let photographer: Photographer
    let todaysEvents: [BookingEvent]
    let activityItems: [ActivityItem]
    
    @State private var isAvailable = true
    @State private var showNotifications = false
    
    var body: some View {
            ScrollView {
                VStack(spacing: 24) {
                headerRow
                    availabilityCard
                quickActionsSection
                todaysEventsSection
                upcomingBookingsCard
                recentActivitySection
                statsSection
                }
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 32)
            }
            .background(Color(.systemGroupedBackground))
        .fullScreenCover(isPresented: $showNotifications) {
            NotificationView(role: .photographer)
        }
    }
    
    private var headerRow: some View {
        HStack(alignment: .center) {
            HStack(spacing: 12) {
                    Group {
                        if ["sharat", "p3", "lens", "sophia", "kalyan", "jessica"].contains(photographer.avatar.lowercased()) {
                            Image(photographer.avatar)
                                .resizable()
                                .scaledToFill()
                        } else {
                            Image(systemName: photographer.avatar)
                                .font(.title2)
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .background(Color(.systemOrange), in: Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hello, \(photographer.name.components(separatedBy: " ").first ?? "Alex")!")
                        .font(.largeTitle.bold())
                }
            }
            Spacer()
            Button {
                showNotifications = true
            } label: {
                Image(systemName: "bell")
                    .font(.title2)
                    .foregroundStyle(.primary)
            }
        }
    }
    
    private var availabilityCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Availability")
                .font(.headline)
            Text("You are available for new bookings.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Toggle(isOn: $isAvailable) {
                EmptyView()
            }
            .toggleStyle(SwitchToggleStyle(tint: .blue))
            .labelsHidden()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 20))
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
            
            HStack(spacing: 12) {
                QuickActionButton(icon: "square.and.arrow.up", title: "Upload Post") {
                    // Upload post action
                }
                QuickActionButton(icon: "calendar.badge.clock", title: "Update Availability") {
                    // Update availability action
                }
                QuickActionButton(icon: "pencil.and.outline", title: "Edit Portfolio") {
                    // Edit portfolio action
                }
                QuickActionButton(icon: "bubble.left.and.bubble.right", title: "Respond to Requests") {
                    // Respond to requests action
                }
            }
        }
    }
    
    private var todaysEventsSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Today's Events")
                        .font(.headline)
                Spacer()
                Button("View All") {}
                    .font(.subheadline)
                    .foregroundStyle(.blue)
            }
            
            ForEach(todaysEvents.prefix(2)) { event in
                EventCard(event: event)
            }
        }
    }
    
    private var upcomingBookingsCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("2 upcoming bookings this week")
                    .font(.subheadline.weight(.medium))
                Text("Stay on top of your schedule.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                // Navigate to calendar
            } label: {
                Text("View Calendar")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
        .background(Color.blue.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
    }
    
    private var recentActivitySection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Recent Activity")
                    .font(.headline)
                Spacer()
                Button("View All Notifications") {}
                    .font(.caption)
                    .foregroundStyle(.blue)
            }
            
            VStack(spacing: 12) {
                ForEach(activityItems.prefix(3)) { item in
                    PhotographerActivityRow(item: item)
                }
            }
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 20))
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Stats This Week")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                StatCard(title: "Bookings this month", value: "12", icon: nil)
                StatCard(title: "Profile views", value: "256", icon: nil)
                StatCard(title: "Likes on posts", value: "1,2k", icon: nil)
                StatCard(title: "Average rating", value: "4.9", icon: "star.fill")
            }
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 20))
    }
}

// MARK: - Quick Action Button
private struct QuickActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.blue)
                    .frame(width: 56, height: 56)
                    .background(.white, in: RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(height: 32, alignment: .top)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Stat Card
private struct StatCard: View {
    let title: String
    let value: String
    let icon: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 4) {
                Text(value)
                    .font(.title.bold())
                if let icon = icon {
                    Image(systemName: icon)
                .font(.headline)
                        .foregroundStyle(.yellow)
            }
        }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Event Card
struct EventCard: View {
    let event: BookingEvent
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(event.timeString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(event.title)
                    .font(.headline)
                Text(event.location)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color.green.opacity(0.3), Color.blue.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: event.icon)
                        .font(.title2)
                        .foregroundStyle(.secondary)
                )
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 20))
    }
}

// MARK: - Activity Row
struct PhotographerActivityRow: View {
    let item: ActivityItem
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: item.icon)
                .font(.headline)
                .foregroundStyle(item.color)
                .frame(width: 44, height: 44)
                .background(item.color.opacity(0.12), in: Circle())
            
            Text(item.title)
                .font(.subheadline)
                .lineLimit(2)
            
            Spacer()
        }
        .padding(12)
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 14))
    }
}
