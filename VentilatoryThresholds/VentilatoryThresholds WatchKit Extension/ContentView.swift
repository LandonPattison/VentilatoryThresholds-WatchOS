//
//  ContentView.swift
//  VentilatoryThresholds WatchKit Extension
//
//  Created by Landon Pattison on 2/24/22.
//

import SwiftUI

struct ContentView: View {
   
   @State var vt1 = "100"
   @State var vt2 = "140"
   
    var body: some View {
       
       VStack(){
          Button(action:{}){
             HStack{
                Text("VT1")
                   .foregroundColor(Color.gray)
                   .multilineTextAlignment(.leading)
                   .padding(.trailing)
                   
                Text(vt1)
                   .multilineTextAlignment(.trailing)
                   .padding(.leading)
             }
          }
          Button(action:{}){
             HStack{
                Text("VT2")
                   .foregroundColor(Color.gray)
                   .multilineTextAlignment(.leading)
                   .padding(.trailing)
                Text(vt2)
                   .multilineTextAlignment(.trailing)
                   .padding(.leading)
                
             }
          }
          Button("Start") {
             /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
          }
       }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
