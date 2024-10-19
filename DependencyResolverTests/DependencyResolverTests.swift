//
//  DependencyResolverTests.swift
//  DependencyResolverTests
//
//  Created by José María Jiménez on 19/10/24.
//

import XCTest
import DependencyResolver

final class DependencyResolverTests: XCTestCase {
    func testInjectedDependencyIsResolved() {
        registerDependency(TestProtocol.self, TestClass.self)
        let mock = InjectedMock()
        XCTAssertNotNil(mock.test)
        XCTAssertTrue(mock.test is TestClass)
    }
}
