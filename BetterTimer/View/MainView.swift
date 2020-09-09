//
//  MainView.swift
//  BetterTimer
//
//  Created by Myungji Choi on 2020/09/08.
//  Copyright © 2020 Myungji Choi. All rights reserved.
//

import Foundation

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State var degree: Double = 90

//    let viewModel: MainViewModel
//    init(_ degree: Double) {
//        self.degree = degree
//    }

    var body: some View {
        MainArcShape(degree: degree).foregroundColor(.red)
    }
}

struct MainArcShape: Shape {
    @State var degree: Double
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.maxX / 2, y: rect.maxY / 2),
                    radius: (rect.width - (46 * 2)) / 2,
                    startAngle: .degrees(90),
                    endAngle: .degrees(degree),
                    clockwise: true)

        return path
            .strokedPath(StrokeStyle(lineWidth: 100))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
