import SwiftUI

struct BookingEditView: View {
    let event: BookingEvent
    @Environment(\.dismiss) var dismiss
    
    @State private var eventName: String
    @State private var eventDate: Date
    @State private var startTime: Date
    @State private var endTime: Date
    @State private var location: String
    @State private var selectedEventType: String
    @State private var photoDeadline: Date
    @State private var specialRequests: String
    
    init(event: BookingEvent) {
        self.event = event
        _eventName = State(initialValue: event.title)
        _eventDate = State(initialValue: event.date)
        _startTime = State(initialValue: event.date)
        _endTime = State(initialValue: event.date.addingTimeInterval(4 * 3600))
        _location = State(initialValue: event.location)
        _selectedEventType = State(initialValue: "Graduation")
        _photoDeadline = State(initialValue: event.date.addingTimeInterval(15 * 24 * 3600))
        _specialRequests = State(initialValue: "")
    }
    
    let eventTypes = ["Graduation", "Wedding", "Portrait", "Event", "Fashion", "Product", "Lifestyle"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Event Name
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Event Name")
                            .font(.callout.weight(.medium))
                            .foregroundStyle(.primary)
                        
                        TextField("e.g. Graduation Photoshoot", text: $eventName)
                            .font(.body)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    // Date
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Date")
                            .font(.callout.weight(.medium))
                            .foregroundStyle(.primary)
                        
                        HStack {
                            DatePicker("", selection: $eventDate, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                            Spacer()
                        }
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    // Start Time & End Time
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Start Time")
                                .font(.callout.weight(.medium))
                                .foregroundStyle(.primary)
                            
                            HStack {
                                DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                Spacer()
                            }
                            .padding()
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("End Time")
                                .font(.callout.weight(.medium))
                                .foregroundStyle(.primary)
                            
                            HStack {
                                DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                Spacer()
                            }
                            .padding()
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    
                    // Location
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Location")
                            .font(.callout.weight(.medium))
                            .foregroundStyle(.primary)
                        
                        TextField("Enter address or place", text: $location)
                            .font(.body)
                            .textFieldStyle(CustomTextFieldStyle())
                        
                        Button {
                            // Use current location action
                            location = "Current Location"
                        } label: {
                            HStack {
                                Image(systemName: "location.fill")
                                    .font(.subheadline)
                                Text("Use Current Location")
                                    .font(.subheadline.weight(.medium))
                            }
                            .foregroundStyle(.blue)
                        }
                        .padding(.top, 4)
                    }
                    
                    // Event Type and Photo Delivery Date (Side by Side)
                    HStack(alignment: .top, spacing: 16) {
                        // Event Type
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Event Type")
                                .font(.callout.weight(.medium))
                                .foregroundStyle(.primary)
                            
                            Picker("", selection: $selectedEventType) {
                                ForEach(eventTypes, id: \.self) { type in
                                    Text(type).tag(type)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding()
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Photo Deadline
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Photo Delivery Date")
                                .font(.callout.weight(.medium))
                                .foregroundStyle(.primary)
                            
                            DatePicker("", selection: $photoDeadline, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // Special Requests
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Special Requests")
                            .font(.callout.weight(.medium))
                            .foregroundStyle(.primary)
                        
                        ZStack(alignment: .topLeading) {
                            if specialRequests.isEmpty {
                                Text("Any specific shots, locations, or details...")
                                    .font(.body)
                                    .foregroundStyle(.gray.opacity(0.6))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 12)
                            }
                            
                            TextEditor(text: $specialRequests)
                                .font(.body)
                                .frame(height: 120)
                                .padding(4)
                                .scrollContentBackground(.hidden)
                        }
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(20)
                .padding(.bottom, 100)
            }
            .background(Color(red: 0.95, green: 0.95, blue: 0.97))
            .navigationTitle("Edit Booking")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(.primary)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    // Save changes
                    dismiss()
                } label: {
                    Text("Save Changes")
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
    }
}

#Preview {
    BookingEditView(event: BookingEvent(
        title: "Downtown Graduation Photoshoot",
        clientName: "Kalyan",
        photographerName: "P3 Productions",
        date: Date(),
        location: "City Park, 123 Main St, Anytown",
        icon: "graduationcap.fill",
        status: .confirmed
    ))
}

