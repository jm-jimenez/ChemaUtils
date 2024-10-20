//
//  UseCase.swift
//  ChemaUtils
//
//  Created by José María Jiménez on 20/10/24.
//

public protocol UseCase {
    associatedtype Success
    func execute() async throws -> Success
}
