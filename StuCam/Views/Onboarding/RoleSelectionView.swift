import SwiftUI

struct RoleSelectionView: View {
    typealias Action = (UserRole) -> Void
    
    let onSelection: Action
    
    var body: some View {
        ZStack {
            // Modern gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.98, green: 0.99, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                    .frame(height: 40)
                
                // Header Section
                VStack(alignment: .center, spacing: 16) {
                    Text("Welcome to")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack(alignment: .center, spacing: 8) {
                        Text("StuCam")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("A platform for photographers and the people who need them.")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 32)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 32)
                
                // Question Text
                Text("Are you a photographer or looking for one ?")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 24)
                
                // Role Cards Section
                VStack(alignment: .center, spacing: 16) {
                    RoleCard(
                        title: "I'm a photographer",
                        subtitle: "Showcase your work, manage bookings, grow your clients.",
                        imageName: "camera.fill",
                        gradientColors: [.blue, .cyan],
                        action: { onSelection(.photographer) }
                    )
                    
                    RoleCard(
                        title: "I'm looking for a photographer",
                        subtitle: "Discover nearby talent, compare portfolios, and book instantly.",
                        imageName: "person.2.crop.square.stack.fill",
                        gradientColors: [.purple, .pink],
                        action: { onSelection(.client) }
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                
                Spacer()
                
                // Login Button
                Button("Already have an account? Log in") {}
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.blue)
                    .padding(.bottom, 40)
            }
        }
    }
}

private struct RoleCard: View {
    let title: String
    let subtitle: String
    let imageName: String
    let gradientColors: [Color]
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                // Icon with gradient background
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 64, height: 64)
                        .shadow(color: gradientColors[0].opacity(0.3), radius: 12, x: 0, y: 6)
                    
                    Image(systemName: imageName)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(.white)
                }
                
                // Text Content
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(subtitle)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.secondary.opacity(0.6))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .frame(minHeight: 100)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.06), radius: 20, x: 0, y: 8)
            )
        }
        .buttonStyle(ModernButtonStyle())
    }
}

private struct ModernButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

