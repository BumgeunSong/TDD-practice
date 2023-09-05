//
//  GuildedRose.swift
//  TDD-practice
//
//  Created by 송범근 on 2023/08/08.
//

/* 리팩토링 규칙
- 한 함수 5줄 제한
- 한 함수에서 호출, 전달 하나만 할 것
- if문은 함수 시작에만 배치한다.
- else를 사용하지 않는다.
 */

enum Depreciation {
    case decreasing
    case increasing
    case same
    case progressiveIncreasing
    case obselete

    static func of(item: Item) -> Depreciation {
        switch item.name {
        case "Aged Brie": return .increasing
        case "Backstage passes to a TAFKAL80ETC concert": return .progressiveIncreasing
        case "Sulfuras, Hand of Ragnaros": return .same
        default: return .decreasing
        }
    }

    static func ofWhenExpired(item: Item) -> Depreciation {
        switch item.name {
        case "Aged Brie": return .increasing
        case "Backstage passes to a TAFKAL80ETC concert": return .obselete
        case "Sulfuras, Hand of Ragnaros": return .same
        default: return .decreasing
        }
    }

    func amountToChange(item: Item) -> Int {
        switch self {
        case .decreasing:
            if canQualityDecrease(item: item) {
                return -1
            }
            return 0
        case .increasing:
            if item.quality < 50 {
                return 1
            }
            return 0
        case .same:
            return 0
        case .obselete:
            return  -item.quality
        case .progressiveIncreasing:
            let toBeAmount = item.quality + increasingAmount(sellIn: item.sellIn) // 불변하게 만들고 싶다..

            if toBeAmount > 50 {
                return (50 - item.quality)
            } else {
                return increasingAmount(sellIn: item.sellIn)
            }
        }
    }

    fileprivate func canQualityDecrease(item: Item) -> Bool {
        return item.quality > 0
    }

    private func increasingAmount(sellIn: Int) -> Int {
        switch sellIn {
        case 1...5: return 3
        case 6...10: return 2
        default: return 1
        }
    }
}

public class GildedRose {
    var items: [Item]

    public init(items: [Item]) {
        self.items = items
    }

    func changeForSellIn(item: Item) -> Int  {
        if item.name == "Sulfuras, Hand of Ragnaros" {
            return 0
        }
        return -1
    }

    public func updateQuality() {
        for item in items {
            item.quality += Depreciation.of(item: item).amountToChange(item: item)
            item.sellIn += changeForSellIn(item: item)
            if item.sellIn < 0 {
                item.quality += Depreciation.ofWhenExpired(item: item).amountToChange(item: item)
            }
        }
    }
}
