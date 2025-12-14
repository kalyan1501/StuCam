import SwiftUI

struct ClientProfileView: View {
    let onLogout: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Custom Header at top
                HStack {
                    Text("Profile")
                        .font(.largeTitle.bold())
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 12)
                .background(Color(.systemGroupedBackground))
                
                ScrollView {
                    VStack(spacing: 24) {
                        header
                        savedPhotographers
                        settings
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
            }
            .navigationBarHidden(true)
        }
    }
    
    private var header: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 90, height: 90)
                
                if let uiImage = UIImage(named: "kalyan ") ?? UIImage(named: "kalyan") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
                        .font(.title)
                        .foregroundStyle(.blue)
                }
            }
            .overlay(
                Circle()
                    .stroke(Color.blue.opacity(0.2), lineWidth: 2)
            )
            Text("Kalyan")
                .font(.title2.bold())
            Text("m.kalyankumar1512@gmail.com")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 28))
    }
    
    private var savedPhotographers: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Saved Photographers")
                .font(.headline)
            VStack(spacing: 12) {
                ForEach(0..<2) { index in
                    HStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 56, height: 56)
                            .overlay(Image(systemName: "person.crop.circle"))
                        VStack(alignment: .leading) {
                            Text(index == 0 ? "Sophia Carter" : "James Campbell")
                            Text("Portraits, Events")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button("View") {}
                    }
                    .padding()
                    .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 20))
                }
            }
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 28))
    }
    
    private var settings: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.headline)
            ForEach(SettingsOption.allCases, id: \.self) { option in
                Button {
                    // handle
                } label: {
                    HStack {
                        Label(option.title, systemImage: option.icon)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .foregroundStyle(.primary)
                }
                .padding()
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 16))
            }
            Button("Log Out") {
                onLogout()
            }
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 28))
    }
}

private enum SettingsOption: CaseIterable {
    case account
    case notifications
    case payment
    case support
    
    var title: String {
        switch self {
        case .account: return "Account Settings"
        case .notifications: return "Notifications"
        case .payment: return "Payment Methods"
        case .support: return "Support"
        }
    }
    
    var icon: String {
        switch self {
        case .account: return "person.circle"
        case .notifications: return "bell"
        case .payment: return "creditcard"
        case .support: return "questionmark.circle"
        }
    }
}

