//
//  ArticleModel+CoreDataClass.swift
//  NewsApp
//
//  Created by Macbook on 8/10/24.
//
//

import Foundation
import CoreData

@objc(ArticleModel)
public class ArticleModel: NSManagedObject, Identifiable { 

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleModel> {
        return NSFetchRequest<ArticleModel>(entityName: "ArticleModel")
    }

    @NSManaged public var content: String?
    @NSManaged public var descript: String?
    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var urlToImage: String?
}
