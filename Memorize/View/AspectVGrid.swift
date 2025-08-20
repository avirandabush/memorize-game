//
//  AspectVGrid.swift
//  Memorize
//
//  Created by aviran dabush on 28/09/2022.
//

import SwiftUI

struct AspectVGrid<Item, ItemView>: View where ItemView: View, Item: Identifiable {
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView

    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width: CGFloat = widthThatFits(itemCount: items.count, in: geometry.size, itemAcpectRatio: aspectRatio)
            LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0) {
                ForEach(items) { item in
                    content(item).aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
        }
    }
    
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    private func widthThatFits(itemCount: Int, in size: CGSize, itemAcpectRatio: CGFloat) -> CGFloat {
        var columncount = 1
        var rowCount = itemCount
        repeat {
            let itemWidth = size.width / CGFloat(columncount)
            let itemHeight = itemWidth / itemAcpectRatio
            
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            columncount += 1
            rowCount = (itemCount + (columncount-1)) / columncount
        } while columncount < itemCount
        if columncount > itemCount {
            columncount = itemCount
        }
        return floor(size.width / CGFloat(columncount))
    }
}

//struct AspectVGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        AspectVGrid()
//    }
//}
