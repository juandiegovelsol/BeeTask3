// CustomCalendarView.swift
import SwiftUI

struct CustomCalendarView: View {
    @Binding var selectedDate: Date
    let availableDates: Set<Date>
    let minDate: Date
    let maxDate: Date
    
    @State private var currentMonth: Date = Date()
    
    private let calendar = Calendar.current
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack {
            monthHeader
            daysHeader
            daysGrid
        }
    }
    
    private var monthHeader: some View {
        HStack {
            Text(monthYearString(from: currentMonth))
                .font(.headline)
        }
        .padding(.horizontal)
        .frame(height: 40)
    }
    
    private var daysHeader: some View {
        HStack {
            ForEach(daysOfWeek, id: \.self) { day in
                Text(day)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .font(.caption)
            }
        }
    }
    
    private var daysGrid: some View {
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)!.count
        let firstWeekday = calendar.component(.weekday, from: currentMonth)
        
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(1..<firstWeekday, id: \.self) { _ in
                Color.clear
            }
            ForEach(1...daysInMonth, id: \.self) { day in
                let date = calendar.date(from: DateComponents(year: calendar.component(.year, from: currentMonth),
                                                              month: calendar.component(.month, from: currentMonth),
                                                              day: day))!
                DayView(date: date, isSelected: calendar.isDate(selectedDate, inSameDayAs: date), isAvailable: availableDates.contains(date))
                    .onTapGesture {
                        if availableDates.contains(date) && date >= minDate && date <= maxDate {
                            selectedDate = date
                        }
                    }
            }
        }
    }
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct DayView: View {
    let date: Date
    let isSelected: Bool
    let isAvailable: Bool
    
    var body: some View {
        Text(dayString(from: date))
            .frame(height: 40)
            .frame(width: 40)
            .foregroundColor(isAvailable ? .primary : .gray)
            .background(isSelected ? Color.blue.opacity(0.3) : Color.clear)
            .clipShape(Circle())
    }
    
    private func dayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}
