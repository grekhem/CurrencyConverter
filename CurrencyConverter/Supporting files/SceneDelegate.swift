//
//  SceneDelegate.swift
//  CurrencyConverter
//
//  Created by Grekhem on 16.08.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        let vc = TabBarAssembly.buildTabBar()
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        self.checkFirstOpenApp()
    }
    
    func checkFirstOpenApp() {
        let defaults = UserDefaults.standard
        guard let _ = defaults.stringArray(forKey: "favourites") else {
            defaults.set([], forKey: "favourites")
            return
        }
    }
}

