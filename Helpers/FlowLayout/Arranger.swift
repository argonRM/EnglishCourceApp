//
//  Arranger.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 25.01.2024.
//

import SwiftUI

struct Arranger {
    var containerSize: CGSize
    var subviews: LayoutSubviews
    var spacing: CGFloat
    var alignment: Alignment
    
    func arrange() -> Result {
        var cells: [Cell] = []

        var maxY: CGFloat = 0
        var previousFrame: CGRect = .zero

        var groups: [[Cell]] = []
        var currentGroup: [Cell] = []

        for (index, subview) in subviews.enumerated() {
            let size = subview.sizeThatFits(ProposedViewSize(containerSize))

            var origin: CGPoint
            if index == 0 {
                origin = .zero
            } else if previousFrame.maxX + spacing + size.width > containerSize.width {
                origin = CGPoint(x: 0, y: maxY + spacing)
                groups.append(currentGroup)
                currentGroup = []
            } else {
                origin = CGPoint(x: previousFrame.maxX + spacing, y: previousFrame.minY)
            }

            let frame = CGRect(origin: origin, size: size)
            let cell = Cell(frame: frame)
            cells.append(cell)

            previousFrame = frame
            maxY = max(maxY, frame.maxY)

            if frame.origin.x == 0 {
                currentGroup = [cell]
            } else {
                currentGroup.append(cell)
            }
            
            if index == subviews.count - 1 {
                groups.append(currentGroup)
            }
        }

//        if alignment == .center {
//            for group in groups {
//                let totalWidth = group.reduce(0, { $0 + $1.frame.width + spacing })
//                let xOffset = (containerSize.width - totalWidth) / 2
//                
//                for i in group.indices {
//                    cells[cells.firstIndex(of: group[i])!].frame.origin.x += xOffset
//                }
//            }
//        }

        let maxWidth = cells.reduce(0, { max($0, $1.frame.maxX) })
        return Result(
            size: CGSize(width: maxWidth, height: previousFrame.maxY),
            cells: cells
        )
    }
}

extension Arranger {
    struct Result {
        var size: CGSize
        var cells: [Cell]
    }

    struct Cell: Equatable  {
        var frame: CGRect
    }
    
    enum Alignment {
        case leading
        case center
        
        init(alignment: FlowLayout.Alignment) {
            switch alignment {
            case .leading:
                self = .leading
            case .center:
                self = .center
            }
        }
    }
}
