//
//  UtilsTests.swift
//  UtilsTests
//
//  Created by José María Jiménez on 20/10/24.
//

import XCTest
@testable import Utils

final class UtilsTests: XCTestCase {

    func testRunInMainShouldBeMainThread() {
        let sut = MainThreadTestMock()
        let backgroundWait = expectation(description: "waiting to background")
        let foregroundWait = expectation(description: "waiting to main")
        sut.completion = {
            backgroundWait.fulfill()
            runInMain {
                sut.backToMain()
                foregroundWait.fulfill()
            }
        }
        sut.goToBackground()
        XCTAssertFalse(sut.currentThread?.isMainThread ?? false)
        wait(for: [backgroundWait])
        wait(for: [foregroundWait])
        XCTAssertTrue(sut.currentThread?.isMainThread ?? false)
    }
}

final class MainThreadTestMock {
    var currentThread: Thread?
    var completion: (() -> Void)?

    func goToBackground() {
        DispatchQueue.global().async {
            self.currentThread = Thread.current
            self.completion?()
        }
    }

    func backToMain() {
        self.currentThread = Thread.current
    }
}
