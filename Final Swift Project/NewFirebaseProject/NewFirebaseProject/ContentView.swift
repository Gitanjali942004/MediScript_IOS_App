import SwiftUI
import Firebase
import Combine


struct ContentView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSignUp: Bool = false
    @State private var errorMessage: String?
    @State private var isLoggedIn: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                ScrollView {
                    VStack {
                        Spacer().frame(height: 130)
                        VStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .foregroundColor(Color(UIColor.systemTeal))

                            Text(isSignUp ? "Sign Up" : "Login")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding()
                                .foregroundColor(Color(UIColor.systemTeal))

                            if isSignUp {
                                TextField("Name", text: $name)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                            }

                            TextField("Email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()

                            SecureField("Password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()

                            if let errorMessage = errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                            }

                            Button(action: {
                                if isSignUp {
                                    signUp()
                                } else {
                                    signIn()
                                }
                            }) {
                                Text(isSignUp ? "Sign Up" : "Sign In")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color(UIColor.systemTeal))
                                    .cornerRadius(8)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)

                            Button(action: {
                                isSignUp.toggle()
                            }) {
                                Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                                    .font(.footnote)
                                    .foregroundColor(Color(UIColor.systemTeal))
                                    .bold()
                                    .font(.title3)
                            }
                            .padding()

                            HStack {
                                Button(action: {
                                    // Action for Google login
                                }) {
                                    Image(systemName: "g.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(Color(UIColor.systemTeal))
                                }

                                Button(action: {
                                    // Action for Instagram login
                                }) {
                                    Image(systemName: "camera.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(Color(UIColor.systemTeal))
                                }

                                Button(action: {
                                    // Action for Facebook login
                                }) {
                                    Image(systemName: "f.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(Color(UIColor.systemTeal))
                                }
                            }

                            NavigationLink(destination: NewScreen(isLoggedIn: $isLoggedIn), isActive: $isLoggedIn) {
                                EmptyView()
                            }
                            .hidden()

                        }
                    }
                }
            }
        }
    }

    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                isLoggedIn = true
            }
        }
    }

    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                isLoggedIn = true
            }
        }
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

