//
//  PolylineView.swift
//
//  Created by : Tomoaki Yagishita on 2021/12/02
//  © 2021  SmallDeskSoftware
//

import SwiftUI

struct PolylineView: View {
    @ObservedObject var polylineData:PolylineChartData

    let labelOffset: CGVector = CGVector(dx: -5, dy: -10)
    
    init(_ polylineData: PolylineChartData) {
        self.polylineData = polylineData
    }
    
    var body: some View {
        GeometryReader { geom in
            ZStack {

                // x-axis
                if polylineData.showXAxis {
                    xAxisPath(size: geom.size)
                        .stroke(lineWidth: 4)
                        .fill(Color.blue)
                    ForEach(polylineData.xAxisLabelPos) { xPos in
                        if let labelString = polylineData.xAxisLabelFormatter?(xPos) {
                            Text(labelString)
                                .font(.caption)
                                .position(axisLabelPos(xPos, height: geom.size.height))
                        }
                    }
                }
                
                // y-axis
                if polylineData.showYAxis {
                    yAxisPath(size: geom.size)
                        .stroke(lineWidth: 4)
                        .fill(Color.green)
                    ForEach(polylineData.yAxisLabelPos) { yPos in
                        if let labelString = polylineData.yAxisLabelFormatter?(yPos) {
                            Text(labelString)
                                .rotationEffect(Angle(degrees: -90))
                                .font(.caption)
                                .position(axisLabelPos(yPos, height: geom.size.height))
                        }
                    }
                }

                // data path
                path(geom.size.height)
                    .stroke(lineWidth: 3.0)
                    .fill(polylineData.lineColor)
                    .clipped()
                
                // label on data point
                ForEach(polylineData.idPoints) { point in
                    if let labelString = polylineData.pointLabelFormatter?(point) {
                        Rectangle()
                            .fill(Color.red)
                            .help(labelString)
                            .frame(width: 5, height: 5)
                            .position(calcPos(point.point, height: geom.size.height))
                        Text(labelString)
                            .font(.caption)
                            .position(labelPosForPoint(point, height: geom.size.height))
                    } else {
                        Rectangle()
                            .fill(Color.red)
                            .frame(width: 5, height: 5)
                            .position(calcPos(point.point, height: geom.size.height))
                    }
                }
            }
        }
    }
    
    func xAxisPath(size: CGSize) -> Path {
        Path { path in
            path.move(to: calcLocOnGraphWithoutScale(CGPoint(x: 0, y: 0), height: size.height))
            path.addLine(to: calcLocOnGraphWithoutScale( CGPoint(x: size.width, y: 0), height: size.height ))
        }
    }
    func yAxisPath(size: CGSize) -> Path {
        Path { path in
            path.move(to: calcLocOnGraphWithoutScale(CGPoint(x: 0, y: 0), height: size.height))
            path.addLine(to: calcLocOnGraphWithoutScale( CGPoint(x: 0, y: size.height), height: size.height))
        }
    }

    func path(_ height: CGFloat) -> Path {
        var localPath = Path()
        guard let firstPoint = polylineData.idPoints.first?.point else { return localPath }
        localPath.move(to: calcPos(firstPoint, height: height))
        if polylineData.idPoints.count < 2 { return localPath }
        for index in 1..<polylineData.idPoints.count {
            localPath.addLine(to: calcPos(polylineData.idPoints[index].point, height: height))
        }
        return localPath
        
    }
    func calcPos(_ pos: CGPoint, height: CGFloat) -> CGPoint {
        return CGPoint(x: pos.x * polylineData.scale.dx, y: pos.y * -1 * polylineData.scale.dy + height)
    }
    
    func axisLabelPos(_ pos: IdentifiablePoint, height: CGFloat) -> CGPoint {
        return CGPoint(x: pos.point.x * polylineData.scale.dx, y: pos.point.y * -1 * polylineData.scale.dy + height)
    }

    func labelPosForPoint(_ pos: IdentifiablePoint, height: CGFloat) -> CGPoint {
        return CGPoint(x: pos.point.x * polylineData.scale.dx + labelOffset.dx, y: pos.point.y * -1 * polylineData.scale.dy + height - labelOffset.dy)
    }

    func calcLocOnGraphWithoutScale(_ pos: CGPoint, height: CGFloat) -> CGPoint {
        return CGPoint(x: pos.x, y: pos.y * -1 + height)
    }

}
