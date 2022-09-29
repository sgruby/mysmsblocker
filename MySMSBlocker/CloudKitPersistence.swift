//
//  Persistence.swift
//  MySMSBlocker
//
//  Created by Scott Gruby on 9/29/22.
//

import CoreData

struct CloudKitPersistenceController {
    static let shared = CloudKitPersistenceController()

    static var preview: CloudKitPersistenceController = {
        let result = CloudKitPersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Filter(context: viewContext)
            newItem.match = UUID().uuidString
            newItem.sender = Bool.random()
            newItem.allow = Bool.random()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false, readOnly: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "MySMSBlocker")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            let sharedStoreURL = URL.sharedStoreURL(for: "group.com.grubysolutions.mysmsblocker", databaseName: "MySMSBlockerData")
            let sharedStoreDescription = NSPersistentStoreDescription(url: sharedStoreURL)
            sharedStoreDescription.isReadOnly = readOnly
            sharedStoreDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.grubysolutions.mysmsblocker")
            container.persistentStoreDescriptions = [sharedStoreDescription]
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    #if DEBUG
        setup()
        #endif
    }
    
    func setup() {
#if DEBUG
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            do {
                    // Use the container to initialize the development schema.
                try self.container.initializeCloudKitSchema(options: [])
            } catch {
                    // Handle any errors.
                print(error)
            }
        }
#endif
    }
}
