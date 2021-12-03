//
//  Charts.swift
//
//  Created by : Tomoaki Yagishita on 2021/09/16
//  © 2021  SmallDeskSoftware
//

import SwiftUI
import SDSCGExtension
import SwiftUIDebugUtil

public class MultiPolylineData: ObservableObject {
    @Published public var polylineGraphData: [PolylineChartData]
    
    public init(_ data: [PolylineChartData]) {
        self.polylineGraphData = data
    }
}

public struct MultiPolylineChart: View {
    @ObservedObject var chartData: MultiPolylineData
    let edgeInsets: EdgeInsets

    public init(_ chartData: MultiPolylineData, edgeInsets: EdgeInsets = .zero) {
        self.chartData = chartData
        self.edgeInsets = edgeInsets
    }

    public var body: some View {
        ZStack {
            GeometryReader { geom in
                ForEach(chartData.polylineGraphData) { polylinePnt in
                    PolylineView(polylinePnt)
                }
                .padding(edgeInsets)
            }
        }
    }
}

extension EdgeInsets {
    public static var zero = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
}




