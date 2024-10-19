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
    func register<Dependency, Implementation: Injectable>(type: Dependency.Type, with dependency: Implementation.Type)
}

public final class DefaultDependencyResolver: Resolver, Injector {

    public static let shared = DefaultDependencyResolver()
    private var registeredDependencies: [String: Any] = [:]
    
    public func resolve<Dependency>() -> Dependency {
        guard let registered = registeredDependencies[String(describing: Dependency.self)] else { fatalError("Nothing registered") }
        guard let casted = registered as? Dependency else { fatalError("Type missmatch") }
        return casted
    }
    
    public func resolve<Dependecy>(type: Dependecy.Type) -> Dependecy {
        guard let registered = registeredDependencies[String(describing: type)] else { fatalError("Nothing registered") }
        guard let casted = registered as? Dependecy else { fatalError("Type missmatch") }
        return casted
    }
    
    public func register<Dependency, Implementation: Injectable>(type: Dependency.Type, with dependency: Implementation.Type) {
        registeredDependencies[String(describing: type)] = dependency.init()
    }
}

public func registerDependency<Dependency, Implementation: Injectable>(_ type: Dependency.Type, _ with: Implementation.Type) {
    DefaultDependencyResolver.shared.register(type: type, with: with)
}

public protocol Injectable: AnyObject {
    init()
}

@propertyWrapper
public struct Injected<Value> {
    private(set) public var wrappedValue: Value

    public init() {
        self.wrappedValue = DefaultDependencyResolver.shared.resolve()
    }
}
