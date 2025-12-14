import SwiftUI

struct BookingConfirmationView: View {
    let photographer: Photographer
    let onDismissToHome: () -> Void
    @State private var showChat = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(red: 0.95, green: 0.95, blue: 0.97)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Success Icon
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.blue)
                
                // Title
                Text("Booking Request Sent!")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 24)
                
                // Subtitle
                VStack(spacing: 4) {
                    Text("Your request has been sent to \(photographer.name).")
                        .font(.body)
                        .foregroundStyle(.secondary)
                    Text("You'll be notified once they respond.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.top, 16)
                
                // Booking Summary Card
                bookingSummary
                    .padding(.horizontal, 20)
                    .padding(.top, 32)
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 16) {
                    Button {
                        showChat = true
                    } label: {
                        Text("Message \(photographer.name)")
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
                    
                    Button {
                        onDismissToHome()
                    } label: {
                        Text("Go to Home")
                            .font(.headline)
                            .foregroundStyle(.blue)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .interactiveDismissDisabled()
        .sheet(isPresented: $showChat) {
            NavigationStack {
                ChatDetailView(thread: MessageThread.mock(for: photographer))
            }
        }
    }
    
    private var bookingSummary: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Photographer Info
            HStack(spacing: 16) {
                Group {
                    if ["sharat", "p3", "lens", "sophia", "kalyan", "jessica"].contains(photographer.avatar.lowercased()) {
                        Image(photographer.avatar)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(systemName: photographer.avatar)
                            .font(.system(size: 48))
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 64, height: 64)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                VStack(alignment: .leading, spacing: 4) {
                    Text(photographer.name)
                        .font(.headline)
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill").foregroundStyle(.yellow)
                        Text(String(format: "%.1f", photographer.rating))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("(\(photographer.reviewsCount) reviews)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
            }
            
            Divider()
            
            // Booking Details
            VStack(alignment: .leading, spacing: 18) {
                SummaryRow(icon: "camera", title: "Graduation Photoshoot")
                SummaryRow(icon: "calendar", title: "June 15, 2024")
                SummaryRow(icon: "clock", title: "3:00 PM")
                SummaryRow(icon: "mappin.circle", title: photographer.locationDescription)
            }
        }
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 4)
    }
}

private struct SummaryRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 32, height: 32)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Text(title)
                .font(.body)
            Spacer()
        }
    }
}

#Preview {
    BookingConfirmationView(photographer: .mock, onDismissToHome: { })
}


