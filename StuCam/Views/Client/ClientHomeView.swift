import SwiftUI

struct ClientHomeView: View {
    let featuredPhotographers: [Photographer]
    let upcomingEvents: [BookingEvent]
    let activityItems: [ActivityItem]
    
    @State private var isAvailable = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerRow
                    availabilityCard
                    todaysEventsSection
                    recentActivitySection
                    featuredGrid
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var headerRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("StuCam")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Hello, Alex!")
                    .font(.largeTitle.bold())
            }
            Spacer()
            Image(systemName: "person.crop.circle.fill")
                .font(.title)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(.orange, in: Circle())
        }
    }
    
    private var availabilityCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Availability")
                .font(.headline)
            Text("Set your status to available to receive new bookings.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Toggle(isOn: $isAvailable) {
                EmptyView()
            }
            .labelsHidden()
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 20, x: 0, y: 10)
    }
    
    private var todaysEventsSection: some View {
        VStack(spacing: 12) {
            sectionHeader(title: "Upcoming Sessions", actionTitle: "View All")
            ForEach(upcomingEvents.prefix(2)) { event in
                ClientEventCard(event: event)
            }
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 20, x: 0, y: 10)
    }
    
    private var recentActivitySection: some View {
        VStack(spacing: 12) {
            Text("Recent Activity")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            ForEach(activityItems.prefix(3)) { item in
                ClientActivityRow(item: item)
            }
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 20, x: 0, y: 10)
    }
    
    private var featuredGrid: some View {
        VStack(spacing: 12) {
            sectionHeader(title: "Featured Photographers", actionTitle: "See More")
            ForEach(featuredPhotographers) { photographer in
                FeaturedPhotographerCard(photographer: photographer)
            }
        }
    }
    
    private func sectionHeader(title: String, actionTitle: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Button(actionTitle) {}
                .font(.subheadline.bold())
        }
    }
}

private struct ClientEventCard: View {
    let event: BookingEvent
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemGray5))
                .frame(width: 70, height: 70)
                .overlay(Image(systemName: event.icon).font(.title2))
            
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
        }
        .padding()
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 6)
    }
}

private struct ClientActivityRow: View {
    let item: ActivityItem
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: item.icon)
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(item.color.opacity(0.8), in: RoundedRectangle(cornerRadius: 14))
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

private struct FeaturedPhotographerCard: View {
    let photographer: Photographer
    @State private var showBookingForm = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                Group {
                    if ["sharat", "p3", "lens", "sophia", "kalyan", "jessica"].contains(photographer.avatar.lowercased()) {
                        Image(photographer.avatar)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(systemName: photographer.avatar)
                            .font(.system(size: 40))
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 64, height: 64)
                .background(.blue, in: RoundedRectangle(cornerRadius: 20))
                VStack(alignment: .leading, spacing: 4) {
                    Text(photographer.name)
                        .font(.headline)
                    Text(photographer.specialties)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill").foregroundStyle(.yellow)
                        Text("\(photographer.rating, specifier: "%.1f")")
                            .bold()
                    }
                    Text("\(photographer.reviewsCount) reviews")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Text(photographer.bio)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            HStack(spacing: 12) {
                Button("View Profile") {}
                    .buttonStyle(FilledPrimaryButtonStyle())
                Button("Book Now") {
                    showBookingForm = true
                }
                .buttonStyle(OutlinedButtonStyle())
            }
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 28))
        .shadow(color: .black.opacity(0.05), radius: 20, x: 0, y: 10)
        .fullScreenCover(isPresented: $showBookingForm) {
            BookingFormView(photographer: photographer)
        }
    }
}

