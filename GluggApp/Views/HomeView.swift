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
    @State private var isOnboarded = false
    
    @State private var waterProgress : CGFloat = 0
    @State private var timeleft = ""
    @State private var streak = UserDefaults.standard.integer(forKey: Constants.streak)
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WaterEntry.date, ascending: false)],
        animation: .default) private var items: FetchedResults<WaterEntry>
    
    var body: some View {
        ZStack{
                if !isOnboarded {
                    OnboardingView(isOnboarded: $isOnboarded)
                } else {
        
        
        GeometryReader{ proxy in
            
            
            VStack{
                
                let user = getUser()
                let name = user.name.components(separatedBy: .whitespaces).first
            
                VStack(alignment:.leading,spacing: 5){
                    Text("Hey there, \(name ?? "").").font(.system(.largeTitle, design: .rounded)).bold().frame(maxWidth:.infinity,alignment: .leading)
                    
                    Label {
                        Text("Streak: \(streak) days")
                    } icon: {
                        Text("🔥")
                    }
                    
                    Label {
                        Text(timeleft)
                    } icon: {
                        Text("⏰")
                    }
                    
                }.padding(.horizontal)
                
                WaterCompletionView(progress: $waterProgress).cornerRadius(30).padding().frame(height:proxy.size.height/2)
                    .overlay(alignment:.bottomTrailing){
                        
                        Button {
                            
                            if items.count < 8{
                                addItem()
                                waterProgress = CGFloat(items.count)/CGFloat(8)
                            }
                            
                        } label: {
                            Image(systemName: "plus").resizable().aspectRatio(contentMode: .fit).foregroundColor(.white)
                        }.frame(width:20,height: 20).background(Color.indigo).frame(width:50,height: 50).background(Color.indigo).clipShape(Circle())
                            .offset(x: -10)
                        
                    }
                    .overlay(alignment:.topTrailing) {
                        Text("\(items.count) \(items.count == 1 ? "Cup" : "Cups") Drank").font(.system(.title3, design: .rounded)).bold().foregroundColor(.white)
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
                setHours()
                checkDate()
                
                
            }
            .onReceive(timer) { _ in
               setHours()
            }
        
                }
        }.onAppear {
            isOnboarded = UserDefaults.standard.bool(forKey: Constants.onboardKey)
        }
        
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
    
    private func setHours(){
        let calendar = Calendar.autoupdatingCurrent
        let currentHour = calendar.component(.hour, from: Date())

        timeleft = "\(24-currentHour) hours left"

    }
    
    private func setStreak(){
        
            if items.count == 8{
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
                try viewContext.execute(delteReq)
                try viewContext.save()
    
            }catch{
                
            }
            
        }
    
    private func checkDate(){
        
        let previousDay = UserDefaults.standard.integer(forKey: Constants.currentDay)

        let calendar = Calendar.autoupdatingCurrent
        let day = calendar.component(.day, from: Date())
        
        if day > previousDay {
            setStreak()
            UserDefaults.standard.set(day, forKey: Constants.currentDay)
        }
        
        
    }
    
    private func getUser() -> User{
        if let data = UserDefaults.standard.object(forKey: Constants.currentUser) as? Data, let user = try? JSONDecoder().decode(User.self, from: data) {
            return user
        }
        return User(name: "", goal: 0)
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



