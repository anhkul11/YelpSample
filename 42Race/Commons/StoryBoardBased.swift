//
//  StoryBoardBased.swift
//  42Race
//
//  Created by Anh Le on 15/01/2022.
//

import Foundation
import UIKit

protocol StoryboardInstantiable: AnyObject {
    
}

extension StoryboardInstantiable where Self: UIViewController {
    static func instantiateViewController() -> Self {
        let storyBoard = UIStoryboard(name: String(describing: Self.self), bundle: Bundle(for: Self.self))
        guard let vc = storyBoard.instantiateInitialViewController() as? Self else {
            fatalError()
        }
        return vc
    }
}
