//
//  NavigationTests.swift
//  NavigationTests
//
//  Created by José María Jiménez on 19/10/24.
//

import XCTest
import DependencyResolver
@testable import Navigation

final class NavigationTests: XCTestCase {

    func testNavigatorShouldNavigate() {
        let mockNavigationController = MockNavigationController()
        registerDependency(NavigationCapable.self, MockNavigationCapable.self)
        Navigator.shared.navigationController = mockNavigationController
        Navigator.shared.navigateTo(MockNavigationCapable.MockDestination.mock)
        XCTAssertTrue(mockNavigationController.navigationPushed)
    }
}
