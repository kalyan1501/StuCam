import SwiftUI

struct MessagingView: View {
    let threads: [MessageThread]
    @State private var selectedTab = 0
    
    private var bookingThreads: [MessageThread] {
        threads.filter { $0.type == .booking }
    }
    
    private var socialThreads: [MessageThread] {
        threads.filter { $0.type == .social }
    }
    
    private var displayedThreads: [MessageThread] {
        selectedTab == 0 ? bookingThreads : socialThreads
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Custom Header at top
                HStack {
                    Text("Messages")
                        .font(.largeTitle.bold())
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 12)
                .background(Color(.systemGroupedBackground))
                
                // Segmented Control
                Picker("", selection: $selectedTab) {
                    Text("Bookings").tag(0)
                    Text("Social").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 2)
                
                List {
                    ForEach(displayedThreads) { thread in
                        NavigationLink(value: thread) {
                            ThreadRow(thread: thread)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
            .navigationDestination(for: MessageThread.self) { thread in
                ChatDetailView(thread: thread)
                    .toolbar(.hidden, for: .tabBar)
            }
        }
    }
}

private struct ThreadRow: View {
    let thread: MessageThread
    
    private let imageAssets = ["sharat", "p3", "lens", "sophia", "kalyan", "jessica", "peram"]
    
    var body: some View {
        HStack(spacing: 16) {
            Group {
                if imageAssets.contains(thread.participantAvatar.lowercased()) {
                    Image(thread.participantAvatar)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: thread.participantAvatar)
                        .font(.system(size: 32))
                        .foregroundStyle(.white)
                }
            }
            .frame(width: 56, height: 56)
            .background(.blue)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(thread.participantName)
                    .font(.headline)
                Text(thread.title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(thread.lastMessagePreview)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct ChatDetailView: View {
    @State var thread: MessageThread
    @State private var newMessage = ""
    @State private var showProfile = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Header
            customHeader
            
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 16) {
                        // Date Header
                        Text(formattedDate)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(.systemGray6))
                            .clipShape(Capsule())
                            .padding(.top, 16)
                        
                        ForEach(thread.messages) { message in
                            ChatBubble(message: message, participantAvatar: thread.participantAvatar)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                .background(Color(.systemGroupedBackground))
                .onChange(of: thread.messages.count) {
                    withAnimation {
                        if let lastId = thread.messages.last?.id {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Message Composer
            messageComposer
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showProfile) {
            PhotographerPublicProfileView(photographer: getPhotographerForThread(thread))
        }
    }
    
    private func getPhotographerForThread(_ thread: MessageThread) -> Photographer {
        switch thread.participantName {
        case "Sharat Photography": return .sharatPhotography
        case "P3 Productions": return .p3Productions
        case "Peram Photography": return .peramPhotography
        case "Sophia Carter": return .mock
        case "Jessica Park": return .jessicaPark
        case "Lens & Light Studio": return .lensAndLight
        default: return .mock
        }
    }
    
    private let imageAssets = ["sharat", "p3", "lens", "sophia", "kalyan", "jessica", "peram"]
    
    private var customHeader: some View {
        HStack(spacing: 12) {
            // Back Button
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .frame(width: 40, height: 40)
            }
            
            // Avatar and Name - Clickable to open profile
            Button {
                showProfile = true
            } label: {
                HStack(spacing: 12) {
                    Group {
                        if imageAssets.contains(thread.participantAvatar.lowercased()) {
                            Image(thread.participantAvatar)
                                .resizable()
                                .scaledToFill()
                        } else {
                            Image(systemName: thread.participantAvatar)
                                .font(.title3)
                                .foregroundStyle(.blue)
                        }
                    }
                    .frame(width: 40, height: 40)
                    .background(Color.blue.opacity(0.2))
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(thread.participantName)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text("Active now")
                            .font(.caption)
                            .foregroundStyle(.green)
                    }
                }
            }
            
            Spacer()
            
            Button {
                // More options
            } label: {
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .frame(width: 40, height: 40)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }
    
    private var messageComposer: some View {
        HStack(spacing: 12) {
            // Message Input
            HStack(spacing: 8) {
                Button {
                    // Add attachment
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.blue)
                }
                
                TextField("Message", text: $newMessage, axis: .vertical)
                    .font(.body)
                    .lineLimit(1...4)
                
                if !newMessage.isEmpty {
                    Button {
                        newMessage = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // Send Button
            Button {
                sendMessage()
            } label: {
                Image(systemName: "arrow.up")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(newMessage.isEmpty ? Color.gray.opacity(0.3) : Color.blue)
                    )
            }
            .disabled(newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date())
    }
    
    private func sendMessage() {
        let trimmed = newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let message = Message(sender: .client, text: trimmed, timestamp: Date())
        thread.messages.append(message)
        newMessage = ""
    }
}

private struct ChatBubble: View {
    let message: Message
    let participantAvatar: String
    
    private let imageAssets = ["sharat", "p3", "lens", "sophia", "kalyan", "jessica", "peram"]
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.sender == .client { 
                Spacer(minLength: 60)
            }
            
            // Profile image for photographer messages
            if message.sender == .photographer {
                Group {
                    if imageAssets.contains(participantAvatar.lowercased()) {
                        Image(participantAvatar)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(systemName: participantAvatar)
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 32, height: 32)
                .background(.blue)
                .clipShape(Circle())
            }
            
            VStack(alignment: message.sender == .client ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .font(.body)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        message.sender == .client
                        ? Color.blue
                        : Color.white
                    )
                    .foregroundStyle(message.sender == .client ? .white : .primary)
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 20,
                            bottomLeadingRadius: message.sender == .client ? 20 : 4,
                            bottomTrailingRadius: message.sender == .photographer ? 20 : 4,
                            topTrailingRadius: 20
                        )
                    )
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                Text(formattedTime)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
            }
            
            if message.sender == .photographer { 
                Spacer(minLength: 60)
            }
        }
    }
    
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: message.timestamp)
    }
}

