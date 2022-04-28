//
//  ContentView.swift
//  VentilatoryThresholds WatchKit Extension
//
//  Created by Landon Pattison on 2/24/22.
//

import SwiftUI
import HealthKit

struct ContentView: View {
   
   @State private var vt1 : Int = 120
   @State private var vt2 : Int = 140
   
    var body: some View {
       NavigationView{
       
          VStack(){
             HStack{
                Text("VT1")
                   .foregroundColor(Color.white)
                   .multilineTextAlignment(.center)
                   .padding(.trailing)
                TextField("", value: $vt1, formatter: NumberFormatter())
                   .multilineTextAlignment(.trailing)
                   .padding(.leading)
             }
             HStack{
                Text("VT2")
                   .foregroundColor(Color.white)
                   .multilineTextAlignment(.leading)
                   .padding(.trailing)
                TextField("", value: $vt2, formatter: NumberFormatter())
                   .multilineTextAlignment(.trailing)
                   .padding(.leading)
             }
             NavigationLink(destination: ThreshView(vt1: self.$vt1, vt2: self.$vt2)) {
                Text("Start")
             }
          }
       }
    }
}

struct ThreshView: View {
    private let healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
    
    @State private var value = 0
    @Binding var vt1: Int
    @Binding var vt2: Int
   
   
    var body: some View {
        VStack{
            HStack{
               if (value < vt1){
                   Text("♥️")
                       .font(.system(size: 50))
                  Text("Below VT1")
                  Spacer()
               }
               if (value == vt1){
                   Text("♥️")
                       .font(.system(size: 50))
                  Text("Reached VT1")
                  Spacer()
               }
               
               if (value > vt1){
                   Text("♥️")
                       .font(.system(size: 50))
                  Text("Above VT1")
                  Spacer()
               }
               if (value == vt2){
                   Text("♥️")
                       .font(.system(size: 50))
                  Text("Reached VT2")
                  Spacer()
               }
               if (value > vt2){
                   Text("❤️")
                       .font(.system(size: 50))
                  Text("Above VT2")
                  Spacer()
               }

            }
            
            HStack{
                Text("\(value)")
                    .fontWeight(.regular)
                    .font(.system(size: 70))
                
                Text("BPM")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
                    .padding(.bottom, 28.0)
                
                Spacer()

            }

        }
        .padding()
        .onAppear(perform: start)
    }

    
    func start() {
        autorizeHealthKit()
        startHeartRateQuery(quantityTypeIdentifier: .heartRate)
    }
    
    func autorizeHealthKit() {
        let healthKitTypes: Set = [
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]

        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
    }
    
    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        
        
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in
            
        guard let samples = samples as? [HKQuantitySample] else {
            return
        }
            
        self.process(samples, type: quantityTypeIdentifier)

        }
        
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        
        query.updateHandler = updateHandler
        
        healthStore.execute(query)
    }
    
    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        var lastHeartRate = 0.0
        
        for sample in samples {
            if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
            }
            
            self.value = Int(lastHeartRate)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
