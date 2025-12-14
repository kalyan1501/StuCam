import SwiftUI

struct BookingFormView: View {
    let photographer: Photographer
    @Environment(\.dismiss) var dismiss
    
    @State private var eventName = ""
    @State private var eventDate = Date()
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var location = ""
    @State private var useCurrentLocation = false
    @State private var yourName = ""
    @State private var phoneNumber = ""
    @State private var selectedEventType = "Graduation"
    @State private var photoDeadline = Date()
    @State private var specialRequests = ""
    @State private var showReviewScreen = false
    
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
                        
                        HStack(spacing: 12) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title3)
                                .foregroundStyle(.gray)
                            TextField("Enter address or place", text: $location)
                                .font(.body)
                        }
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        Button {
                            useCurrentLocation.toggle()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "location.fill")
                                    .font(.subheadline)
                                Text("Use Current Location")
                                    .font(.subheadline.weight(.medium))
                            }
                            .foregroundStyle(.blue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue, lineWidth: 1.5)
                            )
                        }
                    }
                    
                    // Your Name & Phone Number
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Your Name")
                                .font(.callout.weight(.medium))
                                .foregroundStyle(.primary)
                            
                            TextField("Kalyan", text: $yourName)
                                .font(.body)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Phone Number")
                                .font(.callout.weight(.medium))
                                .foregroundStyle(.primary)
                            
                            TextField("(555) 123-4567", text: $phoneNumber)
                                .font(.body)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.phonePad)
                        }
                    }
                    
                    // Event Type & Photo Delivery Date
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Event Type")
                                .font(.callout.weight(.medium))
                                .foregroundStyle(.primary)
                            
                            Menu {
                                ForEach(eventTypes, id: \.self) { type in
                                    Button(type) {
                                        selectedEventType = type
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedEventType)
                                        .font(.body)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                }
                                .padding()
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Photo Delivery Date")
                                .font(.callout.weight(.medium))
                                .foregroundStyle(.primary)
                            
                            HStack {
                                DatePicker("", selection: $photoDeadline, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                Spacer()
                            }
                            .padding()
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    
                    // Special Requests
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Special Requests")
                            .font(.callout.weight(.medium))
                            .foregroundStyle(.primary)
                        
                        ZStack(alignment: .topLeading) {
                            if specialRequests.isEmpty {
                                Text("Any specific shots, locations, or details for the photographer...")
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
                .padding(.bottom, 100) // Space for Continue button
            }
            .background(Color(red: 0.95, green: 0.95, blue: 0.97))
            .navigationTitle("Event Details")
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
                    showReviewScreen = true
                } label: {
                    Text("Continue")
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
            .fullScreenCover(isPresented: $showReviewScreen) {
                BookingReviewView(
                    photographer: photographer,
                    eventName: eventName.isEmpty ? "Untitled Event" : eventName,
                    eventDate: eventDate,
                    startTime: startTime,
                    endTime: endTime,
                    location: location,
                    yourName: yourName,
                    phoneNumber: phoneNumber,
                    eventType: selectedEventType,
                    photoDeadline: photoDeadline,
                    specialRequests: specialRequests,
                    onDismissAll: { dismiss() }
                )
            }
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    BookingFormView(photographer: .mock)
}

