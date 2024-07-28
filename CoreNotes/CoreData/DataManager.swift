//
//  DataManager.swift
//  CoreNotes
//


import Foundation
import CoreData

final class PersistenceController{
    
    //create a container
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    //initiliazes persistent container
    init(inMemory: Bool = false) {
        //NSPersistentContainer creates the persistent container and loads the CoreDataModel
        container = NSPersistentContainer(name: "CoreDataModel")
        
        //inMemory for temporary use of testing only. should stay false normally
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("unable to load data \(error)")
            }
        }
    }
    
    public func saveContext(backgroundContext: NSManagedObjectContext? = nil) throws{ // saves new information
        let context = backgroundContext ?? container.viewContext
        guard context.hasChanges else { return}
        try context.save()
    }
}
