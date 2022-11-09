//
//  WaterCellView.swift
//  GluggApp
//
//  Created by Seun Olalekan on 2022-11-09.
//

import SwiftUI

struct WaterCellView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Binding var waterProgress : CGFloat
    var count : Int
    @ObservedObject var item : WaterEntry
    @ObservedObject var viewModel : HomeViewModel
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        
        HStack{
            
            Image(systemName: "drop.circle")
                .resizable().aspectRatio(contentMode: .fit)
                .frame(width:30, height:30)
                .background(Color("onboard1"))
                .foregroundColor(.white.opacity(0.8))
                .frame(width:50, height:50).background(Color("onboard1"))
                .foregroundColor(.white.opacity(0.8))
                .mask(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment:.leading){
                
                Text(item.name ?? "")
                    .font(.system(.title, design: .rounded)).bold()
                    .foregroundColor(Color("onboard1"))
                
                Text(itemFormatter.string(from: item.date ?? Date()))
                    .font(.system(.caption, design: .rounded)).bold()
                    .foregroundColor(Color("onboard1").opacity(0.5))
            }
            
        }.frame(height:100)
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    viewModel.deleteItems(entry: item, context: viewContext)
                    waterProgress = CGFloat(count)/CGFloat(8)
                } label: {
                    Label {
                        Text("Delete")
                    } icon: {
                        Image(systemName: "trash")
                    }
                }
            }

    }
}

