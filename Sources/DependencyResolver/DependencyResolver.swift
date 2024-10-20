//
//  DependencyResolver.swift
//  DependencyResolver
//
//  Created by José María Jiménez on 19/10/24.
//

import Foundation

public protocol Resolver {
    func resolve<Dependency>() -> Dependency
    func resolve<Dependency>(type: Dependency.Type) -> Dependency
}

public protocol Injector {
    func register<Dependency>(type: Dependency.Type, with dependency: @escaping () -> Dependency)
}

public final class DefaultDependencyResolver: Resolver, Injector {

    public static let shared = DefaultDependencyResolver()
    private var registeredDependencies: [String: Any] = [:]
    
    public func resolve<Dependency>() -> Dependency {
        guard let registered = registeredDependencies[String(describing: Dependency.self)] else { fatalError("Nothing registered") }
        guard let registered = registered as? () -> Dependency else { fatalError() }
        return registered()
    }
    
    public func resolve<Dependency>(type: Dependency.Type) -> Dependency {
        guard let registered = registeredDependencies[String(describing: type)] else { fatalError("Nothing registered") }
        guard let casted = registered as? () -> Dependency else { fatalError("Type missmatch") }
        return casted()
    }
    
    public func register<Dependency>(type: Dependency.Type, with provider: @escaping () -> Dependency) {
        registeredDependencies[String(describing: type)] = provider
    }

    public func clear() {
        registeredDependencies.removeAll()
    }
}

public func registerDependency<Dependency>(_ type: Dependency.Type, _ with: @escaping () -> Dependency) {
    DefaultDependencyResolver.shared.register(type: type, with: with)
}

@propertyWrapper
public struct Injected<Value> {
    private(set) public var wrappedValue: Value

    public init() {
        self.wrappedValue = DefaultDependencyResolver.shared.resolve()
    }
}
