//
//  OnboardingViewModel.swift
//  GluggApp
//
//  Created by Seun Olalekan on 2022-11-09.
//

import Foundation
import SwiftUI

class OnboardingViewModel {
    
     func setUser(name: String, goal: String){
        guard let goal = Int(goal) else {return}
        let currentUser = User(name: name, goal: goal)
        if let encoded = try? JSONEncoder().encode(currentUser){
            UserDefaults.standard.set(encoded, forKey: Constants.currentUser)
            UserDefaults.standard.set(true, forKey: Constants.onboardKey)
        }
    }
    
     func submit(name: String, goal:String, alert: inout Bool, isOnboarded: inout Bool){
        if name.isEmpty || goal.isEmpty {
            alert = true
        }
        else {
            setUser(name: name, goal: goal)
            withAnimation{
                isOnboarded = true
            }
        }
    }
    
}
