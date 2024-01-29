//
//  FlowLayout.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 25.01.2024.
//

import SwiftUI

struct FlowLayout: Layout {
    var spacing: CGFloat
    var alignment: Alignment

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let arranger = Arranger(
            containerSize: proposal.replacingUnspecifiedDimensions(),
            subviews: subviews,
            spacing: spacing, alignment: Arranger.Alignment(alignment: alignment)
        )
        let result = arranger.arrange()
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let arranger = Arranger(
            containerSize: proposal.replacingUnspecifiedDimensions(),
            subviews: subviews,
            spacing: spacing, alignment: Arranger.Alignment(alignment: alignment)
        )
        let result = arranger.arrange()

        for (index, cell) in result.cells.enumerated() {
            let point = CGPoint(
                x: bounds.minX + cell.frame.origin.x,
                y: bounds.minY + cell.frame.origin.y
            )

            subviews[index].place(
                at: point,
                anchor: .topLeading,
                proposal: ProposedViewSize(cell.frame.size)
            )
        }
    }
    
    enum Alignment {
        case leading
        case center
    }
}
