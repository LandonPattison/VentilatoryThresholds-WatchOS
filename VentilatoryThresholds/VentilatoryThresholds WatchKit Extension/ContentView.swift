//
//  ContentView.swift
//  VentilatoryThresholds WatchKit Extension
//
//  Created by Landon Pattison on 2/24/22.
//

import SwiftUI
import HealthKit

struct ContentView: View {
   
   @State var vt1 = "120"
   @State var vt2 = "140"
   
    var body: some View {
       NavigationView{
       
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
             NavigationLink(destination: ThreshView()) {
                Text("Start")
             }
          }
       }
    }
}

struct ThreshView: View {
    private var healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
    
    @State private var value = 120
    
    var body: some View {
        VStack{
            HStack{
               if (value < 120){
                   Text("❤️")
                       .font(.system(size: 50))
                  Text("Below VT1")
                  Spacer()
               }
               if (value == 120){
                   Text("❤️")
                       .font(.system(size: 50))
                  Text("Reached VT1")
                  Spacer()
               }
               
               if (value > 120){
                   Text("❤️")
                       .font(.system(size: 50))
                  Text("Above VT1")
                  Spacer()
               }
               if (value > 140){
                   Text("❤️")
                       .font(.system(size: 50))
                  Text("Reached VT2")
                  Spacer()
               }
               if (value > 140){
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
        
        // 1
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        // 2
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in
            
            // 3
        guard let samples = samples as? [HKQuantitySample] else {
            return
        }
            
        self.process(samples, type: quantityTypeIdentifier)

        }
        
        // 4
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        
        query.updateHandler = updateHandler
        
        // 5
        
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
        ThreshView()
    }
}
