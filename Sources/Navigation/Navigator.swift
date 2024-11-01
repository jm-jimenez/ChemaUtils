//
//  Navigator.swift
//  Navigation
//
//  Created by José María Jiménez on 19/10/24.
//

import UIKit
import DependencyResolver

public final class Navigator {
    public static let shared = Navigator()
    public weak var navigationController: UINavigationController?

    public func navigateTo(_ destination: Destination) {
        let navigators = DefaultDependencyResolver.shared.resolveAllTypes(of: NavigationCapable.self)

        guard let viewController = navigators.compactMap({ $0.provideNavigationFor(destination) }).first else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

public protocol NavigationCapable: InjectableCapable {
    func provideNavigationFor(_ destination: Destination) -> UIViewController?
}

public protocol Destination { }
