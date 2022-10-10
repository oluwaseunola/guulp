//
//  ContentView.swift
//  GluggApp
//
//  Created by Seun Olalekan on 2022-10-06.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    private var isOnboarded : Bool {
        let isOnboarded = UserDefaults.standard.bool(forKey: Constants.onboardKey)
        
        return isOnboarded
    }
    
    @State private var waterProgress : CGFloat = 0
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WaterEntry.date, ascending: false)],
        animation: .default) private var items: FetchedResults<WaterEntry>
    
    var body: some View {
        
        //        if !isOnboarded {
        //            OnboardingView()
        //        } else {
        
        
        GeometryReader{ proxy in
            
            
            VStack{
                
                Text("Hey there, Seun.").font(.system(.largeTitle, design: .rounded)).bold().frame(maxWidth:.infinity,alignment: .leading).padding(.leading)
                
                WaterCompletionView(progress: $waterProgress).cornerRadius(30).padding().frame(height:proxy.size.height/2)
                    .overlay(alignment:.bottomTrailing){
                        
                        Button {
                            
                            addItem()
                            waterProgress = CGFloat(items.count)/CGFloat(8)
                            
                            
                        } label: {
                            Image(systemName: "plus").resizable().aspectRatio(contentMode: .fit).foregroundColor(.white)
                        }.frame(width:20,height: 20).background(Color.indigo).frame(width:50,height: 50).background(Color.indigo).clipShape(Circle())
                            .offset(x: -10)
                        
                    }
                    .overlay(alignment:.topTrailing) {
                        Text("\(items.count) Cups Drank").font(.system(.title3, design: .rounded)).bold().foregroundColor(.white)
                            .offset(x: -40, y: 30)
                    }
                
                
                
                if items.count != 0 {
                    
                    List{
                        ForEach(items){ item in
                            
                            
                            HStack{
                                Image(systemName: "drop.circle").resizable().aspectRatio(contentMode: .fit).frame(width:30, height:30).background(Color("onboard1")).foregroundColor(.white.opacity(0.8)).frame(width:50, height:50).background(Color("onboard1")).foregroundColor(.white.opacity(0.8)).mask(RoundedRectangle(cornerRadius: 10))
                                
                                VStack(alignment:.leading){
                                    Text(item.name ?? "").font(.system(.title, design: .rounded)).bold().foregroundColor(Color("onboard1"))
                                   
                                        
                                    Text(itemFormatter.string(from: item.date ?? Date())).font(.system(.caption, design: .rounded)).bold().foregroundColor(Color("onboard1").opacity(0.5))
                                    
                                    
                                }
                                
                            }.frame(height:100)
                            
                            
                            
                        }.onDelete(perform: deleteItems)
                    }.frame(height:proxy.size.height/2)}
                else{
                    Text("No entries today").frame(height:proxy.size.height/2)
                }
                
                Spacer()
            }}.onAppear {
                waterProgress = CGFloat(items.count)/CGFloat(8)
            }
        
        //        }
        
        
    }
    
    private func addItem() {
        withAnimation {
            let newItem = WaterEntry(context: viewContext)
            newItem.name = "Drank Water"
            newItem.date = Date()
            
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            waterProgress = CGFloat(items.count)/CGFloat(8)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



