//
//  SceneDelegate.swift
//  DaDiTopApps-Demo
//
//  Created by 夏以铭 on 2019/12/9.
//  Copyright © 2019 夏以铭. All rights reserved.
//

import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var rootNavigationController: UINavigationController?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.backgroundColor = UIColor.white
            rootNavigationController = UINavigationController(rootViewController: MainVc())
            window.rootViewController = rootNavigationController
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
