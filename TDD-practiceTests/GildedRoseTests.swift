//
//  GildedRoseTests.swift
//  TDD-practiceTests
//
//  Created by 송범근 on 2023/08/08.
//

import XCTest
@testable import TDD_practice

/*
 Gilded Rose 요구사항 명세
 안녕하세요, Gilded Rose에 오신 것을 환영합니다. 우리는 도시의 주요 지역에있는 작은 숙소(상점)이며, Allison(앨리슨)이라는 상냥한 사람이 운영하고 있습니다.

 우리는 최고의 제품만을 구입하여 판매하고 있습니다. 불행히도, 상품 판매 기한이 가까워 질수록 품질이 저하되어가고 있습니다.

 우리는 재고를 업데이트하는 시스템이 있습니다. 이 시스템은 지금은 새로운 모험을 떠나고 없는 Leeroy(리로이)라는 빡빡한 성격의 인물에 의해 개발되었습니다.

 당신이 할 일은 시스템에 새로운 기능을 추가하여, 새로운 카테고리의 상품을 판매할 수 있도록하는 것입니다.

 시스템 소개
 먼저 시스템을 소개합니다.

 -  모든 아이템은 SellIn 값을 가지며, 이는 아이템을 판매해야하는 (남은) 기간을 나태냅니다.
 - 모든 아이템은 Quality 값을 가지며, 이것은 아이템의 가치를 나타냅니다.
 - 하루가 지날때마다, 시스템은 두 값(SellIn, Quality)을 1 씩 감소시킵니다.
 간단하죠? 흥미로운 부분은 지금부터입니다.

 - 판매하는 나머지 일수가 없어지면, Quality 값은 2배로 떨어집니다.
 - Quality 값은 결코 음수가 되지는 않습니다.
 - "Aged Brie"(오래된 브리치즈)은(는) 시간이 지날수록 Quality 값이 올라갑니다.
 - Quality 값은 50를 초과 할 수 없습니다.
 - Sulfuras는 전설의 아이템이므로, 반드시 판매될 필요도 없고 Quality 값도 떨어지지 않습니다. 전설의 아이템은 Quality가 50 이상일 수 있다.
 - "Backstage passes(백스테이지 입장권)"는 "Aged Brie"와 유사하게 SellIn 값에 가까워 질수록 Quality 값이 상승하고, 10일 부터는 매일 2 씩 증가하다, 5일 부터는이 되면 매일 3 씩 증가하지만, 콘서트 종료 후에는 0으로 떨어집니다.

 시스템 업데이트 요구 사항
  - 최근 "Conjured"(마법에 걸린) 상품 공급 업체와 계약했습니다. 따라서 시스템의 업데이트가 필요합니다.

 - "Conjured" 아이템은 일반 아이템의 2배의 속도로 품질(Quality)이 저하됩니다.
 모든 것이 제대로 작동하는 한에서는 UpdateQuality() 메서드를 변경하거나 새로운 코드의 추가를 자유롭게 할 수 있습니다. 그러나 Item 클래스와 Items 속성은 변경하지 마세요.

 - 이것들은 저기 구석에있는 고블린의 것이고, 그 친구는 코드의 공유 소유권을 믿지 않기 때문에, 미친듯이 화를 내며(insta-rage) 여러분에게 한 방(one-shot)을 날릴 수도 있습니다. (UpdateQuality() 메서드와 Items 속성을 정적(static)으로 만드는 것은 괜찮습니다. 저희가 책임질게요.)

 - 다시 한 번 확인하자면, 아이템의 Quality는 50 이상으로 증가할 수는 없습니다. 하지만 Sulfuras는 전설의 아이템이기 때문에 Quality 값은 80이며, 값이 바뀌지 않습니다.
 */

final class GildedRoseTests: XCTestCase {

    private let items: [Item] = [
        Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20),
        Item(name: "Aged Brie", sellIn: 2, quality: 0),
        Item(name: "Elixir of the Mongoose", sellIn: 5, quality: 7),
        Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 0, quality: 80),
        Item(name: "Sulfuras, Hand of Ragnaros", sellIn: -1, quality: 80),
        Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 15, quality: 20),
        Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 10, quality: 49),
        Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 5, quality: 49),
        // this conjured item does not work properly yet
        Item(name: "Conjured Mana Cake", sellIn: 3, quality: 6),
    ]

    var sut: GildedRose!

    func testStart() {
        sut = GildedRose(items: items)
        let days = 2
        for i in 0 ..< days {
            print("-------- day \(i) --------")
            print("name, sellIn, quality")
            for item in items { print(item) }
            print("")

            let dexterityVest = items[0]
            XCTAssertEqual(dexterityVest.sellIn, 10 - i)
            XCTAssertEqual(dexterityVest.quality, 20 - i)
            sut.updateQuality()
        }
    }

    ///"Conjured" 아이템은 일반 아이템의 2배의 속도로 품질(Quality) 저하
    func test_conjured_should_reduce_two_by_day_when_not_expired() {
        // Given
        let conjured = Item(name: "Conjured Mana Cake", sellIn: 3, quality: 6)
        sut = GildedRose(items: [conjured])

        // Then
        (1...3).forEach { days in
            // When
            sut.updateQuality()

            // Then
            let initialQuality = 6
            XCTAssertGreaterThanOrEqual(conjured.sellIn, 0)
            XCTAssertEqual(conjured.quality, initialQuality - (days * 2))
        }
    }

    func test_conjured_should_reduce_4_by_day_when_expired() {
        // Given
        let conjured = Item(name: "Conjured Mana Cake", sellIn: 0, quality: 15)
        sut = GildedRose(items: [conjured])

        // Then
        (1...3).forEach { days in
            // When
            sut.updateQuality()

            // Then
            let initialQuality = 15
            XCTAssertLessThan(conjured.sellIn, 0)
            XCTAssertEqual(conjured.quality, initialQuality - (days * 4))
        }
    }

    /// 하루가 지날때마다, 시스템은 두 값(SellIn, Quality)을 1 씩 감소시킨다.
    func test_quality_should_reduce_one_by_day() {
        // Given
        let vest = Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20)
        sut = GildedRose(items: [vest])

        // When
        sut.updateQuality()

        // Then
        XCTAssertEqual(vest.sellIn, 9)
    }

    func test_sellin_should_reduce_one_by_day() {
        // Given
        let vest = Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20)
        sut = GildedRose(items: [vest])

        // When
        sut.updateQuality()

        // Then
        XCTAssertEqual(vest.sellIn, 9)
    }

    //    - 판매하는 나머지 일수가 없어지면, Quality 값은 2배로 떨어집니다.
    //    - Quality 값은 결코 음수가 되지는 않습니다.
    func test_sellin_should_reduce_one_by_day_when_quality_is_zero() {
        // Given
        let elixir = Item(name: "Elixir of the Mongoose", sellIn: 2, quality: 0)
        sut = GildedRose(items: [elixir])

        // When
        sut.updateQuality()

        // Then
        XCTAssertEqual(elixir.sellIn, 1)
    }


    func test_quality_should_not_reduce_one_by_day_when_quality_is_zero() {
        // Given
        let elixir = Item(name: "Elixir of the Mongoose", sellIn: 2, quality: 0)
        sut = GildedRose(items: [elixir])

        // When
        sut.updateQuality()

        // Then
        XCTAssertEqual(elixir.quality, 0)
    }

    func test_quality_should_reduce_two_by_day_when_sellIn_is_zero() {
        // Given
        let elixir = Item(name: "Elixir of the Mongoose", sellIn: 0, quality: 10)
        sut = GildedRose(items: [elixir])

        // When
        sut.updateQuality()

        // Then
        XCTAssertEqual(elixir.quality, 8)

        // When
        sut.updateQuality()

        // Then
        XCTAssertEqual(elixir.quality, 6)
    }

    func test_brie_should_increase_quality_by_day_when_sellIn_is_over_zero() {
        // Given
        let brie = Item(name: "Aged Brie", sellIn: 2, quality: 0)
        sut = GildedRose(items: [brie])

        // When
        sut.updateQuality()

        // Then
        XCTAssertEqual(brie.quality, 1)

        // When
        sut.updateQuality()

        // Then
        XCTAssertEqual(brie.quality, 2)
    }

    func test_brie_should_increase_2_quality_by_day_when_sellIn_is_zero() {
        // Given
        let brie = Item(name: "Aged Brie", sellIn: 0, quality: 0)
        sut = GildedRose(items: [brie])

        // When
        sut.updateQuality()

        // Then
        XCTAssertEqual(brie.quality, 2)

        // When
        sut.updateQuality()

        // Then
        XCTAssertEqual(brie.quality, 4)
    }

    func test_quality_should_not_exceed_50() {
        // Given
        let brie = Item(name: "Aged Brie", sellIn: 0, quality: 0)
        let vest = Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 50)
        sut = GildedRose(items: [brie, vest])

        (0...50).forEach { _ in
            // When
            sut.updateQuality()
            // Then
            XCTAssertLessThanOrEqual(brie.quality, 50)
            XCTAssertLessThanOrEqual(vest.quality, 50)
        }
    }

    func test_quality_should_not_be_minus() {
        // Given
        let elixir = Item(name: "Elixir of the Mongoose", sellIn: 0, quality: 10)
        let vest = Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 50)
        sut = GildedRose(items: [elixir, vest])

        (0...50).forEach { _ in
            // When
            sut.updateQuality()
            // Then
            XCTAssertGreaterThanOrEqual(elixir.quality, 0)
            XCTAssertGreaterThanOrEqual(vest.quality, 0)
        }
    }

    func test_Sulfuras_should_not_expire_or_deprecated() {
        // Given
        let sulfruas1 = Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 0, quality: 80)
        let sulfruas2 = Item(name: "Sulfuras, Hand of Ragnaros", sellIn: -1, quality: 80)
        sut = GildedRose(items: [sulfruas1, sulfruas2])

        (0...50).forEach { _ in
            // When
            sut.updateQuality()
            // Then
            XCTAssertEqual(sulfruas1.sellIn, 0)
            XCTAssertEqual(sulfruas1.quality, 80)
            XCTAssertEqual(sulfruas2.sellIn, -1)
            XCTAssertEqual(sulfruas2.quality, 80)
        }
    }

    /// SellIn이 10 초과일 때는 퀄리티가 1 증가
    func test_backstage_pass_quality_should_increase_by_day_when_sellIn_more_10() {
        // Given
        let backstagePass15 = Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 15, quality: 20)
        sut = GildedRose(items: [backstagePass15])

        (1...4).forEach { days in
            // When
            sut.updateQuality()
            // Then
            let initialQuality = 20
            XCTAssertGreaterThan(backstagePass15.sellIn, 10)
            XCTAssertEqual(backstagePass15.quality, initialQuality + days)
        }
    }

    /// SellIn이 10이하일 때는 퀄리티가 2 증가
    func test_backstage_pass_quality_should_increase_by_day_when_sellIn_5_9() {
        // Given
        let backstagePass10 = Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 10, quality: 20)

        sut = GildedRose(items: [backstagePass10])

        (1...4).forEach { days in
            // When
            sut.updateQuality()
            // Then
            let initialQuality = 20
            XCTAssertGreaterThan(backstagePass10.sellIn, 5)
            XCTAssertEqual(backstagePass10.quality, initialQuality + (days * 2))
        }
    }

    /// SellIn이 1이상일 때는 퀄리티가 3 증가
    func test_backstage_pass_quality_should_increase_by_day_when_sellIn_1_5() {
        // Given
        let backstagePass5 = Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 5, quality: 20)

        sut = GildedRose(items: [backstagePass5])

        (1...4).forEach { days in
            // When
            sut.updateQuality()
            // Then
            let initialQuality = 20
            XCTAssertGreaterThan(backstagePass5.sellIn, 0)
            XCTAssertEqual(backstagePass5.quality, initialQuality + (days * 3))
        }
    }

    /// SellIn이 0이면 퀄리티는 0
    func test_backstage_pass_quality_should_increase_by_day_when_sellIn_zero() {
        // Given
        let backstagePass5 = Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 0, quality: 20)

        sut = GildedRose(items: [backstagePass5])

        (1...4).forEach { days in
            // When
            sut.updateQuality()
            // Then
            XCTAssertEqual(backstagePass5.quality, 0)
        }
    }

    /// SellIn이 남아있어도 퀄리티는 50이상으로 증가 안함
    func test_backstage_pass_quality_should_not_increas_when_quality_is_over_50() {
        // Given
        let backstagePass49 = Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 5, quality: 49)
        let backstagePass48 = Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 5, quality: 48)
        let backstagePass47 = Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 5, quality: 47)

        sut = GildedRose(items: [backstagePass49, backstagePass48, backstagePass47])

        (1...4).forEach { days in
            // When
            sut.updateQuality()
            // Then
            XCTAssertEqual(backstagePass49.quality, 50)
            XCTAssertEqual(backstagePass48.quality, 50)
            XCTAssertEqual(backstagePass47.quality, 50)
        }
    }
}
