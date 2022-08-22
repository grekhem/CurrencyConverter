//
//  FavouriteAssembly.swift
//  CurrencyConverter
//
//  Created by Grekhem on 16.08.2022.
//

import Foundation
import UIKit

enum FavouriteAssembly {
    static func buildModule() -> UIViewController {
        let router = FavouriteRouter()
        let presenter = FavouritePresenter(router: router)
        let controller = FavouriteViewController(presenter: presenter)
        router.vc = controller
        return controller
    }
}
