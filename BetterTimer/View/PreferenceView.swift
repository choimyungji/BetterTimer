//
//  PreferenceView.swift
//  BetterTimer
//
//  Created by Myungji Choi on 2022/02/13.
//  Copyright © 2022 Myungji Choi. All rights reserved.
//

import SwiftUI

struct PreferenceView: View {
    @State var minutes: String = String(format: "%.0f", Preference.shared.userDefinedTimeInterval / 60)
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark").foregroundColor(.red)
            })
            }
            Text("시간")
                .font(.title)
            HStack {
                TextField("시간을 분단위로 입력해 주세요.", text: $minutes)
                    .textFieldStyle(.roundedBorder)
                Text("분")
            }
            Spacer()
            Button(action: {
                if let time = Double(minutes) {
                    Preference.shared.userDefinedTimeInterval = time * 60
                }
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("완료")
            })
                .frame(maxWidth: .infinity, minHeight: 48, alignment: .center)
                .foregroundColor(.white)
                .background(Color.red)

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
