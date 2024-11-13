//
//  NewScreen.swift
//  NewFirebaseProject
//
//  Created by AL11 on 18/04/24.
//

import Foundation
import SwiftUI
import Firebase
import Combine



struct NewScreen: View {
    @Binding var isLoggedIn: Bool
    @State private var selectedTab = 0
    @State private var isNavigationActive = false

    var body: some View {
        VStack {
            Spacer()
            // Slideshow of images
            ImageSlideshowView()
                .frame(height: 600)
            Spacer()

            NavigationLink(destination: SecondScreen(), isActive: $isNavigationActive) {
                EmptyView()
            }
            .hidden()

            HStack {
                NavigationLink(destination: OldPatientsList(), isActive: $isNavigationActive) {
                                Text("New Patients")
                                    .foregroundColor(Color.white)
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color(UIColor.systemTeal))
                                    .cornerRadius(10)
                            }
                            .padding()

                Button(action: {
                    // Action for New Patient
                    // Navigate to SecondScreen
                    self.isNavigationActive = true
                }) {
                    Text("Old Patient")
                        .foregroundColor(Color.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemTeal))
                        .cornerRadius(10)
                }
                .padding()


            }
        }
        .padding()
    }
}

struct ImageSlideshowView: View {
    let images: [String] = ["medicine1","doctor1","doctors2", "doctor2", "doctor3", "doctor5","doctors1"] // Add your image names
    @State private var currentIndex = 0
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(images.indices, id: \.self) { index in
                Image(images[index])
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .onReceive(timer) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % images.count
            }
        }
    }
}

