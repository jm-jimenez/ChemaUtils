//
//  Threads.swift
//  ChemaUtils
//
//  Created by José María Jiménez on 20/10/24.
//

import Foundation

public func runInMain(closure: @escaping () -> Void) {
    guard Thread.current.isMainThread else {
        Task { @MainActor in
            runInMain(closure: closure)
        }
        return
    }
    closure()
}
