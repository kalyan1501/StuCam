import SwiftUI

struct PhotographerBookingsView: View {
    let events: [BookingEvent]
    @State private var selectedTab = 0 // 0 = List, 1 = Calendar
    @State private var selectedEventForDetails: BookingEvent?
    @State private var selectedEventForChat: BookingEvent?
    @State private var showChat = false
    
    // Filter events by status
    private var newRequests: [BookingEvent] {
        events.filter { $0.status == .pending }
    }
    
    private var upcomingBookings: [BookingEvent] {
        events.filter { $0.status == .confirmed && $0.date > Date() }
    }
    
    private var completedBookings: [BookingEvent] {
        events.filter { $0.status == .completed }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Custom Header
                HStack {
                    Text("Bookings")
                        .font(.largeTitle.bold())
                    Spacer()
                    Button {
                        // Search action
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundStyle(.primary)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 12)
                .background(Color(.systemGroupedBackground))
                
                // Tab Navigation
                Picker("", selection: $selectedTab) {
                    Text("List").tag(0)
                    Text("Calendar").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom, 12)
                .background(Color(.systemGroupedBackground))
                
                if selectedTab == 0 {
                    listView
                } else {
                    PhotographerCalendarView(events: events)
                        .background(Color(.systemGroupedBackground))
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(item: $selectedEventForDetails) { event in
                NavigationStack {
                    BookingDetailsView(event: event, isPhotographerView: true)
                }
            }
            .sheet(isPresented: Binding(
                get: { showChat && selectedEventForChat != nil },
                set: { newValue in
                    showChat = newValue
                    if !newValue {
                        selectedEventForChat = nil
                    }
                }
            )) {
                if let event = selectedEventForChat {
                    NavigationStack {
                        ChatDetailView(thread: MessageThread(
                            participantName: event.clientName,
                            participantAvatar: "person.crop.circle",
                            title: event.title,
                            lastMessagePreview: "Looking forward to the shoot!",
                            type: .booking,
                            messages: MessageThread.sampleConversation
                        ))
                    }
                }
            }
            .onChange(of: selectedEventForChat) { oldValue, newValue in
                if newValue != nil {
                    showChat = true
                }
            }
        }
    }
    
    private var listView: some View {
        ScrollView {
            VStack(spacing: 24) {
                // New Requests Section
                if !newRequests.isEmpty {
                    newRequestsSection
                }
                
                // Upcoming Bookings Section
                if !upcomingBookings.isEmpty {
                    upcomingBookingsSection
                }
                
                // Completed Bookings Section
                if !completedBookings.isEmpty {
                    completedBookingsSection
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - New Requests Section
    private var newRequestsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("New Requests")
                    .font(.headline)
                Spacer()
                if newRequests.count > 0 {
                    Text("\(newRequests.count)")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red, in: Capsule())
                }
            }
            
            ForEach(newRequests) { request in
                NewRequestCard(request: request, onAccept: {
                    // Accept action
                }, onReject: {
                    // Reject action
                }, onDetails: {
                    selectedEventForDetails = request
                })
            }
            
            if newRequests.count > 2 {
                Button {
                    // View all requests
                } label: {
                    Text("View All")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
    
    // MARK: - Upcoming Bookings Section
    private var upcomingBookingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Upcoming Bookings")
                .font(.headline)
            
            ForEach(upcomingBookings) { booking in
                UpcomingBookingCard(booking: booking, onMessage: {
                    selectedEventForChat = booking
                }, onDetails: {
                    selectedEventForDetails = booking
                })
            }
        }
    }
    
    // MARK: - Completed Bookings Section
    private var completedBookingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Completed Bookings")
                .font(.headline)
            
            ForEach(completedBookings) { booking in
                CompletedBookingCard(booking: booking, onMessage: {
                    selectedEventForChat = booking
                }, onDetails: {
                    selectedEventForDetails = booking
                })
            }
        }
    }
}

// MARK: - New Request Card
private struct NewRequestCard: View {
    let request: BookingEvent
    let onAccept: () -> Void
    let onReject: () -> Void
    let onDetails: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                // Profile Picture
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.title2)
                            .foregroundStyle(.blue)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(request.clientName)
                        .font(.headline)
                    Text(formattedDateTime)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(request.title)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            
            // Action Buttons
            HStack(spacing: 12) {
                Button {
                    onReject()
                } label: {
                    Text("Reject")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 10))
                }
                
                Button {
                    onAccept()
                } label: {
                    Text("Accept")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                }
                
                Button {
                    onDetails()
                } label: {
                    Text("Details")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.blue, in: RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private var formattedDateTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        return formatter.string(from: request.date)
    }
}

// MARK: - Upcoming Booking Card
private struct UpcomingBookingCard: View {
    let booking: BookingEvent
    let onMessage: () -> Void
    let onDetails: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title with Status
            HStack(alignment: .center) {
                Text(booking.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
                StatusPill(status: booking.status)
            }
            
            // Client Name and Location
            Text("\(booking.clientName) • \(booking.location)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            // Time and Date
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text(booking.timeString)
                        .font(.caption)
                }
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption)
                    Text(formattedDate)
                        .font(.caption)
                }
            }
            .foregroundStyle(.secondary)
            
            // Action Buttons
            HStack(spacing: 12) {
                Button {
                    onMessage()
                } label: {
                    Text("Message")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1.5)
                        )
                }
                
                Button {
                    onDetails()
                } label: {
                    Text("View Details")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.blue, in: RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding(16)
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: booking.date)
    }
}

// MARK: - Status Pill
private struct StatusPill: View {
    let status: BookingEvent.Status
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(status.color)
                .frame(width: 8, height: 8)
            Text(status.title)
                .font(.caption.weight(.semibold))
        }
        .foregroundStyle(status.color)
    }
}

// MARK: - Completed Booking Card
private struct CompletedBookingCard: View {
    let booking: BookingEvent
    let onMessage: () -> Void
    let onDetails: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title with Status
            HStack(alignment: .center) {
                Text(booking.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
                StatusPill(status: booking.status)
            }
            
            // Client Name and Location
            Text("\(booking.clientName) • \(booking.location)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            // Time and Date
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text(booking.timeString)
                        .font(.caption)
                }
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption)
                    Text(formattedDate)
                        .font(.caption)
                }
            }
            .foregroundStyle(.secondary)
            
            // Action Buttons
            HStack(spacing: 12) {
                Button {
                    onMessage()
                } label: {
                    Text("Message")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1.5)
                        )
                }
                
                Button {
                    onDetails()
                } label: {
                    Text("View Details")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.blue, in: RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding(16)
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: booking.date)
    }
}
