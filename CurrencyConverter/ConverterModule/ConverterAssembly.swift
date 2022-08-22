//
//  ConverterAssembly.swift
//  CurrencyConverter
//
//  Created by Grekhem on 16.08.2022.
//

import Foundation
import UIKit

enum ConverterAssembly {
    static func buildModule(network: INetworkService) -> UIViewController {
        let router = ConverterRouter()
        let interactor = ConverterInteractor(network: network)
        let presenter = ConverterPresenter(interactor: interactor, router: router)
        let controller = ConverterViewController(presenter: presenter)
        router.vc = controller
        return controller
    }
}
