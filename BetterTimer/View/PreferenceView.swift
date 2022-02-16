//
//  PreferenceView.swift
//  BetterTimer
//
//  Created by Myungji Choi on 2022/02/13.
//  Copyright © 2022 Myungji Choi. All rights reserved.
//

import SwiftUI

struct PreferenceView: View {
    @State var minutes: String = String(Preference.shared.userDefinedTimeInterval)
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
            })

            Text("시간")
                .font(.title)
            TextField("시간을 분단위로 입력해 주세요.", text: $minutes)
            Button(action: {
                if let time = Double(minutes) {
                    Preference.shared.userDefinedTimeInterval = time * 60
                }
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("완료")
            })
        }.frame(maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading)
            .padding()
    }
}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView()
    }
}
