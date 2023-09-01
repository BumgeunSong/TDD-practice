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

public class GildedRose {
    var items: [Item]

    public init(items: [Item]) {
        self.items = items
    }

    fileprivate func handleBackStagePass(item: Item) {
        if item.name == "Backstage passes to a TAFKAL80ETC concert" {
            increaseQualityIfPossible(item)
        }
    }

    fileprivate func increaseQualityIfPossible(_ item: Item) {
        guard item.quality < 50 else { return }
        let amount = increasingAmount(sellIn: item.sellIn)
        item.quality += amount
    }

    private func increasingAmount(sellIn: Int) -> Int {
        switch sellIn {
        case 1...5: return 2
        case 6...10: return 1
        default: return 0
        }
    }

    func shouldQualityDecrease(item: Item) -> Bool {
        item.name != "Aged Brie" && item.name != "Backstage passes to a TAFKAL80ETC concert" && item.name != "Sulfuras, Hand of Ragnaros"
    }

    fileprivate func shouldQualitySame(item: Item) -> Bool {
        return item.name == "Sulfuras, Hand of Ragnaros"
    }

    fileprivate func canQualityDecrease(item: Item) -> Bool {
        return item.quality > 0
    }

    enum Depreciation {
        case decreasing
        case increasing
        case same
    }

    func depreciation(of item: Item) -> Depreciation {
        switch item.name {
        case "Aged Brie": return .increasing
        case "Backstage passes to a TAFKAL80ETC concert": return .increasing
        case "Sulfuras, Hand of Ragnaros": return .same
        default: return .decreasing
        }
    }

    public func updateQuality() {
        for i in 0 ..< items.count {
            switch depreciation(of: items[i]) {
            case .decreasing:
                if canQualityDecrease(item: items[i]) {
                    items[i].quality = items[i].quality - 1
                }
            case .increasing:
                if items[i].quality < 50 {
                    items[i].quality = items[i].quality + 1

                    handleBackStagePass(item: items[i])
                }
            case .same:
                break
            }

            if items[i].name != "Sulfuras, Hand of Ragnaros" {
                items[i].sellIn = items[i].sellIn - 1
            }

            if items[i].sellIn < 0 {
                if items[i].name != "Aged Brie" {
                    if items[i].name != "Backstage passes to a TAFKAL80ETC concert" {
                        if items[i].quality > 0 {
                            if items[i].name != "Sulfuras, Hand of Ragnaros" {
                                items[i].quality = items[i].quality - 1
                            }
                        }
                    } else {
                        items[i].quality = items[i].quality - items[i].quality
                    }
                } else {
                    if items[i].quality < 50 {
                        items[i].quality = items[i].quality + 1
                    }
                }
            }
        }
    }
}
