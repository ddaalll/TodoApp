//
//  CoreDataManager.swift
//  TodoApp
//
//  Created by DalHyun Nam on 2023/04/05.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init () {}
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName: String = "MemoData"
    
    // MARK: - [Read] 읽어오기

    func getToDoListFromCoreData() -> [MemoData] {
        var toDoList: [MemoData] = []
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            let dateOrder = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [dateOrder]
            
            do {
                if let fetchedToDoList = try context.fetch(request) as? [MemoData] {
                    toDoList = fetchedToDoList
                }
            } catch {
                print("가져오는 것 실패")
            }
        }
            return toDoList
    }
    
    // MARK: - [Create]

    func saveToDoData(toDotext: String?, colorInt: Int64, completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                if let toDoData = NSManagedObject(entity: entity, insertInto: context) as? MemoData {
                    toDoData.memoText = toDotext
                    toDoData.date = Date()
                    toDoData.color = colorInt
                    
                    
                    //appDelegate?.saveContext() 앱델리게이트의 메서드로 해도 됨
                    
                    if context.hasChanges {
                        do {
                            try context.save()
                            completion()
                        } catch {
                            print(error.localizedDescription)
                            completion()
                        }
                    }
                }
            }
        }
        completion()
    }
    
    // MARK: - [Delete]

    func deleteToDo(data: MemoData, completion: @escaping () -> Void) {
        guard let date = data.date else {
            completion()
            return
            
        }
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
            
            do {
                if let fetchedToDoList = try context.fetch(request) as? [MemoData] {
                    if let targetToDo = fetchedToDoList.first {
                        context.delete(targetToDo)
                       
                        
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                            
                        }
                    }
                }
                completion()
            } catch {
                print("지우는 것 실패")
                completion()
            }
        }
        
    }
    // MARK: - [Update]

    func updateToDo(newToDoData: MemoData, completion: @escaping () -> Void) {
        guard let date = newToDoData.date else {
            completion()
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
            
            do {
                if let fetchedToDoList = try context.fetch(request) as? [MemoData] {
                    if var targetToDo = fetchedToDoList.first {
                        targetToDo = newToDoData
//                        appDelegate?.saveContext()
                        if context.hasChanges{
                            do{
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("지우는 것 실패")
                completion()
            }
        }
    }
}
