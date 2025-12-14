import SwiftUI

struct DateSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedDates: Set<Date> = []
    @State private var currentMonth = Date()
    
    private let calendar = Calendar.current
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Month navigation
                HStack {
                    Button {
                        changeMonth(by: -1)
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.primary)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Text(monthYearString)
                        .font(.title2.bold())
                    
                    Spacer()
                    
                    Button {
                        changeMonth(by: 1)
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.primary)
                            .padding()
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                Divider()
                
                // Calendar grid
                VStack(spacing: 0) {
                    // Weekday headers
                    HStack(spacing: 0) {
                        ForEach(["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"], id: \.self) { day in
                            Text(day)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.vertical, 16)
                    
                    // Calendar dates
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 8) {
                        ForEach(daysInMonth(), id: \.self) { date in
                            if let date = date {
                                DateCell(
                                    date: date,
                                    isSelected: isDateSelected(date),
                                    isInRange: isDateInRange(date),
                                    isRangeStart: isRangeStart(date),
                                    isRangeEnd: isRangeEnd(date),
                                    isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
                                ) {
                                    toggleDate(date)
                                }
                            } else {
                                Color.clear
                                    .frame(height: 44)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .background(Color(.systemBackground))
            .navigationTitle("Select Dates")
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
                Button("Apply Dates") {
                    applyDates()
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue, in: RoundedRectangle(cornerRadius: 16))
                .padding()
                .background(.regularMaterial)
            }
        }
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private func daysInMonth() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }
        
        let startDate = monthFirstWeek.start
        var dates: [Date?] = []
        var currentDate = startDate
        
        // Generate 6 weeks worth of dates
        for _ in 0..<42 {
            if calendar.isDate(currentDate, equalTo: currentMonth, toGranularity: .month) {
                dates.append(currentDate)
            } else {
                dates.append(nil)
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return dates
    }
    
    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    private func isDateSelected(_ date: Date) -> Bool {
        selectedDates.contains { calendar.isDate($0, inSameDayAs: date) }
    }
    
    private func isDateInRange(_ date: Date) -> Bool {
        guard selectedDates.count >= 2 else { return false }
        let sortedDates = selectedDates.sorted()
        guard let first = sortedDates.first, let last = sortedDates.last else { return false }
        return date > first && date < last
    }
    
    private func isRangeStart(_ date: Date) -> Bool {
        guard let first = selectedDates.sorted().first else { return false }
        return calendar.isDate(date, inSameDayAs: first) && selectedDates.count > 1
    }
    
    private func isRangeEnd(_ date: Date) -> Bool {
        guard let last = selectedDates.sorted().last else { return false }
        return calendar.isDate(date, inSameDayAs: last) && selectedDates.count > 1
    }
    
    private func toggleDate(_ date: Date) {
        if let existingDate = selectedDates.first(where: { calendar.isDate($0, inSameDayAs: date) }) {
            selectedDates.remove(existingDate)
        } else {
            selectedDates.insert(date)
            
            // If we have more than 2 dates, keep only the first and this new one to create a range
            if selectedDates.count > 2 {
                let sorted = selectedDates.sorted()
                selectedDates = Set([sorted.first!, date])
            }
        }
    }
    
    private func applyDates() {
        // Apply selected dates logic here
        dismiss()
    }
}

struct DateCell: View {
    let date: Date
    let isSelected: Bool
    let isInRange: Bool
    let isRangeStart: Bool
    let isRangeEnd: Bool
    let isCurrentMonth: Bool
    let action: () -> Void
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Range background
                if isInRange {
                    Rectangle()
                        .fill(Color.blue.opacity(0.15))
                        .frame(height: 44)
                }
                
                // Date circle
                Text(dayNumber)
                    .font(.body)
                    .foregroundStyle(textColor)
                    .frame(width: 44, height: 44)
                    .background(backgroundColor)
                    .clipShape(Circle())
            }
        }
        .disabled(!isCurrentMonth)
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return .blue
        }
        return .clear
    }
    
    private var textColor: Color {
        if isSelected {
            return .white
        }
        if !isCurrentMonth {
            return Color.secondary.opacity(0.3)
        }
        if isInRange {
            return .blue
        }
        return .primary
    }
}

#Preview {
    DateSelectionView()
}

