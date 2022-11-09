//
//  HomeViewRepository.swift
//  GluggApp
//
//  Created by Seun Olalekan on 2022-11-08.
//

import Foundation
import CoreData
import SwiftUI

class HomeViewRepository {
    
    func addItem(context: NSManagedObjectContext){
        let newItem = WaterEntry(context: context)
        newItem.name = "Drank Water"
        newItem.date = Date()
        save(context: context)
        
    }
    
    func deleteItems(entry: WaterEntry, context: NSManagedObjectContext) {
        context.delete(entry)
        save(context: context)
    }
    
    private func save(context: NSManagedObjectContext){
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

}

