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

    func testResolveForType() throws {
        registerDependency(TestProtocol.self) {
            TestClass()
        }
        let resolve = try DefaultDependencyResolver.shared.resolve(type: TestProtocol.self)
        XCTAssertTrue(resolve is TestClass)
    }

    func testResolveWithInjectable() throws {
        registerDependency(TestProtocol.self, TestClass.self)
        let resolve = try DefaultDependencyResolver.shared.resolve(type: TestProtocol.self)
    }

    func testNotRegisteredResolveShouldFail() {
        XCTAssertThrowsError(try DefaultDependencyResolver.shared.resolve(type: TestProtocol.self))
        do {
            let _: TestProtocol = try DefaultDependencyResolver.shared.resolve()
        } catch {
            XCTAssertTrue(error is DependencyResolverErrors)
        }
    }

    func testRetrieveAllTypes() {
        registerDependency(TestProtocol.self, TestClass.self)
        registerDependency(TestProtocol.self, AnotherTestClass.self)
        let result = DefaultDependencyResolver.shared.resolveAllTypes(of: TestProtocol.self)
        XCTAssertEqual(2, result.count)
    }

    func testRetrieveAllTypesWithClosure() {
        registerDependency(TestProtocol.self) {
            TestClass()
        }
        registerDependency(TestProtocol.self) {
            AnotherTestClass()
        }
        let result = DefaultDependencyResolver.shared.resolveAllTypes(of: TestProtocol.self)
        XCTAssertEqual(2, result.count)
    }
}
