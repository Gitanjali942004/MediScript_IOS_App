import SwiftUI
import MessageUI

struct MedicineDetails: View {
    let id: String?
    let name: String
    let mobileNumber: String
    let age: Int
    let gender: String
    let problem: String
    
    @State private var medicineName: String = ""
    @State private var quantity: String = ""
    @State private var selectedTimeIndex = 0
    @State private var medicines: [String] = [] // Array to store medicines
    @State private var note: String = ""
    @State private var showAlert = false
    @State private var scrollToBottom = false
    @State private var isShowingMessageView = false

    
    let timeOptions = ["Morning", "Afternoon", "Evening", "Night", "Morning-Night", "Morning-Noon-Night"]
    
    init(id: String?, name: String, mobileNumber: String, age: Int, gender: String, problem: String) {
        self.id = id
        self.name = name
        self.mobileNumber = mobileNumber
        self.age = age
        self.gender = gender
        self.problem = problem
        
        // Print the values
        print("ID: \(id ?? "nil")")
        print("Name: \(name)")
        print("Mobile Number: \(mobileNumber)")
        print("Age: \(age)")
        print("Gender: \(gender)")
        print("Problem: \(problem)")
    }
    
    var body: some View {
        VStack {
            Image(systemName: "cross.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.top, 5)
                .foregroundColor(Color(UIColor.systemTeal))
            
            Text("Medicine Details")
                .font(.title)
                .bold()
                .padding()
                .foregroundColor(Color(UIColor.systemTeal))
            
            TextField("Medicine Name", text: $medicineName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                TextField("Quantity", text: $quantity)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Picker(selection: $selectedTimeIndex, label: Text("Time")) {
                    ForEach(0..<timeOptions.count) { index in
                        Text(self.timeOptions[index])
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
            }
            
            Button(action: {
                let selectedTime = self.timeOptions[selectedTimeIndex]
                let medicine = "\(medicineName) - \(quantity), \(selectedTime)"
                medicines.append(medicine)
                medicineName = ""
                quantity = ""
                scrollToBottom = true
            }) {
                Text("Add")
                    .foregroundColor(Color.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemTeal))
                    .cornerRadius(10)
            }
            .padding()
            
            
            
            ScrollView {
                ScrollViewReader { scrollView in
                    VStack(alignment: .leading) {
                        ForEach(medicines.indices, id: \.self) { index in
                            Text(medicines[index])
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .id(index)
                        }
                        .onChange(of: scrollToBottom) { newValue in
                            if newValue {
                                scrollView.scrollTo(medicines.count - 1)
                                scrollToBottom = false
                            }
                        }
                    }
                }
                .padding()
            }
            
            TextField("Note", text: $note)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                // Print all details to the console
                printPatientAndMedicineDetails()
                isShowingMessageView = true
            }) {
                Text("Send Prescription")
                    .foregroundColor(Color.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemTeal))
                    .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $isShowingMessageView) {
                MessageComposeView(isShowing: self.$isShowingMessageView, recipient: self.mobileNumber, messageBody: self.composeMessage())
            }
            
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text("Please fill out all fields."),
                dismissButton: .default(Text("OK"))
            )
        }
       
    }
    
    // Function to print all details to the console
    func printPatientAndMedicineDetails() {
        // Patient details
        var patientDetails = """
        Patient Details:
        Name: \(name)
        Mobile Number: \(mobileNumber)
        Age: \(age)
        Gender: \(gender)
        Problem: \(problem)
        """
        
        // Medicine details
        var medicineDetails = "\nMedicine Details:\n"
        for medicine in medicines {
            medicineDetails += "\(medicine)\n"
        }
        
        // Note
        let noteDetail = "\nNote: \(note)"
        
        // Concatenate all details
        let allDetails = patientDetails + medicineDetails + noteDetail
        
        // Print to console
        print(allDetails)
    }
    
    // Function to compose the message
    private func composeMessage() -> String {
        // Patient details
        var patientDetails = """
        Patient Details:
        Name: \(name)
        Mobile Number: \(mobileNumber)
        Age: \(age)
        Gender: \(gender)
        Problem: \(problem)
        """
        
        // Medicine details
        var medicineDetails = "\nMedicine Details:\n"
        for medicine in medicines {
            medicineDetails += "\(medicine)\n"
        }
        
        // Note
        let noteDetail = "\nNote: \(note)"
        
        // Concatenate all details
        let allDetails = patientDetails + medicineDetails + noteDetail
        
        return allDetails
    }
}

struct MessageComposeView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    let recipient: String
    let messageBody: String
    
    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = context.coordinator
        messageComposeVC.recipients = [recipient]
        messageComposeVC.body = messageBody
        return messageComposeVC
    }
    
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {
        // Nothing to do here
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isShowing: $isShowing)
    }
    
    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        @Binding var isShowing: Bool
        
        init(isShowing: Binding<Bool>) {
            _isShowing = isShowing
        }
        
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            isShowing = false
        }
    }
}
