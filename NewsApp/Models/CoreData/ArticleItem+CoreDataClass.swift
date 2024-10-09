//
//  ArticleItem+CoreDataClass.swift
//  NewsApp
//
//  Created by Macbook on 9/10/24.
//
//

import Foundation
import CoreData

@objc(ArticleItem)
public class ArticleItem: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleItem> {
        return NSFetchRequest<ArticleItem>(entityName: "ArticleItem")
    }

    @NSManaged public var id: String?
    @NSManaged public var descript: String?
    @NSManaged public var content: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var title: String?
}
