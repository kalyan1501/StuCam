import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    @State private var priceRange: ClosedRange<Double> = 35...120
    @State private var availableNow = false
    @State private var selectedDates: Set<Date> = []
    @State private var selectedTimeSlot: TimeSlot? = .afternoon
    @State private var selectedTypes: Set<PhotographyType> = [.event, .graduation]
    @State private var locationText = ""
    @State private var distanceRadius: Double = 15
    @State private var selectedExperience: ExperienceLevel = .studentPhotographer
    @State private var showDatePicker = false
    
    enum TimeSlot: String, CaseIterable {
        case morning = "Morning"
        case afternoon = "Afternoon"
        case evening = "Evening"
    }
    
    enum PhotographyType: String, CaseIterable {
        case portrait = "Portrait"
        case event = "Event"
        case product = "Product"
        case fashion = "Fashion"
        case graduation = "Graduation"
        case lifestyle = "Lifestyle"
        case reelsShort = "Reels & Short Videos"
        case studioIndoor = "Studio / Indoor"
        case outdoor = "Outdoor"
    }
    
    enum ExperienceLevel: String, CaseIterable {
        case beginner = "Beginner"
        case studentPhotographer = "Student Photographer"
        case semiPro = "Semi-Pro"
        case professional = "Professional"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    priceSection
                    availabilitySection
                    photographyTypeSection
                    locationSection
                    experienceLevelSection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Filter Results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.primary)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                filterButtons
            }
        }
    }
    
    private var priceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Price Range (Per Hour)")
                .font(.headline)
            
            HStack {
                Text("$\(Int(priceRange.lowerBound))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("$\(Int(priceRange.upperBound))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            RangeSlider(range: $priceRange, bounds: 10...200)
        }
    }
    
    private var availabilitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Availability")
                .font(.headline)
            
            HStack {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.blue.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))
                Text("Available Now")
                    .font(.body)
                Spacer()
                Toggle("", isOn: $availableNow)
                    .labelsHidden()
            }
            
            Button {
                showDatePicker = true
            } label: {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.blue.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Select Dates")
                            .font(.body)
                            .foregroundStyle(.primary)
                        Text(selectedDates.isEmpty ? "Any Day" : "\(selectedDates.count) date(s) selected")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }
            }
            .sheet(isPresented: $showDatePicker) {
                DateSelectionView()
            }
            
            HStack(spacing: 12) {
                ForEach(TimeSlot.allCases, id: \.self) { slot in
                    Button {
                        selectedTimeSlot = slot
                    } label: {
                        Text(slot.rawValue)
                            .font(.subheadline)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(
                                selectedTimeSlot == slot
                                ? Color.blue.opacity(0.15)
                                : Color(.systemGray6)
                            )
                            .foregroundStyle(selectedTimeSlot == slot ? .blue : .primary)
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }
    
    private var photographyTypeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Photography Type")
                .font(.headline)
            
            FlowLayout(spacing: 12) {
                ForEach(PhotographyType.allCases, id: \.self) { type in
                    Button {
                        if selectedTypes.contains(type) {
                            selectedTypes.remove(type)
                        } else {
                            selectedTypes.insert(type)
                        }
                    } label: {
                        Text(type.rawValue)
                            .font(.subheadline)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(
                                selectedTypes.contains(type)
                                ? Color.blue.opacity(0.15)
                                : Color(.systemGray6)
                            )
                            .foregroundStyle(selectedTypes.contains(type) ? .blue : .primary)
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Location")
                .font(.headline)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Enter City or Zip Code", text: $locationText)
            }
            .padding()
            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
            
            HStack {
                Text("Within")
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(Int(distanceRadius)) miles")
                    .foregroundStyle(.blue)
                    .font(.subheadline.bold())
            }
            
            Slider(value: $distanceRadius, in: 1...50, step: 1)
                .tint(.blue)
        }
    }
    
    private var experienceLevelSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Experience Level")
                .font(.headline)
            
            FlowLayout(spacing: 12) {
                ForEach(ExperienceLevel.allCases, id: \.self) { level in
                    Button {
                        selectedExperience = level
                    } label: {
                        Text(level.rawValue)
                            .font(.subheadline)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(
                                selectedExperience == level
                                ? Color.blue.opacity(0.15)
                                : Color(.systemGray6)
                            )
                            .foregroundStyle(selectedExperience == level ? .blue : .primary)
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }
    
    private var filterButtons: some View {
        HStack(spacing: 12) {
            Button("Reset All") {
                resetFilters()
            }
            .font(.headline)
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 16))
            
            Button("Apply Filters") {
                applyFilters()
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue, in: RoundedRectangle(cornerRadius: 16))
        }
        .padding()
        .background(.regularMaterial)
    }
    
    private func resetFilters() {
        priceRange = 35...120
        availableNow = false
        selectedDates = []
        selectedTimeSlot = nil
        selectedTypes = []
        locationText = ""
        distanceRadius = 15
        selectedExperience = .studentPhotographer
    }
    
    private func applyFilters() {
        // Apply filter logic here
        dismiss()
    }
}

// Custom Range Slider
struct RangeSlider: View {
    @Binding var range: ClosedRange<Double>
    let bounds: ClosedRange<Double>
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(.systemGray5))
                    .frame(height: 4)
                
                // Active track (blue line between thumbs)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.blue)
                    .frame(width: activeWidth(in: geometry.size.width), height: 4)
                    .offset(x: activeTrackOffset(in: geometry.size.width))
                
                // Lower thumb
                Circle()
                    .fill(Color.blue)
                    .frame(width: 24, height: 24)
                    .offset(x: lowerThumbPosition(in: geometry.size.width))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                updateLowerBound(for: value.location.x, in: geometry.size.width)
                            }
                    )
                
                // Upper thumb
                Circle()
                    .fill(Color.blue)
                    .frame(width: 24, height: 24)
                    .offset(x: upperThumbPosition(in: geometry.size.width))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                updateUpperBound(for: value.location.x, in: geometry.size.width)
                            }
                    )
            }
            .frame(maxHeight: .infinity)
        }
        .frame(height: 24)
    }
    
    private func lowerThumbPosition(in width: CGFloat) -> CGFloat {
        let percentage = (range.lowerBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
        return percentage * width - 12
    }
    
    private func upperThumbPosition(in width: CGFloat) -> CGFloat {
        let percentage = (range.upperBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
        return percentage * width - 12
    }
    
    private func activeTrackOffset(in width: CGFloat) -> CGFloat {
        let lowerPercentage = (range.lowerBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
        return lowerPercentage * width
    }
    
    private func activeWidth(in width: CGFloat) -> CGFloat {
        let lowerPercentage = (range.lowerBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
        let upperPercentage = (range.upperBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
        return (upperPercentage - lowerPercentage) * width
    }
    
    private func updateLowerBound(for xPosition: CGFloat, in width: CGFloat) {
        let percentage = max(0, min(1, xPosition / width))
        let newValue = bounds.lowerBound + percentage * (bounds.upperBound - bounds.lowerBound)
        range = min(newValue, range.upperBound - 1)...range.upperBound
    }
    
    private func updateUpperBound(for xPosition: CGFloat, in width: CGFloat) {
        let percentage = max(0, min(1, xPosition / width))
        let newValue = bounds.lowerBound + percentage * (bounds.upperBound - bounds.lowerBound)
        range = range.lowerBound...max(newValue, range.lowerBound + 1)
    }
}

// Flow Layout for wrapping chips
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in width: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > width && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }
            
            self.size = CGSize(width: width, height: y + lineHeight)
        }
    }
}

#Preview {
    FilterView()
}

