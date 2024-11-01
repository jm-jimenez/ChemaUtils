//
//  NavigationMocks.swift
//  ChemaUtils
//
//  Created by José María Jiménez on 1/11/24.
//

import UIKit
import Navigation

final class MockNavigationController: UINavigationController {
    var navigationPushed = false

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        navigationPushed = true
    }
}

struct MockNavigationCapable: NavigationCapable {
    func provideNavigationFor(_ destination: Destination) -> UIViewController? {
        guard destination is MockDestination else { return nil }
        return UIViewController()
    }

    enum MockDestination: Destination {
        case mock
    }
}
