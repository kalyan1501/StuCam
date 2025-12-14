import SwiftUI
import MapKit

struct BookingReviewView: View {
    let photographer: Photographer
    let eventName: String
    let eventDate: Date
    let startTime: Date
    let endTime: Date
    let location: String
    let yourName: String
    let phoneNumber: String
    let eventType: String
    let photoDeadline: Date
    let specialRequests: String
    let onDismissAll: () -> Void
    
    @Environment(\.dismiss) var dismiss
    @State private var showConfirmation = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Event Details Card
                    eventDetailsCard
                    
                    // Location Card
                    locationCard
                    
                    // Client Details Card
                    clientDetailsCard
                    
                    // Job Details Card
                    jobDetailsCard
                    
                    // Payment Summary Card
                    paymentSummaryCard
                }
                .padding()
                .padding(.bottom, 100)
            }
            .background(Color(red: 0.95, green: 0.95, blue: 0.97))
            .navigationTitle("Review Booking")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundStyle(.primary)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    showConfirmation = true
                } label: {
                    Text("Confirm Booking")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.blue, Color.blue.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding()
                .background(.ultraThinMaterial)
            }
        }
        .fullScreenCover(isPresented: $showConfirmation) {
            BookingConfirmationView(photographer: photographer, onDismissToHome: {
                // Dismiss the review screen
                dismiss()
                // Then dismiss the form to go to home
                onDismissAll()
            })
        }
    }
    
    private var eventDetailsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(eventName)
                    .font(.title2.bold())
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "pencil")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(formattedEventDate)
                    .font(.body)
                    .foregroundStyle(.secondary)
                
                Text("\(formattedTime(startTime)) - \(formattedTime(endTime))")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var locationCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Location")
                    .font(.title3.bold())
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "pencil")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                }
            }
            
            Text(location.isEmpty ? "No location specified" : location)
                .font(.body)
                .foregroundStyle(.secondary)
            
            // Map Preview
            Map(initialPosition: .region(MKCoordinateRegion(
                center: photographer.location,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))) {
                Annotation("", coordinate: photographer.location) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.title)
                        .foregroundStyle(.red)
                }
            }
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .allowsHitTesting(false)
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var clientDetailsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Client Details")
                    .font(.title3.bold())
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "pencil")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                }
            }
            
            HStack(spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.gray.opacity(0.3))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(yourName.isEmpty ? "Your Name" : yourName)
                        .font(.body.weight(.semibold))
                    
                    Text(phoneNumber.isEmpty ? "Phone Number" : phoneNumber)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var jobDetailsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Job Details")
                    .font(.title3.bold())
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "pencil")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                }
            }
            
            VStack(alignment: .leading, spacing: 16) {
                DetailRow(
                    icon: "camera.fill",
                    iconColor: .blue.opacity(0.2),
                    title: "Event Type",
                    value: eventType
                )
                
                DetailRow(
                    icon: "clock.fill",
                    iconColor: .blue.opacity(0.2),
                    title: "Shooting Time",
                    value: calculateDuration()
                )
                
                DetailRow(
                    icon: "photo.fill",
                    iconColor: .blue.opacity(0.2),
                    title: "Photo Delivery",
                    value: "By \(formattedDeadline)"
                )
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var paymentSummaryCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Payment Summary")
                .font(.title3.bold())
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "creditcard.fill")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                            .background(Color.blue.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Text("Rate")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Text(photographer.rate)
                        .font(.body.weight(.semibold))
                }
                
                Divider()
                
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "dollarsign.circle.fill")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                            .background(Color.green.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Text("Total")
                            .font(.body.weight(.semibold))
                    }
                    
                    Spacer()
                    
                    Text(calculateTotal())
                        .font(.title3.bold())
                }
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // Helper functions
    private var formattedEventDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: eventDate)
    }
    
    private func formattedTime(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: time)
    }
    
    private var formattedDeadline: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: photoDeadline)
    }
    
    private func calculateDuration() -> String {
        let interval = endTime.timeIntervalSince(startTime)
        let hours = Int(interval / 3600)
        return "\(hours) Hour\(hours != 1 ? "s" : "")"
    }
    
    private func calculateTotal() -> String {
        let hours = Int(endTime.timeIntervalSince(startTime) / 3600)
        let rateDigits = photographer.rate.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let hourlyRate = Int(rateDigits) ?? 50
        let total = hourlyRate * max(hours, 1)
        return "$\(total)"
    }
}

struct DetailRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(.blue)
                .frame(width: 32, height: 32)
                .background(iconColor)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.body.weight(.semibold))
            }
            
            Spacer()
        }
    }
}

#Preview {
    BookingReviewView(
        photographer: .mock,
        eventName: "Downtown Graduation Photoshoot",
        eventDate: Date(),
        startTime: Date(),
        endTime: Date().addingTimeInterval(4 * 3600),
        location: "City Park, 123 Main St, Anytown",
        yourName: "Kalyan",
        phoneNumber: "+1(555) 123-4567",
        eventType: "Graduation",
        photoDeadline: Date().addingTimeInterval(15 * 24 * 3600),
        specialRequests: "",
        onDismissAll: { }
    )
}

