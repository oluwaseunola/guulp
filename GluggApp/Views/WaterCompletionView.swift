//
//  WaterCompletionView.swift
//  GluggApp
//
//  Created by Seun Olalekan on 2022-10-09.
//

import SwiftUI

struct WaterCompletionView: View {
    
    @Binding var progress : CGFloat 
    @State var startAnimation : CGFloat = 0
    var body: some View {
        
       GeometryReader{ proxy in
           let size = proxy.size
           
           
           ZStack{
               Color("onboard2").opacity(0.2)
               
               
                   Image(systemName: "drop.fill").resizable().aspectRatio(contentMode: .fit)
                   .foregroundColor(.white)
                   .frame(width:size.width - 30,height: size.height - 30 )
                   .scaleEffect(x:1.1,y:1)
                   .offset(y:-1)
               
               WaterWave(progress: $progress, waveHeight: 0.08, offset: startAnimation).fill(.blue)
                   .overlay(content: {
                       
                       Circle().foregroundColor(.white.opacity(0.5)).frame(width:15,height: 15)
                           .offset(x: -20)
                       
                       Circle().foregroundColor(.white.opacity(0.5)).frame(width:25,height: 25)
                           .offset(x: 40, y: 30)
                       
                       Circle().foregroundColor(.white.opacity(0.5)).frame(width:25,height: 25)
                           .offset(x: 50, y: 70)
                       
                       Circle().foregroundColor(.white.opacity(0.5)).frame(width:15,height: 15)
                           .offset(x: -30, y: 80)
                       
                       Circle().foregroundColor(.white.opacity(0.5)).frame(width:10,height: 10)
                           .offset(x: 40, y: 100)
                       
                       
                       
                       
                   }).mask {
                   Image(systemName: "drop.fill").resizable().aspectRatio(contentMode: .fit)
                           .padding(20)
                   }.frame(width: size.width-30, height: size.height-30, alignment: .center)
                   

                
           }.onAppear {
               
               withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                   startAnimation = size.width
               }
           }
               
           
           
       }
    }
}

struct WaterCompletionView_Previews: PreviewProvider {
    static var previews: some View {
        WaterCompletionView(progress: .constant(0.5))
    }
}

struct WaterWave : Shape{
    
    @Binding var progress : CGFloat
    var waveHeight : CGFloat
    var offset : CGFloat
    
    var animatableData: CGFloat{
        get{offset}
        set{offset = newValue}
    }
    
    
    func path(in rect: CGRect) -> Path {
    
        return Path{ path in
            
            path.move(to: .zero)
            
            let progressHeight : CGFloat = (1-progress) * rect.height
            
            let height = waveHeight * rect.height
            
            for value in stride(from: 0, through: rect.width, by: 2){
                
                let x : CGFloat = value
                let sine : CGFloat = sin(Angle(degrees: value + offset).radians)
                let y : CGFloat = progressHeight + (height*sine)
                
                path.addLine(to: CGPoint(x: x, y: y))
                
            }
            
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            
        }
    }
    
    
    
    
}
