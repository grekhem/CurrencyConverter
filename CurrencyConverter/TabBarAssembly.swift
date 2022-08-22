//
//  TabBarAssembly.swift
//  CurrencyConverter
//
//  Created by Grekhem on 16.08.2022.
//

import Foundation
import UIKit

enum TabBarAssembly {
    static func buildTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        let networkService = NetworkService()
        let converterViewController = ConverterAssembly.buildModule(network: networkService)
        let favouriteViewController = FavouriteAssembly.buildModule()
        let newsViewController = UIViewController()
        let profileViewController = UIViewController()
        
        
        tabBar.setViewControllers([converterViewController, newsViewController, favouriteViewController, profileViewController], animated: true)
        
        tabBar.tabBar.tintColor = AppColor.orange.color
        tabBar.tabBar.backgroundColor = AppColor.grey.color
        tabBar.tabBar.unselectedItemTintColor = AppColor.white.color
        
        let converterControllerBarItem = UITabBarItem(title: "Converter", image: UIImage(named: "converter"), tag: 1)
        converterViewController.tabBarItem = converterControllerBarItem
        
        let favouriteControllerBarItem = UITabBarItem(title: "Favourites", image: UIImage(named: "favourites"), tag: 1)
        favouriteViewController.tabBarItem = favouriteControllerBarItem
        
        let newsControllerBarItem = UITabBarItem(title: "News", image: UIImage(named: "news"), tag: 1)
        newsViewController.tabBarItem = newsControllerBarItem
        
        let profileControllerBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), tag: 1)
        profileViewController.tabBarItem = profileControllerBarItem
        
        return tabBar
    }
}
