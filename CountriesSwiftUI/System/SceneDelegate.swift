//
//  SceneDelegate.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 23.10.2019.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//

import UIKit
import SwiftUI
import Foundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var systemEventsHandler: SystemEventsHandler?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let (appState, interactors, systemEventsHandler) = createDependencies()
        let contentView = ContentView()
            .modifier(RootViewModifier(appState: appState,
                                       interactors: interactors))
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
        self.systemEventsHandler = systemEventsHandler
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        systemEventsHandler?.sceneOpenURLContexts(URLContexts)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        systemEventsHandler?.sceneDidBecomeActive()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        systemEventsHandler?.sceneWillResignActive()
    }
}

private extension SceneDelegate {
    func createDependencies() -> (AppState, InteractorsContainer, SystemEventsHandler) {
        let appState = AppState()
        let session = URLSession.shared
        let countriesWebRepository = RealCountriesWebRepository(
            session: session,
            baseURL: "https://restcountries.eu/rest/v2",
            appState: appState)
        let countriesInteractor = RealCountriesInteractor(
            webRepository: countriesWebRepository,
            appState: appState)
        let interactors = InteractorsContainer(countriesInteractor: countriesInteractor)
        let systemEventsHandler = RealSystemEventsHandler(appState: appState)
        return (appState, interactors, systemEventsHandler)
    }
}
