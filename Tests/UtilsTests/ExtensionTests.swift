//
//  UITests.swift
//  ChemaUtils
//
//  Created by José María Jiménez on 1/11/24.
//

import XCTest

final class ExtensionTests: XCTestCase {

    func testArrayIsNotEmptyVar() {
        var array = [1]
        XCTAssertTrue(array.isNotEmpty)
        array.removeAll()
        XCTAssert(array.isEmpty)
    }

    func testHorizontalSpacer() {
        let stackView = UIStackView()
        stackView.addHorizontalSpacer(width: 10)
        XCTAssertEqual(1, stackView.arrangedSubviews.count)
    }
}
