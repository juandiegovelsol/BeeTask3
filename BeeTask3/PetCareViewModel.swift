// PetCareViewModel.swift
import Foundation

class PetCareViewModel: ObservableObject {
    @Published var reservations: [Reservation] = []
    @Published var availableDates: Set<Date> = []
    
    private let maxPetsPerDay = 3
    
    init() {
        updateAvailableDates()
    }
    
    func makeReservation(ownerName: String, petName: String, phoneNumber: String, startDate: Date, endDate: Date) -> Bool {
        let datesInRange = getDatesInRange(from: startDate, to: endDate)
        
        guard Set(datesInRange).isSubset(of: availableDates) else {
            return false
        }
        
        let newReservation = Reservation(ownerName: ownerName, petName: petName, phoneNumber: phoneNumber, startDate: startDate, endDate: endDate)
        reservations.append(newReservation)
        updateAvailableDates()
        return true
    }
    
    private func updateAvailableDates() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let endDate = calendar.date(byAdding: .year, value: 1, to: today)!
        
        var currentDate = today
        var availableDates = Set<Date>()
        
        while calendar.compare(currentDate, to: endDate, toGranularity: .day) != .orderedDescending {
                let reservationsForDate = reservations.filter { reservation in
                    (calendar.compare(currentDate, to: reservation.startDate, toGranularity: .day) != .orderedAscending) &&
                    (calendar.compare(currentDate, to: reservation.endDate, toGranularity: .day) != .orderedDescending)
                }
                
                if reservationsForDate.count < maxPetsPerDay {
                    availableDates.insert(currentDate)
                }
                
                // Avanzar al siguiente día
                if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                    currentDate = nextDate
                } else {
                    break
                }
            }
        
        self.availableDates = availableDates
    }
    
    private func getDatesInRange(from startDate: Date, to endDate: Date) -> [Date] {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: startDate)
        let endDate = calendar.startOfDay(for: endDate)
        
        var dates: [Date] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
}
