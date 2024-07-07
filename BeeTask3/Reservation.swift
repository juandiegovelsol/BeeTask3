// Reservation.swift
import Foundation

struct Reservation: Identifiable {
    let id = UUID()
    let ownerName: String
    let petName: String
    let phoneNumber: String
    let startDate: Date
    let endDate: Date
}
