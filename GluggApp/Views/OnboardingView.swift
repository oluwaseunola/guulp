//
//  OnboardingView.swift
//  GluggApp
//
//  Created by Seun Olalekan on 2022-10-06.
//

import SwiftUI

struct OnboardingView: View {
    let viewModel = OnboardingViewModel()
    @State private var name = ""
    @State private var goal = ""
    @State var presentAlert = false
    @Binding var isOnboarded : Bool
    var body: some View {
        
       GeometryReader{ proxy in
           
           ZStack{
           
           LinearGradient(gradient: Gradient(colors: [Color("onboard1"), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
           
           VStack{
               
               Image("logo")
                   .resizable()
                   .aspectRatio(contentMode: .fill)
                   .frame(width:300, height:300)
               
               Text("Let's get started.")
                   .font(.system(.title, design: .rounded))
                   .bold()
                   .foregroundColor(.white)
               
               VStack{
                
                   VStack(spacing:10){
                      
                       TextField("What is your name?", text: $name)
                           .frame(height:50)
                           .background(Color.white.opacity(0.7))
                           .cornerRadius(10)
                           .onSubmit { viewModel.submit(name: name, goal: goal, alert: &presentAlert, isOnboarded: &isOnboarded) }
                   
                       TextField("What is your goal? (glasses of water)", text: $goal)
                           .keyboardType(.numberPad)
                           .frame(height:50)
                           .background(Color.white.opacity(0.7))
                           .cornerRadius(10)
                           .onSubmit { viewModel.submit(name: name, goal: goal, alert: &presentAlert, isOnboarded: &isOnboarded) }
                       
                  }.padding()
                    .multilineTextAlignment(.center)
                    .frame(maxWidth:.infinity)
                   
                   Button {
                       viewModel.submit(name: name, goal: goal, alert: &presentAlert, isOnboarded: &isOnboarded)
                       
                   } label: {
                       Text("submit").foregroundColor(.white)
                   }
                   .frame(maxWidth:.infinity)
                   .frame(width: proxy.size.width/3 ,height:50)
                    .background(Color("onboard2"))
                    .mask(RoundedRectangle(cornerRadius: 10))
                    .alert("Invalid Field", isPresented: $presentAlert, actions: {
                           Button(role: .cancel) {} label: { Text("OK") }
                       }, message: {
                           Text("Make sure to fill out your name and water drinking goal.")
                       })
               }
               .frame(height: proxy.size.height/2.5)
                .background(Color.white.opacity(0.5))
                .cornerRadius(30)
                .padding()
               
               Spacer()
        }
           
       }.ignoresSafeArea(.all)}
    }
    
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isOnboarded: .constant(true))
    }
}
