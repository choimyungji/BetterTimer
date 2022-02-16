//
//  MainView.swift
//  BetterTimer
//
//  Created by Myungji Choi on 2020/09/08.
//  Copyright © 2020 Myungji Choi. All rights reserved.
//

import Foundation

import SwiftUI
import Combine

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var showModal = false //상태

    var body: some View {
        MainArcShape(degree: $viewModel.degree)
            .foregroundColor(.red)
            .onAppear {
                viewModel.start()
            }
            .padding()
        Text("\(viewModel.seconds)")
        Button(action: {
            self.showModal = true
        }) {
            Image(systemName: "gearshape")
        }
        .sheet(isPresented: self.$showModal) {
                        PreferenceView()
        }
    }
}

struct MainArcShape: Shape {
    @Binding var degree: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.maxX / 2, y: rect.maxY / 2),
                    radius: (rect.width - (46 * 2)) / 2,
                    startAngle: .degrees(-90),
                    endAngle: .degrees(degree-90),
                    clockwise: false)

        return path
            .strokedPath(StrokeStyle(lineWidth: 100))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}
