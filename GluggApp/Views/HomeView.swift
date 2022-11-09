//
//  ContentView.swift
//  GluggApp
//
//  Created by Seun Olalekan on 2022-10-06.
//

import SwiftUI
import CoreData

struct HomeView: View {
   
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WaterEntry.date, ascending: false)],
        animation: .default) private var items: FetchedResults<WaterEntry>
    
    @StateObject var viewModel : HomeViewModel
    @State private var waterProgress : CGFloat = 0
    @State private var timeleft = ""
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack{
            
            if !viewModel.isOnboarded {
                OnboardingView(isOnboarded: $viewModel.isOnboarded)
            } else {
                
                GeometryReader{ proxy in
                    
                    VStack{
                        
                        let user = viewModel.getUser()
                        let name = user.name.components(separatedBy: .whitespaces).first
                        
                        VStack(alignment:.leading,spacing: 5){
                            
                            Text("Hey there, \(name ?? "").")
                                .font(.system(.largeTitle, design: .rounded))
                                .bold()
                                .frame(maxWidth:.infinity,alignment: .leading)
                            
                            Label {
                                Text("Streak: \(viewModel.streak) days")
                            } icon: {
                                Text("🔥")
                            }
                            
                            Label {
                                Text(timeleft)
                            } icon: {
                                Text("⏰")
                            }
                            
                        }.padding(.horizontal)
                        
                        WaterCompletionView(progress: $waterProgress)
                            .cornerRadius(30)
                            .padding()
                            .frame(height:proxy.size.height/2)
                            .overlay(alignment:.bottomTrailing){
                                
                                Button {
                                    if items.count < 8 {
                                        withAnimation{
                                            viewModel.addItem(context: viewContext)
                                        }
                                        waterProgress = CGFloat(items.count)/CGFloat(8)
                                    }
                                } label: {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.white)
                                }
                                .frame(width:20,height: 20)
                                .background(Color.indigo)
                                .frame(width:50,height: 50)
                                .background(Color.indigo)
                                .clipShape(Circle())
                                .offset(x: -10)
                                
                            }
                            .overlay(alignment:.topTrailing) {
                                Text("\(items.count) \(items.count == 1 ? "Cup" : "Cups") Drank")
                                    .font(.system(.title3, design: .rounded))
                                    .bold()
                                    .foregroundColor(.white)
                                    .offset(x: -40, y: 30)
                            }
                        
                        if items.count != 0 {
                            
                            List(items){ item in
                                    WaterCellView(waterProgress: $waterProgress, count: items.count, item: item, viewModel: viewModel)
                                        .environment(\.managedObjectContext, viewContext)
                                
                            }.frame(height:proxy.size.height/2)
                            
                        }
                        else{
                            Text("No entries today")
                                .frame(height:proxy.size.height/2)
                        }
                        
                        Spacer()
                    }}.onAppear {
                        waterProgress = CGFloat(items.count)/CGFloat(8)
                        let currentHour = viewModel.setHours()
                        timeleft = "\(24-currentHour) hours left"
                    }
                    .onReceive(timer) { _ in
                        let currentHour = viewModel.setHours()
                        timeleft = "\(24-currentHour) hours left"
                    }
                
            }
        }.onAppear {
            viewModel.checkDate(items: items.count, context: viewContext)
            viewModel.isOnboarded = UserDefaults.standard.bool(forKey: Constants.onboardKey)
        }
        
    }
    
}






