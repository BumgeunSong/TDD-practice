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

    static func of(item: Item) -> Depreciation {
        switch item.name {
        case "Aged Brie": return .increasing
        case "Backstage passes to a TAFKAL80ETC concert": return .progressiveIncreasing
        case "Sulfuras, Hand of Ragnaros": return .same
        default: return .decreasing
        }
    }

    func apply(item: Item) {
        switch self {
        case .decreasing:
            if canQualityDecrease(item: item) {
                item.quality = item.quality - 1
            }
        case .increasing:
            if item.quality < 50 {
                item.quality = item.quality + 1
            }
        case .same:
            break
        case .progressiveIncreasing:
            let toBeAmount = item.quality + increasingAmount(sellIn: item.sellIn) // 불변하게 만들고 싶다..

            if toBeAmount > 50 {
                item.quality = 50
            } else {
                item.quality = toBeAmount
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


    fileprivate func handeExpiration(item: Item) {
        if item.name != "Sulfuras, Hand of Ragnaros" {
            item.sellIn = item.sellIn - 1
        }

        if item.sellIn < 0 {
            if item.name == "Aged Brie" {
                if item.quality < 50 {
                    item.quality = item.quality + 1
                }
            } else {
                if item.name == "Backstage passes to a TAFKAL80ETC concert" {
                    item.quality = item.quality - item.quality
                } else if item.quality > 0 && item.name != "Sulfuras, Hand of Ragnaros" {
                    item.quality = item.quality - 1
                }

            }
        }
    }

    public func updateQuality() {
        for item in items {
            Depreciation.of(item: item).apply(item: item)
            handeExpiration(item: item)
        }
    }
}
