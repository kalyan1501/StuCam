import SwiftUI

struct PhotographerCalendarView: View {
    let events: [BookingEvent]
    @State private var selectedDate = Date()
    
    var body: some View {
        ScrollView {
        VStack(spacing: 16) {
                MonthlyCalendar(selectedDate: $selectedDate, markedDates: events.map { $0.date })
                    .padding(.horizontal)
                bookingsList(for: selectedDate)
                    }
            .padding(.bottom)
                }
        .background(Color(.systemGroupedBackground))
    }
    
    private func bookingsList(for date: Date) -> some View {
        let dayEvents = events.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
        return VStack(alignment: .leading, spacing: 12) {
            Text("Bookings for \(formatted(date))")
                .font(.headline)
                .padding(.horizontal)
            if dayEvents.isEmpty {
                Text("No bookings yet.")
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            } else {
                ForEach(dayEvents) { event in
                    EventCard(event: event)
                }
            }
            Button {
                // future action
            } label: {
                Label("Add Availability", systemImage: "plus")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(colors: [.orange, .yellow], startPoint: .leading, endPoint: .trailing),
                        in: RoundedRectangle(cornerRadius: 24)
                    )
                    .foregroundStyle(.white)
                    .padding(.horizontal)
            }
        }
    }
    
    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter.string(from: date)
    }
}

private struct MonthlyCalendar: View {
    @Binding var selectedDate: Date
    let markedDates: [Date]
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button {
                    changeMonth(by: -1)
                } label: {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(monthTitle())
                    .font(.headline)
                Spacer()
                Button {
                    changeMonth(by: 1)
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                ForEach(["S","M","T","W","T","F","S"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                ForEach(daysInMonth(), id: \.self) { date in
                    VStack(spacing: 4) {
                        Text(dayNumber(for: date))
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background {
                                if calendar.isDate(date, inSameDayAs: selectedDate) {
                                    Circle().fill(Color.blue.opacity(0.2))
                                } else {
                                    Circle().fill(Color.clear)
                                }
                            }
                            .foregroundStyle(
                                calendar.isDate(date, inSameDayAs: selectedDate) ? Color.blue : Color.primary
                            )
                        if markedDates.contains(where: { calendar.isDate($0, inSameDayAs: date) }) {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 6, height: 6)
                        } else {
                            Circle()
                                .fill(Color.clear)
                                .frame(width: 6, height: 6)
                        }
                    }
                    .onTapGesture {
                        selectedDate = date
                    }
                }
            }
        }
    }
    
    private func monthTitle() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }
    
    private func dayNumber(for date: Date) -> String {
        let day = calendar.component(.day, from: date)
        return "\(day)"
    }
    
    private func daysInMonth() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate) else { return [] }
        var dates: [Date] = []
        var current = monthInterval.start
        while current < monthInterval.end {
            dates.append(current)
            guard let next = calendar.date(byAdding: .day, value: 1, to: current) else { break }
            current = next
        }
        let firstWeekday = calendar.component(.weekday, from: monthInterval.start) - 1
        let leading = (0..<firstWeekday).compactMap {
            calendar.date(byAdding: .day, value: -($0 + 1), to: monthInterval.start)
        }.reversed()
        return leading + dates
    }
    
    private func changeMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: selectedDate) {
            selectedDate = newDate
        }
    }
}

