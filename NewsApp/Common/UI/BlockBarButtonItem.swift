//
//  BlockBarButtonItem.swift
//  NewsApp
//
//  Created by Abdrazak Manasov on 7/10/24.
//

import UIKit

final class BlockBarButtonItem: UIBarButtonItem {

    private var handler: VoidClosure?
    
    static func item(title: String, style: UIBarButtonItem.Style, handler: @escaping VoidClosure) -> UIBarButtonItem {
        let result = BlockBarButtonItem(title: title, style: style, target: nil, action: nil)
        result.handler = handler
        result.action = #selector(onTap)
        return result
    }

    @objc
    private func onTap() {
        self.handler?()
    }
}
