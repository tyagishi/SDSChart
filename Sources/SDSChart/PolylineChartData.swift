//
//  GraphData.swift
//
//  Created by : Tomoaki Yagishita on 2021/11/29
//  © 2021  SmallDeskSoftware
//

import Foundation
import CoreGraphics
import SDSCGExtension
import SwiftUI

// note:PolylineGraphData have data for one polyline
public class PolylineChartData: ObservableObject, Identifiable {
    public let id: UUID
    @Published public var idPoints:[IdentifiablePoint]
    @Published public var showXAxis: Bool
    @Published public var showYAxis: Bool
    let xAxisLabelPos: [IdentifiablePoint]
    let yAxisLabelPos: [IdentifiablePoint]

    public var scale: CGVector

    let lineColor: Color
    let pointLabelFormatter: ((IdentifiablePoint) -> String)?
    let xAxisLabelFormatter: ((IdentifiablePoint) -> String)?
    let yAxisLabelFormatter: ((IdentifiablePoint) -> String)?

    public init(_ points: [IdentifiablePoint] = [],
                lineColor: Color = .orange,
                scale: CGVector = .scaleOne,
                pointLabelFormatter: ((IdentifiablePoint) -> String)? = nil,
                showXAxis: Bool = true,
                xAxisLabelPos: [IdentifiablePoint] = [],
                xAxisLabelFormatter: ((IdentifiablePoint) -> String)? = nil,
                showYAxis: Bool = true,
                yAxisLabelPos: [IdentifiablePoint] = [],
                yAxisLabelFormatter: ((IdentifiablePoint) -> String)? = nil
    ) {
        id = UUID()
        self.idPoints = points
        self.lineColor = lineColor
        self.scale = scale
        self.pointLabelFormatter = pointLabelFormatter
        self.showXAxis = showXAxis
        self.xAxisLabelPos = xAxisLabelPos
        self.xAxisLabelFormatter = xAxisLabelFormatter
        self.showYAxis = showYAxis
        self.yAxisLabelPos = yAxisLabelPos
        self.yAxisLabelFormatter = yAxisLabelFormatter
    }
}

public struct IdentifiablePoint: Identifiable {
    public let id: UUID
    public let point: CGPoint

    init(_ point: CGPoint) {
        self.id = UUID()
        self.point = point
    }
    init(x: CGFloat,y: CGFloat) {
        self.id = UUID()
        self.point = CGPoint(x: x, y: y)
    }
}
