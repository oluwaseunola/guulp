//
//  HomeViewModel.swift
//  GluggApp
//
//  Created by Seun Olalekan on 2022-11-08.
//

import Foundation
import CoreData
import SwiftUI

class HomeViewModel : ObservableObject {
    
    @Published var isOnboarded = false
    
    @Published var streak = UserDefaults.standard.integer(forKey: Constants.streak)
    
    private var repository : HomeViewRepository = HomeViewRepository()

    func addItem(context: NSManagedObjectContext) {
            repository.addItem(context: context)
    }
    
    func deleteItems(entry: WaterEntry, context: NSManagedObjectContext) {
        repository.deleteItems(entry: entry, context: context)
    }
    
    func setHours()-> Int{
        let calendar = Calendar.autoupdatingCurrent
        let currentHour = calendar.component(.hour, from: Date())
        return currentHour
    }
    
    func setStreak(items: Int, context: NSManagedObjectContext){
        if items == 8{
            var streak = UserDefaults.standard.integer(forKey: Constants.streak)
            streak += 1
            self.streak = streak
            UserDefaults.standard.set(streak, forKey: Constants.streak)
        }else{
            UserDefaults.standard.set(0, forKey: Constants.streak)
        }
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "WaterEntry")
        let delteReq = NSBatchDeleteRequest(fetchRequest: fetchReq)
        
        do {
            try context.execute(delteReq)
            try context.save()
            
        }catch{
            print(error)
        }
    }
    
    func checkDate(items: Int, context: NSManagedObjectContext){
        let previousDay = UserDefaults.standard.integer(forKey: Constants.currentDay)
        let calendar = Calendar.autoupdatingCurrent
        let day = calendar.component(.day, from: Date())
        
        if day > previousDay {
            setStreak(items: items, context: context)
            UserDefaults.standard.set(day, forKey: Constants.currentDay)
        }
    }
    
    func getUser() -> User{
        if let data = UserDefaults.standard.object(forKey: Constants.currentUser) as? Data, let user = try? JSONDecoder().decode(User.self, from: data) {
            return user
        }
        return User(name: "", goal: 0)
    }
    
}
