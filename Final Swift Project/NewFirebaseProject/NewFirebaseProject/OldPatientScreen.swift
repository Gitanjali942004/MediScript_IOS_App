import SwiftUI
import Firebase

struct OldPatientsList: View {
    @State private var patients: [Patient] = []
    let db = Firestore.firestore()

    var body: some View {
        List(patients) { patient in
            VStack(alignment: .leading) {
                Text(patient.name)
                    .font(.headline)
                Text("Age: \(patient.age)")
                Text("Gender: \(patient.gender)")
                Text("Problem: \(patient.problem)")
            }
        }
        .onAppear {
            fetchPatients()
        }
    }

    func fetchPatients() {
        db.collection("patients").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching patients: \(error.localizedDescription)")
                return
            }

            if let documents = snapshot?.documents {
                patients = documents.compactMap { document in
                    do {
                        let patientData = document.data()
                        let id = document.documentID
                        let name = patientData["name"] as? String ?? ""
                        let mobileNumber = patientData["mobileNumber"] as? String ?? ""
                        let age = patientData["age"] as? Int ?? 0
                        let gender = patientData["gender"] as? String ?? ""
                        let problem = patientData["problem"] as? String ?? ""

                        return Patient(id: id, name: name, mobileNumber: mobileNumber, age: age, gender: gender, problem: problem)
                    } catch {
                        print("Error decoding patient: \(error.localizedDescription)")
                        return nil
                    }
                }
            }
        }
    }
}

