//
//  CoreDataFakeContainer.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

#if canImport(CoreData)

import CoreData
import XCTest

extension XCTestCase {

    public static func memoryResidentPersistentContainer(containerName: String, modelName: String? = nil, bundle: Bundle = Bundle.main) -> NSPersistentContainer? {
        guard let modelURL = bundle.url(forResource: modelName ?? containerName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL)
            else { return nil }
        let container = NSPersistentContainer(name: containerName, managedObjectModel: model)
        let storeDescription = NSPersistentStoreDescription(url: URL(fileURLWithPath: "/dev/null"))
        container.persistentStoreDescriptions = [storeDescription]
        return container
    }
}

#endif
