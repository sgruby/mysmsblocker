//
//  URL+Extensions.swift
//  MySMSBlocker
//
//  Created by Scott Gruby on 9/29/22.
//

import Foundation

public extension URL {
    
        /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func sharedStoreURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }
        
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
