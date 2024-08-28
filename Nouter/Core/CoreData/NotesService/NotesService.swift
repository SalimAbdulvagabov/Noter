//
//  NotesService.swift
//  Nouter
//
//  Created by Рамазан Магомедов on 20.04.2021.
//  Copyright © 2021 Рамазан Магомедов. All rights reserved.
//

import Foundation
import CoreData

final class NotesService: CoreDataService {

    func saveNoute(_ noute: NouteModel) {
        do {
            deleteNoute(noute: noute)
            guard let nouteObject = noute.covertToNSManagedObject(context: persistentContainer.viewContext) else { return }
            var noutesObjects = try persistentContainer.viewContext.fetch(fetchRequest)
            noutesObjects.append(nouteObject)
            saveContext()
        } catch {
            let nserror = error as NSError
            assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    func deleteNoute(noute: NouteModel) {
        do {
            fetchRequest.predicate = NSPredicate(format: "\(NouteModel.CoreDataKeys.id) == %@", noute.id)
            guard let object = try persistentContainer.viewContext.fetch(fetchRequest).first else {
                return
            }
            persistentContainer.viewContext.delete(object)
            saveContext()
        } catch {
            let nserror = error as NSError
            assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    func getNoutes() -> [NouteModel] {
        do {
            fetchRequest.predicate = nil
            let noutesObjects = try persistentContainer.viewContext.fetch(fetchRequest)
            let noutes = noutesObjects
                .compactMap { NouteModel(object: $0) }
                .sorted { (first, second) -> Bool in
                    return first.date.timeIntervalSince1970 > second.date.timeIntervalSince1970
                }
            return noutes
        } catch {
            return []
        }
    }
}

private let entityName = "Noute"
private let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
