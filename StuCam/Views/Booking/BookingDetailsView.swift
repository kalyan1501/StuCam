import SwiftUI
import MapKit

struct BookingDetailsView: View {
    let event: BookingEvent
    let isPhotographerView: Bool // If true, hide edit/cancel buttons
    @Environment(\.dismiss) var dismiss
    @State private var showChat = false
    @State private var showEditForm = false
    
    init(event: BookingEvent, isPhotographerView: Bool = false) {
        self.event = event
        self.isPhotographerView = isPhotographerView
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Event Details Card
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(event.title)
                            .font(.title2.bold())
                        Spacer()
                        StatusPill(status: event.status)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "calendar")
                                .font(.subheadline)
                                .foregroundStyle(.blue)
                                .frame(width: 24)
                            Text(formattedDate)
                                .font(.body)
                        }
                        
                        HStack(spacing: 8) {
                            Image(systemName: "clock")
                                .font(.subheadline)
                                .foregroundStyle(.blue)
                                .frame(width: 24)
                            Text(event.timeString)
                                .font(.body)
                        }
                    }
                }
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Location Card
                VStack(alignment: .leading, spacing: 16) {
                    Text("Location")
                        .font(.headline)
                    
                    Text(event.location)
                        .font(.body)
                        .foregroundStyle(.secondary)
                    
                    // Map Preview
                    Map(initialPosition: .region(MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    ))) {
                        Annotation("", coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundStyle(.red)
                        }
                    }
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .allowsHitTesting(false)
                    
                    Button {
                        // Get directions
                    } label: {
                        HStack {
                            Image(systemName: "location.fill")
                            Text("Get Directions")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Your Details Card
                VStack(alignment: .leading, spacing: 16) {
                    Text("Your Details")
                        .font(.headline)
                    
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundStyle(.blue)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(event.clientName)
                                .font(.body.weight(.semibold))
                            Text("(555) 123-4567")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
                }
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Photographer Details Card
                VStack(alignment: .leading, spacing: 16) {
                    Text("Photographer Details")
                        .font(.headline)
                    
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.green.opacity(0.2))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "camera.fill")
                                    .foregroundStyle(.green)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(event.photographerName)
                                .font(.body.weight(.semibold))
                            Text("Photographer")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            showChat = true
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "message.fill")
                                Text("Message")
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(Capsule())
                        }
                    }
                }
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Job Details Card
                VStack(alignment: .leading, spacing: 16) {
                    Text("Job Details")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        DetailRow(
                            icon: "camera.fill",
                            iconColor: .blue.opacity(0.1),
                            title: "Event Type",
                            value: "Graduation"
                        )
                        
                        Divider()
                        
                        DetailRow(
                            icon: "clock.fill",
                            iconColor: .blue.opacity(0.1),
                            title: "Shooting Time",
                            value: "4 Hours"
                        )
                        
                        Divider()
                        
                        DetailRow(
                            icon: "photo.fill",
                            iconColor: .blue.opacity(0.1),
                            title: "Photo Delivery",
                            value: "By June 30, 2024"
                        )
                    }
                }
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Payment Card
                VStack(alignment: .leading, spacing: 16) {
                    Text("Payment")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        HStack {
                            HStack(spacing: 8) {
                                Image(systemName: "creditcard.fill")
                                    .foregroundStyle(.blue)
                                    .frame(width: 24)
                                Text("Upfront paid")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("$50")
                                .font(.body.weight(.semibold))
                        }
                        
                        Divider()
                        
                        HStack {
                            HStack(spacing: 8) {
                                Image(systemName: "dollarsign.circle.fill")
                                    .foregroundStyle(.orange)
                                    .frame(width: 24)
                                Text("Due")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("$150")
                                .font(.body.weight(.semibold))
                        }
                    }
                    
                    Button {
                        // View cancellation policy
                    } label: {
                        Text("View Cancellation Policy")
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }
                    .padding(.top, 8)
                }
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
            .padding(.bottom, 100)
        }
        .background(Color(red: 0.95, green: 0.95, blue: 0.97))
        .safeAreaInset(edge: .bottom) {
            if !isPhotographerView {
                HStack(spacing: 12) {
                    Button {
                        // Cancel booking
                    } label: {
                        Text("Cancel Booking")
                            .font(.headline)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.red, lineWidth: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    Button {
                        showEditForm = true
                    } label: {
                        Text("Edit Details")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
            }
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(.primary)
                }
            }
        }
        .fullScreenCover(isPresented: $showEditForm) {
            BookingEditView(event: event)
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
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: event.date)
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

#Preview {
    BookingDetailsView(event: BookingEvent(
        title: "Downtown Graduation Photoshoot",
        clientName: "Kalyan",
        photographerName: "Sharat Photography",
        date: Date(),
        location: "City Park, 123 Main St, Anytown",
        icon: "graduationcap.fill",
        status: .confirmed
    ))
}

