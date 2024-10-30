//
//  UseCase.swift
//  ChemaUtils
//
//  Created by José María Jiménez on 20/10/24.
//

import DependencyResolver

public protocol UseCase: InjectableCapable {
    associatedtype Success
    func execute() async throws -> Success
}
