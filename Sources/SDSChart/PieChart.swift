//
//  PieChart.swift
//
//  Created by : Tomoaki Yagishita on 2021/12/02
//  © 2021  SmallDeskSoftware
//

import SwiftUI

public class PieChartData: ObservableObject, Identifiable {
    public let id: UUID
    @Published public var pieChartAngles: [PieChartPieceData]
    
    @Published public var scale: CGVector
    
    init(_ pieChartAngles: [PieChartPieceData], scale: CGVector = .scaleOne) {
        self.id = UUID()
        self.pieChartAngles = pieChartAngles
        self.scale = scale
    }
    
    public func arcAngles(_ angle: PieChartPieceData) -> (start: Angle, end: Angle)? {
        if let index = pieChartAngles.firstIndex(where: {$0.id == angle.id}) {
            var retAngle = Angle(degrees: 0)
            for idx in 0..<index {
                retAngle += pieChartAngles[idx].angle
            }
            return (retAngle, retAngle + angle.angle)
        }
        return nil
    }
}

public struct PieChartPieceData: Identifiable {
    public enum ExpandInfo {
        case none
        case expand(amount: CGFloat)
    }
    
    public let id: UUID
    public let angle: Angle
    public let color: Color
    public var offset: Bool
    public var expand: ExpandInfo

    init(_ angle: Angle, color: Color, offset: Bool = false, expand: ExpandInfo = .none) {
        self.id = UUID()
        self.angle = angle
        self.color = color
        self.offset = offset
        self.expand = expand
    }
}

extension PieChartData {
    static func sample() -> PieChartData {
        return PieChartData([PieChartPieceData(Angle(degrees: 15), color: Color.red),
                             PieChartPieceData(Angle(degrees: 20), color: Color.blue),
                             PieChartPieceData(Angle(degrees: 40), color: Color.green, offset: false),
                             PieChartPieceData(Angle(degrees: 25), color: Color.cyan)
                            ])
    }


}
public struct PieChart: View {
    @ObservedObject var chartData: PieChartData

    let edgeInsets: EdgeInsets

    public init(_ chartData: PieChartData, edgeInsets: EdgeInsets = .zero) {
        self.chartData = chartData
        self.edgeInsets = edgeInsets
    }

    public var body: some View {
        ZStack {
            GeometryReader { geom in
                ForEach(chartData.pieChartAngles) { idAngle in
                    if let (start, end) = chartData.arcAngles(idAngle) {
                        piePath(center: geomCenter(geom), radius: radiusFromGeomAndExpand(idAngle, geom:geom), start: start, end: end)
                            .fill(idAngle.color)
                            .offset(idAngle.offset ? arcOffset(center: geomCenter(geom), radius: geomRadius(geom),
                                                               start: start, end: end) : CGSize.zero)
                    }
                }
                .padding(edgeInsets)
                .debugBorder(.orange, width: 4)
            }
            .padding(0)
        }
    }
    
    func geomCenter(_ geom: GeometryProxy) -> CGPoint {
        return CGPoint(x: geom.size.width / 2.0, y: geom.size.height / 2.0)
    }
    func radiusFromGeomAndExpand(_ pieChartPiece: PieChartPieceData, geom: GeometryProxy) -> CGFloat {
        let value = min(geom.size.width / 2.0, geom.size.height / 2.0) * 0.95
        switch pieChartPiece.expand {
        case .none:
            return value
        case .expand(let amount):
            return value + amount
        }
    }
    func geomRadius(_ geom: GeometryProxy) -> CGFloat {
        return min(geom.size.width / 2.0, geom.size.height / 2.0) * 0.95
    }
    
    func arcOffset(center: CGPoint, radius: CGFloat, start: Angle, end: Angle) -> CGSize {
        let midAngleHalfRadiusPoint = arcEnd(center: center, radius: radius, angle: (start + end) / 2.0  - Angle(degrees: 90)).diffVectorFrom(center).scale(0.3)
        return midAngleHalfRadiusPoint.cgSize()
    }

    // note: angle starts from 12-o'clock with clockwise
    func piePath(center: CGPoint, radius: CGFloat, start: Angle, end: Angle) -> Path {
        var path = Path()
        path.move(to: center)
        path.addLine(to: arcEnd(center: center, radius: radius, angle: start - Angle(degrees: 90)))
        path.addArc(center: center, radius: radius, startAngle: start - Angle(degrees: 90), endAngle: end - Angle(degrees: 90), clockwise: false)
        path.addLine(to: center)
        return path
    }
    
    func arcEnd(center: CGPoint, radius: CGFloat, angle: Angle) -> CGPoint {
        let newX = center.x + radius * cos(angle.radians)
        let newY = center.y + radius * sin(angle.radians)
        return CGPoint(x: newX, y: newY)
    }
    
}
