//
//  DependencyResolverTests.swift
//  DependencyResolverTests
//
//  Created by José María Jiménez on 19/10/24.
//

import XCTest
import DependencyResolver

final class DependencyResolverTests: XCTestCase {

    override func tearDown() {
        super.tearDown()
        DefaultDependencyResolver.shared.clear()
    }

    func testInjectedDependencyIsResolved() {
        registerDependency(TestProtocol.self) {
            TestClass()
        }
        let mock = InjectedMock()
        XCTAssertNotNil(mock.test)
        XCTAssertTrue(mock.test is TestClass)
    }

    func testResolveForType() {
        registerDependency(TestProtocol.self) {
            TestClass()
        }
        let resolve = DefaultDependencyResolver.shared.resolve(type: TestProtocol.self)
        XCTAssertTrue(resolve is TestClass)
    }
}
