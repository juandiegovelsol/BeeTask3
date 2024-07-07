// AvailableDatePicker.swift
import SwiftUI

struct AvailableDatePicker: View {
    @Binding var selectedDate: Date
    let availableDates: Set<Date>
    let minDate: Date
    let maxDate: Date
    
    var body: some View {
        CustomCalendarView(selectedDate: $selectedDate, availableDates: availableDates, minDate: minDate, maxDate: maxDate)
    }
}
