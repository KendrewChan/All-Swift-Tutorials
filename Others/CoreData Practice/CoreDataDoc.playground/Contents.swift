//: Playground - noun: a place where people can play

import UIKit
import CoreData

//The Core Data stack handles all of the interactions with the external data stores so that your application can focus on its business logic

//Consists of four primary objects:
//1. the managed object context (NSManagedObjectContext),
//2. the persistent store coordinator (NSPersistentStoreCoordinator),
//3. the managed object model (NSManagedObjectModel),
//4. the persistent container (NSPersistentContainer)


//initialize the Core Data stack prior to accessing your application data to prepare Core Data for data requests and the creation of data
class DataController: NSObject {
    var managedObjectContext: NSManagedObjectContext
    init(completionClosure: @escaping () -> ()) {
        persistentContainer = NSPersistentContainer(name: "DataModel")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure()
        }
    } //creates a controller object that represents the persistence layer of the application (point 2. & 4. above)
}


//NSPersistentContainer
init(completionClosure: @escaping () -> ()) {
    //This resource is the same name as your xcdatamodeld contained in the project
    guard let modelURL = Bundle.main.url(forResource: "DataModel", withExtension: "momd") else {
        fatalError("Error loading model from bundle")
    }
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model
    guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
        fatalError("Error initializing mom from: \(modelURL)")
    }
    
    //The persistent store coordinator needs to know what the data schema of the application looks like, thus needing a managed object model
    let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
    
    managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType) //initalise the managed object context & keep reference to the persistent store coordinate
    NSManagedObjectContext.persistentStoreCoordinator = psc
    
    //The managed object context is used to create, read, update, and delete records
    //When the changes made in the managed object context are saved, the managed object context pushes them to the persistent store coordinator, which sends the changes to the corresponding persistent store.
    
    let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
    queue.async {
        guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Unable to resolve document directory")
        }
        let storeURL = docURL.appendingPathComponent("DataModel.sqlite")
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            //The callback block is expected to complete the User Interface and therefore should be presented back on the main queue so that the user interface does not need to be concerned with which queue this call is coming from
            DispatchQueue.main.sync(execute: completionClosure)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
}

