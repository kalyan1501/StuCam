import Foundation

struct Message: Identifiable, Hashable {
    enum Sender {
        case client
        case photographer
    }
    
    let id = UUID()
    let sender: Sender
    let text: String
    let timestamp: Date
}

struct MessageThread: Identifiable, Hashable {
    enum ThreadType {
        case booking
        case social
    }
    
    let id = UUID()
    let participantName: String
    let participantAvatar: String
    let title: String
    let lastMessagePreview: String
    let type: ThreadType
    var messages: [Message]
    
    static let sampleThreads: [MessageThread] = [
        MessageThread(
            participantName: "Sharat Photography",
            participantAvatar: "sharat",
            title: "Wedding Shoot Details",
            lastMessagePreview: "I've confirmed the venue for Saturday!",
            type: .booking,
            messages: MessageThread.sampleConversation
        ),
        MessageThread(
            participantName: "P3 Productions",
            participantAvatar: "p3",
            title: "Portrait Session",
            lastMessagePreview: "What time works best for you on Friday?",
            type: .booking,
            messages: MessageThread.sampleConversation
        ),
        MessageThread(
            participantName: "Peram Photography",
            participantAvatar: "peram",
            title: "Brand Shoot Follow-up",
            lastMessagePreview: "The final edits are ready for review!",
            type: .booking,
            messages: MessageThread.sampleConversation
        ),
        MessageThread(
            participantName: "Sophia Carter",
            participantAvatar: "sophia",
            title: "Graduation Photoshoot",
            lastMessagePreview: "Looking forward to meeting you at Central Park!",
            type: .booking,
            messages: MessageThread.sampleConversation
        ),
        MessageThread(
            participantName: "Jessica Park",
            participantAvatar: "jessica",
            title: "Photography Tips",
            lastMessagePreview: "Thanks for the advice on lighting!",
            type: .social,
            messages: MessageThread.sampleConversation
        ),
        MessageThread(
            participantName: "Lens & Light Studio",
            participantAvatar: "lens",
            title: "Collaboration Ideas",
            lastMessagePreview: "Would love to work together on a project",
            type: .social,
            messages: MessageThread.sampleConversation
        )
    ]
    
    static func mock(for photographer: Photographer) -> MessageThread {
        MessageThread(
            participantName: photographer.name,
            participantAvatar: photographer.avatar,
            title: "New Booking Inquiry",
            lastMessagePreview: "Excited to chat about the shoot details!",
            type: .booking,
            messages: sampleConversation
        )
    }
    
    static var sampleConversation: [Message] {
        [
            Message(sender: .client, text: "Hi Sophia! I'm interested in booking you for a graduation shoot.", timestamp: Date().addingTimeInterval(-3600)),
            Message(sender: .photographer, text: "Hi! I'd love to help. When and where are you thinking?", timestamp: Date().addingTimeInterval(-3500)),
            Message(sender: .client, text: "June 15th, Central Park. Are you available at 3 PM?", timestamp: Date().addingTimeInterval(-3400)),
            Message(sender: .photographer, text: "Yes, that works perfectly!", timestamp: Date().addingTimeInterval(-3300))
        ]
    }
}

