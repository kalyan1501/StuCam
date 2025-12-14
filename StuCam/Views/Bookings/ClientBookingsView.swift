import SwiftUI

struct ClientBookingsView: View {
    let bookings: [BookingEvent]
    
    private var groupedBookings: [BookingEvent.Status: [BookingEvent]] {
        Dictionary(grouping: bookings, by: { $0.status })
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Custom Header at top
                HStack {
                    Text("Bookings")
                        .font(.largeTitle.bold())
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 12)
                .background(Color(.systemGroupedBackground))
                
                ScrollView {
                    VStack(spacing: 24) {
                        ForEach(BookingEvent.Status.allCases, id: \.self) { status in
                            if let events = groupedBookings[status], !events.isEmpty {
                                bookingsSection(title: status.title, events: events)
                            }
                        }
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
            }
            .navigationBarHidden(true)
        }
    }
    
    private func bookingsSection(title: String, events: [BookingEvent]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            ForEach(events) { event in
                ClientBookingCard(event: event)
            }
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 24))
    }
}

private struct ClientBookingCard: View {
    let event: BookingEvent
    @State private var showDetails = false
    @State private var showChat = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(event.title)
                    .font(.headline)
                Spacer()
                StatusPill(status: event.status)
            }
            Text("\(event.photographerName) • \(event.location)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            HStack {
                Label(event.timeString, systemImage: "clock")
                Spacer()
                Label(event.date.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            HStack(spacing: 12) {
                Button("Message") {
                    showChat = true
                }
                    .buttonStyle(OutlinedButtonStyle())
                Button("View Details") {
                    showDetails = true
                }
                .buttonStyle(FilledPrimaryButtonStyle())
            }
        }
        .padding()
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 20))
        .fullScreenCover(isPresented: $showDetails) {
            NavigationStack {
                BookingDetailsView(event: event)
            }
        }
        .sheet(isPresented: $showChat) {
            NavigationStack {
                ChatDetailView(thread: MessageThread(
                    participantName: event.photographerName,
                    participantAvatar: "camera.fill",
                    title: event.title,
                    lastMessagePreview: "Looking forward to the shoot!",
                    type: .booking,
                    messages: MessageThread.sampleConversation
                ))
            }
        }
    }
}

private struct StatusPill: View {
    let status: BookingEvent.Status
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(status.color)
                .frame(width: 8, height: 8)
            Text(status.title)
                .font(.caption.weight(.semibold))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(status.color.opacity(0.15))
        .clipShape(Capsule())
        .foregroundStyle(status.color)
    }
}

