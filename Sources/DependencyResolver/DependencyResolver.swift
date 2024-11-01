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
    private var registeredDependencies: [String: Any] = [:]

    public func resolve<Dependency>() throws -> Dependency {
        guard let registered = registeredDependencies[String(describing: Dependency.self)] else {
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
        guard let registered = registeredDependencies[String(describing: type)] else {
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
        registeredDependencies[String(describing: type)] = provider
    }

    // swiftlint:disable:next line_length
    public func register<Dependency, Injectable: InjectableCapable>(type: Dependency.Type, with injectable: Injectable.Type) {
        registeredDependencies[String(describing: type)] = injectable
    }

    public func clear() {
        registeredDependencies.removeAll()
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
