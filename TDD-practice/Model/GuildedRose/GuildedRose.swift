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
    case decreasing2X
    case increasing
    case same
    case progressiveIncreasing
    case obselete

    static func of(item: Item) -> Depreciation {
        switch item.name {
        case "Aged Brie": return .increasing
        case "Backstage passes to a TAFKAL80ETC concert": return .progressiveIncreasing
        case "Sulfuras, Hand of Ragnaros": return .same
        case "Conjured Mana Cake": return .decreasing2X
        default: return .decreasing
        }
    }

    static func ofWhenExpired(item: Item) -> Depreciation {
        switch item.name {
        case "Aged Brie": return .increasing
        case "Backstage passes to a TAFKAL80ETC concert": return .obselete
        case "Sulfuras, Hand of Ragnaros": return .same
        case "Conjured Mana Cake": return .decreasing2X
        default: return .decreasing
        }
    }

    func amountForDepreciation(item: Item) -> Int {
        switch self {
        case .decreasing:
            if item.quality > 0 {
                return -1
            }
            return 0
        case .decreasing2X:
            if item.quality > 1 {
                return -2
            } else if item.quality > 0 {
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
        items = items.map { item -> Item in
            item.sellIn += changeForSellIn(item: item)
            return item
        }.map { item -> Item in
            item.quality += amountToChange(item: item)
            return item
        }.map { item -> Item in
            guard item.sellIn < 0 else { return item }
            item.quality += amountToChangeIfExpired(item: item)
            return item
        }.map { item -> Item in
            adjustForLimit(item: item)
        }
    }

    func amountToChange(item: Item) -> Int {
        Depreciation.of(item: item).amountForDepreciation(item: item)
    }

    func amountToChangeIfExpired(item: Item) -> Int {
        Depreciation.ofWhenExpired(item: item).amountForDepreciation(item: item)
    }

    func adjustForLimit(item: Item) -> Item {
        if item.name == "Sulfuras, Hand of Ragnaros" { return item }

        var newItem = item
        if item.quality > 50 {
            item.quality = 50
        }
        if item.quality < 0 {
            item.quality = 0
        }
        return item
    }
}
