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

struct PolicyMaker {
    static func qualityPolicy(of item: Item) -> QualityPolicy {
        switch item.name {
        case "Aged Brie": return .increasing
        case "Backstage passes to a TAFKAL80ETC concert": return .progressiveIncreasing
        case "Sulfuras, Hand of Ragnaros": return .same
        case "Conjured Mana Cake": return .decreasing2X
        default: return .decreasing
        }
    }

    static func qualityPolicyWhenExpired(of item: Item) -> QualityPolicy {
        switch item.name {
        case "Aged Brie": return .increasing
        case "Backstage passes to a TAFKAL80ETC concert": return .obsolete
        case "Sulfuras, Hand of Ragnaros": return .same
        case "Conjured Mana Cake": return .decreasing2X
        default: return .decreasing
        }
    }

    static func expiryPolicy(of item: Item) -> ExpiryPolicy {
        switch item.name {
        case "Sulfuras, Hand of Ragnaros": return .same
        default: return .decrease
        }
    }

    static func qualityLimit(of item: Item) -> QualityLimit {
        switch item.name {
        case "Sulfuras, Hand of Ragnaros": return .none
        default: return .zeroToFifty
        }
    }
}

enum QualityPolicy {
    case decreasing
    case decreasing2X
    case increasing
    case same
    case progressiveIncreasing
    case obsolete

    func amountToChange(item: Item) -> Int {
        switch self {
        case .decreasing:
            return -1
        case .decreasing2X:
            return -2
        case .increasing:
            return 1
        case .same:
            return 0
        case .obsolete:
            return  -item.quality
        case .progressiveIncreasing:
            return increasingAmount(sellIn: item.sellIn)
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

enum ExpiryPolicy {
    case decrease
    case same

    var amountToChange: Int {
        switch self {
        case .decrease:
            return -1
        case .same:
            return 0
        }
    }
}

enum QualityLimit {
    case zeroToFifty
    case none

    var max: Int {
        switch self {
        case .zeroToFifty: return 50
        case .none: return Int.max
        }
    }

    var min: Int {
        switch self {
        case .zeroToFifty: return 0
        case .none: return Int.min
        }
    }
}

public class GildedRose {
    var items: [Item]

    public init(items: [Item]) {
        self.items = items
    }

    public func updateQuality() {
        items = items
            .updateSellIn()
            .updateQuality()
            .adjustForLimit()
    }
}

extension Array where Element == Item {
    func updateSellIn() -> Self {
        self.map { updateSellIn(item: $0) }
    }

    func updateQuality() -> Self {
        self.map { updateQuality(item: $0) }
    }

    func adjustForLimit() -> Self {
        self.map { adjustForLimit(item: $0) }
    }

    private func updateSellIn(item: Item) -> Item {
        var newItem = item
        newItem.sellIn += PolicyMaker.expiryPolicy(of: item).amountToChange
        return newItem
    }

    private func updateQuality(item: Item) -> Item {
        var newItem = item

        newItem.quality += PolicyMaker.qualityPolicy(of: item).amountToChange(item: item)

        guard item.sellIn < 0 else { return newItem }
        newItem.quality += PolicyMaker.qualityPolicyWhenExpired(of: item).amountToChange(item: item)

        return newItem
    }

    private func adjustForLimit(item: Item) -> Item {
        let qualityLimit = PolicyMaker.qualityLimit(of: item)

        var newItem = item
        if newItem.quality > qualityLimit.max {
            newItem.quality = qualityLimit.max
        }
        if newItem.quality < qualityLimit.min {
            newItem.quality = qualityLimit.min
        }
        return newItem
    }
}
