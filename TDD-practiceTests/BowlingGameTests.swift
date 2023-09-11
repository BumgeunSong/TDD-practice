//
//  BowlingGameTests.swift
//  TDD-practiceTests
//
//  Created by 송범근 on 2023/09/11.
//

import XCTest
@testable import TDD_practice

/*
 The game consists of 10 frames.
 In each frame the player has two rolls to knock down 10 pins.
 The score for the frame is the total number of pins knocked down, plus bonuses for strikes and spares.

 A spare is when the player knocks down all 10 pins in two rolls.
 The bonus for that frame is the number of pins knocked down by the next roll.

 A strike is when the player knocks down all 10 pins on his first roll.
 The frame is then completed with a single roll.
 The bonus for that frame is the value of the next two rolls.

 In the tenth frame a player who rolls a spare or strike is allowed to roll the extra balls to complete the frame.
 However no more than three balls can be rolled in tenth frame.
 */

final class BowlingGameTests: XCTestCase {
    func test_no_roll_zero_score() {
        XCTAssertEqual(Game().score(), 0)
    }

    func test_roll_10_zero_score() {
        // Given
        let sut = Game()

        // When
        sut.roll(numberOfKnockedPin: 10)

        XCTAssertEqual(sut.score(), 0)
    }

    func test_roll_5_3_score_8() {
        // Given
        let sut = Game()

        // When
        sut.roll(numberOfKnockedPin: 5)
        sut.roll(numberOfKnockedPin: 3)

        // Then
        XCTAssertEqual(sut.score(), 8)
    }
}
