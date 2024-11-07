//
//  DependencyResolver.swift
//  DependencyResolver
//
//  Created by José María Jiménez on 19/10/24.
//

import Foundation

public protocol Resolver {
    func resolve<Dependency>() throws -> Dependency
    func resolve<Dependency>(type: Dependency.Type) throws -> Dependency
}

public protocol Injector {
    func register<Dependency>(type: Dependency.Type, with dependency: @escaping () -> Dependency)
    func register<Dependency, Injectable: InjectableCapable>(type: Dependency.Type, with injectable: Injectable.Type)
}

public protocol InjectableCapable {
    init()
}

public enum DependencyResolverErrors: Error {
    case nothingRegistered
    case typeMismatch
}

public final class DefaultDependencyResolver: Resolver, Injector {

    public static let shared = DefaultDependencyResolver()
    private var registeredDependencies: [String: [Any]] = [:]

    public func resolve<Dependency>() throws -> Dependency {
        guard let registered = registeredDependencies[String(describing: Dependency.self)]?.last else {
            throw DependencyResolverErrors.nothingRegistered
        }
        guard let casted = registered as? () -> Dependency else {
            guard let casted = registered as? InjectableCapable.Type else {
                throw DependencyResolverErrors.typeMismatch
            }
            return (casted.init() as? Dependency)!
        }
        return casted()
    }

    public func resolve<Dependency>(type: Dependency.Type) throws -> Dependency {
        guard let registered = registeredDependencies[String(describing: type)]?.last else {
            throw DependencyResolverErrors.nothingRegistered
        }
        guard let casted = registered as? () -> Dependency else {
            guard let casted = registered as? InjectableCapable.Type else {
                throw DependencyResolverErrors.typeMismatch
            }
            return (casted.init() as? Dependency)!
        }
        return casted()
    }

    public func register<Dependency>(type: Dependency.Type, with provider: @escaping () -> Dependency) {
        var registered = registeredDependencies[String(describing: type)] ?? []
        registered.append(provider)
        registeredDependencies[String(describing: type)] = registered
    }

    // swiftlint:disable:next line_length
    public func register<Dependency, Injectable: InjectableCapable>(type: Dependency.Type, with injectable: Injectable.Type) {
        var registered = registeredDependencies[String(describing: type)] ?? []
        registered.append(injectable)
        registeredDependencies[String(describing: type)] = registered
    }

    public func clear() {
        registeredDependencies.removeAll()
    }

    public func resolveAllTypes<Dependency>(of type: Dependency.Type) -> [Dependency] {
        var matches: [Dependency] = []
        guard let values = registeredDependencies[String(describing: type)] else { return matches }
        values.forEach {
            if let injectable = $0 as? InjectableCapable.Type,
               let instance = injectable.init() as? Dependency {
                matches.append(instance)
            } else if let closure = $0 as? () -> Dependency {
                matches.append(closure())
            }
        }
        return matches
    }
}

public func registerDependency<Dependency>(_ type: Dependency.Type, _ with: @escaping () -> Dependency) {
    DefaultDependencyResolver.shared.register(type: type, with: with)
}

// swiftlint:disable:next line_length
public func registerDependency<Dependency, Injectable: InjectableCapable>(_ type: Dependency.Type, _ injectable: Injectable.Type) {
    DefaultDependencyResolver.shared.register(type: type, with: injectable)
}

@propertyWrapper
public struct Injected<Value> {
    public var wrappedValue: Value

    public init() {
        do {
            self.wrappedValue = try DefaultDependencyResolver.shared.resolve()
        } catch {
            fatalError()
        }
    }
}
