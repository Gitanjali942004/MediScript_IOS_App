//
//  SecondScreen.swift
//  NewFirebaseProject
//
//  Created by AL11 on 18/04/24.
//

import Foundation
import SwiftUI
import Firebase
import Combine

struct Patient: Identifiable, Codable {
    let id: String?
    var name: String
    var mobileNumber: String
    var age: Int
    var gender: String
    var problem: String
    
    init(id: String? = nil, name: String, mobileNumber: String, age: Int, gender: String, problem: String) {
        self.id = id
        self.name = name
        self.mobileNumber = mobileNumber
        self.age = age
        self.gender = gender
        self.problem = problem
    }
}

struct SecondScreen: View {
    @State private var patientName: String = ""
    @State private var mobileNumber: String = ""
    @State private var age: String = ""
    @State private var selectedGenderIndex = 0
    @State private var problem: String = ""
    @State private var showAlert = false
    @State private var isNavigationActive = true
    @State private var isLoggedIn: Bool = true

    let genderOptions = ["Male", "Female", "Other"]

    let db = Firestore.firestore()

    var body: some View {
        VStack {
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.top, 5)
                .foregroundColor(Color(UIColor.systemTeal))

            Text("Patient Details")
                .font(.title)
                .bold()
                .padding()
                .foregroundColor(Color(UIColor.systemTeal))

            TextField("Patient Name", text: $patientName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Mobile Number", text: $mobileNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            HStack {
                TextField("Age", text: $age)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .keyboardType(.numberPad)

                Picker(selection: $selectedGenderIndex, label: Text("Gender")) {
                    ForEach(0..<genderOptions.count) { index in
                        Text(self.genderOptions[index])
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
            }
            .onReceive(Just(age)) { newValue in
                let filtered = newValue.filter { "0123456789".contains($0) }
                if filtered != newValue {
                    self.age = filtered
                }
                if let ageValue = Int(filtered), !(1...99).contains(ageValue) {
                    self.age = ""
                }
            }

            TextField("Patient's Problem", text: $problem)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            NavigationLink(destination: MedicineDetails(id: nil, name: patientName, mobileNumber: mobileNumber, age: Int(age) ?? 0, gender: genderOptions[selectedGenderIndex], problem: problem), isActive: $isNavigationActive) {
                Text("Proceed")
                    .foregroundColor(Color.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemTeal))
                    .cornerRadius(10)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("Please fill out all fields."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .simultaneousGesture(TapGesture().onEnded {
                if allFieldsFilled() {
                    savePatientData()
                } else {
                    showAlert = true
                }
            })

            Spacer()

            Button(action: {
                do {
                    try Auth.auth().signOut()
                    isLoggedIn = false // Update the isLoggedIn state
                } catch let signOutError as NSError {
                    print("Error signing out: \(signOutError.localizedDescription)")
                }
            }) {
                Text("Logout")
            }
            .padding()

        }
    }

    func allFieldsFilled() -> Bool {
        return !patientName.isEmpty && !mobileNumber.isEmpty && !age.isEmpty && !problem.isEmpty
    }

    func savePatientData() {
        print("Saving patient data...")
        let patientData: [String: Any] = [
            "name": patientName,
            "mobileNumber": mobileNumber,
            "age": Int(age) ?? 0, // Convert age to Int
            "gender": genderOptions[selectedGenderIndex],
            "problem": problem
        ]
        print("Patient data: \(patientData)")
        db.collection("patients").addDocument(data: patientData) { error in
            if let error = error {
                print("Error adding patient: \(error.localizedDescription)")
            } else {
                print("Patient data added successfully")
                isNavigationActive = true // Navigate to the next screen after data insertion
            }
        }
    }


}

