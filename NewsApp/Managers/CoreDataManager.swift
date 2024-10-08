//
//  CoreDataManager.swift
//  NewsApp
//
//  Created by Abdrazak Manasov on 8/10/24.
//

import Foundation
import CoreData

protocol StorageManagerProtocol {
    func saveAllAricle(model: Article, compleation: @escaping (Result<Void, DataBaseError>) -> Void)
    func fetchArticles(compleation: @escaping (Result<[Article], DataBaseError>) -> Void)
    func deleteWith(model: ArticleModel, compleation: @escaping (Result<Void, DataBaseError>) -> Void)
    
}

//MARK: - For Error Handling
enum DataBaseError: Error {
    case failedToSaveData, failedToFetchDataFromDataBase, deleteDataFromCoreData
}

final class CoreDataManager: StorageManagerProtocol {
    
    // MARK: - Variables
    private let queue = DispatchQueue(label: "queue", attributes: .concurrent)
    
    // MARK: Core Data Stack
    private lazy var persistentContainer: NSPersistentContainer = { // persistent container
        let container = NSPersistentContainer(name: "ArticleModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: Core Data Saving Support
    private func saveContext() { // Context Manager
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as? NSError
                fatalError("Unresolved error \(error) <<<--- NSERROR")
            }
        }
    }
    
    // MARK: - ADDITION TO DATABASE
    func saveAllAricle(model: Article, compleation: @escaping (Result<Void, DataBaseError>) -> Void) {
        let context = persistentContainer.viewContext
        let item = ArticleModel(context: context)
        
    // MARK: - Readers and Writers Problem Resolving (Multi Threding)
        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            item.id = model.identifier
            item.title = model.title
            item.descript = model.description
            item.urlToImage = model.urlToImage
            item.content = model.content
        }
        
        do {
            try context.save()
            DispatchQueue.main.async { [weak self] in
                compleation(.success(()))
            }
            
        } catch {
            DispatchQueue.main.async { [weak self] in
                compleation(.failure(.failedToSaveData))
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - FETCH FROM DATABASE
    func fetchArticles(compleation: @escaping (Result<[Article], DataBaseError>) -> Void) {
        var articles = [Article]()
        
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<ArticleModel>
        request = ArticleModel.fetchRequest()
        
        do {
            let models = try context.fetch(request)
            for model in models {
                let article = Article(identifier: model.id ?? UUID().uuidString, title: model.title, description: model.descript, urlToImage: model.urlToImage, content: model.content)
                    queue.sync {
                    articles.append(article)
                    }
            }
            DispatchQueue.main.async { [weak self] in
                compleation(.success(articles))
            }
            
        } catch {
            DispatchQueue.main.async { [weak self] in
                compleation(.failure(.failedToFetchDataFromDataBase))
            }
        }
    }
    
    // MARK: - DELETION FROM DATABASE
    func deleteWith(model: ArticleModel, compleation: @escaping (Result<Void, DataBaseError>) -> Void) {
        let context = persistentContainer.viewContext
        context.delete(model)
        
        do {
            try context.save()
            DispatchQueue.main.async { [weak self] in
                compleation(.success(()))
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                compleation(.failure(.deleteDataFromCoreData))
            }
        }
    }
}


