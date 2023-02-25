//
//  NasaRoverDataController.swift
//  Assignment2
//
//  Created by Ankitgiri Gusai on 2023-02-22.
//
import CoreData
import Foundation

class NasaRoverDataController : ObservableObject {
    let container = NSPersistentContainer(name: "NasaImages")
    
    init(){
        container.loadPersistentStores{ desc, error in
            if let error = error {
                print("Core data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
}


//extension MarsAPIImage {
//    
//    static func create(
//        inContext ctx: NSManagedObjectContext
//    ) -> Self {
//        
//        let marsApiImageExample = self.init(context: ctx)
//    
//        marsApiImageExample.id = 12345
//        marsApiImageExample.rover = "Oppertunity"
//        marsApiImageExample.earth_date = .now
//        marsApiImageExample.url = "MIRI"
//        marsApiImageExample.camera = "MIRI"
//        
//        try? ctx.save()
//        return marsApiImageExample
//    }
//}
