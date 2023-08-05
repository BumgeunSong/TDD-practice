//
//  TDD_practiceTests.swift
//  TDD-practiceTests
//
//  Created by 송범근 on 2023/08/05.
//

import XCTest
@testable import TDD_practice

final class TDD_practiceTests: XCTestCase {

    /*
     The wardrobe elements are available in the following sizes: 50cm, 75cm, 100cm, and 120cm.
     The wall on which the wardrobe elements are placed has a total length of 250cm.
     With which combinations of wardrobe elements can you make the most of the space?
     */
    func testWardrobeManager() {
        let sut = WardrobeManager()
        let combinations = sut.combinations()
        XCTAssertEqual(combinations.reduce(0, +), 250)
    }
}
