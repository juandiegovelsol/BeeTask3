// ContentView.swift
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PetCareViewModel()
    @State private var ownerName = ""
    @State private var petName = ""
    @State private var phoneNumber = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Owner Information")) {
                    TextField("Owner Name", text: $ownerName)
                    TextField("Pet Name", text: $petName)
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }
                
                Section(header: Text("Reservation Dates")) {
                    AvailableDatePicker(selectedDate: $startDate, availableDates: viewModel.availableDates, minDate: Date(), maxDate: Date().addingTimeInterval(365*24*60*60))
                    AvailableDatePicker(selectedDate: $endDate, availableDates: viewModel.availableDates, minDate: startDate, maxDate: Date().addingTimeInterval(365*24*60*60))
                }
                
                Section {
                    Button("Make Reservation") {
                        if viewModel.makeReservation(ownerName: ownerName, petName: petName, phoneNumber: phoneNumber, startDate: startDate, endDate: endDate) {
                            alertMessage = "Reservation successful!"
                            resetForm()
                        } else {
                            alertMessage = "Unable to make reservation. Please check the dates."
                        }
                        showAlert = true
                    }
                }
                
                Section(header: Text("Reservations")) {
                    List(viewModel.reservations) { reservation in
                        VStack(alignment: .leading) {
                            Text("\(reservation.ownerName) - \(reservation.petName)")
                                .font(.headline)
                            Text("Phone: \(reservation.phoneNumber)")
                            Text("From: \(formattedDate(reservation.startDate))")
                            Text("To: \(formattedDate(reservation.endDate))")
                        }
                    }
                }
            }
            .navigationTitle("Pet Care Service")
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Reservation"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func resetForm() {
        ownerName = ""
        petName = ""
        phoneNumber = ""
        startDate = Date()
        endDate = Date()
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
