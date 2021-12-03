//
//  PolylineChartData+Extension.swift
//
//  Created by : Tomoaki Yagishita on 2021/11/29
//  © 2021  SmallDeskSoftware
//

import Foundation
import SwiftUI

extension PolylineChartData {
    static public func sample() -> PolylineChartData {
        return PolylineChartData([IdentifiablePoint(x: 0.0, y: 20),
                                  IdentifiablePoint(x: 10.0, y: 26),
                                  IdentifiablePoint(x: 12, y: 18),
                                  IdentifiablePoint(x: 20, y: 0),
                                  IdentifiablePoint(x: 31, y: 60),
                                  IdentifiablePoint(x: 45, y: 34),
                                  IdentifiablePoint(x: 58, y: 90),
                                  IdentifiablePoint(x: 65, y: 76),
                                  IdentifiablePoint(x: 79, y: 88),
                                  IdentifiablePoint(x: 100, y: 100)],
                                 pointLabelFormatter: { idPoint in
            return String("Hello")
        })
    }
    static public func sampleScale215() -> PolylineChartData {
        return PolylineChartData([IdentifiablePoint(x: 0.0, y: 20),
                                  IdentifiablePoint(x: 10.0, y: 26),
                                  IdentifiablePoint(x: 12, y: 18),
                                  IdentifiablePoint(x: 20, y: 0),
                                  IdentifiablePoint(x: 31, y: 60),
                                  IdentifiablePoint(x: 45, y: 34),
                                  IdentifiablePoint(x: 58, y: 90),
                                  IdentifiablePoint(x: 65, y: 76),
                                  IdentifiablePoint(x: 79, y: 88),
                                  IdentifiablePoint(x: 100, y: 100)],
                                 lineColor: Color.blue,
                                 scale: CGVector(dx: 5.0, dy: 3),
                                 pointLabelFormatter: { idPoint in
            return String("at (\(idPoint.point.x),\(idPoint.point.y))")
        },
                                 showXAxis: true,
                                 xAxisLabelPos: [ IdentifiablePoint(x: 0, y: -3),
                                                  IdentifiablePoint(x: 50, y: -3),
                                                  IdentifiablePoint(x: 100, y: -3),
                                 ],
                                 xAxisLabelFormatter:  { idPoint in
            return String("\(idPoint.point.x)")
        },
                                 yAxisLabelPos: [ IdentifiablePoint(x: -2, y: 0),
                                                  IdentifiablePoint(x: -2, y: 50),
                                                  IdentifiablePoint(x: -2, y: 100),
                                 ],
                                 yAxisLabelFormatter:  { idPoint in
            return String("\(idPoint.point.y)")
        }
        )
    }
    static public func randomSample(_ num: Int) -> PolylineChartData {
        var points:[IdentifiablePoint] = []
        for index in 0..<20 {
            let sample = IdentifiablePoint(x: Double(index) * 10.0, y: Double.random(in: (0.0)..<(100.0)))
            points.append(sample)
        }
        return PolylineChartData(points)
    }
}
