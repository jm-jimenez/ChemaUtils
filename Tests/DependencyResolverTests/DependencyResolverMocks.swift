//
//  DependencyResolverMocks.swift
//  DependencyResolverTests
//
//  Created by José María Jiménez on 19/10/24.
//

import Foundation
import DependencyResolver

protocol TestProtocol { }

final class TestClass: TestProtocol, InjectableCapable { }

struct InjectedMock {
    @Injected var test: TestProtocol
}
