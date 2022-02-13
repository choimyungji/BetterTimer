//
//  PreferenceViewController.swift
//  BetterTimer
//
//  Created by Myungji Choi on 24/07/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import UIKit
import Then

class PreferenceController: UIViewController {
  let defaultMargin: CGFloat = 24

  private var timerLabel = UILabel().then {
    $0.text = "시간"
    $0.textColor = .black
    $0.font = UIFont.systemFont(ofSize: 17)
  }

  private var timerField = UITextField().then {
    $0.borderStyle = UITextField.BorderStyle.line
    $0.text = String(Preference.shared.userDefinedTimeInterval)
  }

  private var okButton = UIButton().then {
    $0.backgroundColor = .red
    $0.setTitle("완료", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.layer.cornerRadius = 4
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "설정"
    view.backgroundColor = .white
    view.addSubview(timerLabel)
    timerLabel.frame = CGRect(x: defaultMargin, y: 120, width: 100, height: 22)

    view.addSubview(timerField)
    let width = UIScreen.main.bounds.width - (defaultMargin * 2)
    timerField.frame = CGRect(x: defaultMargin, y: timerLabel.frame.maxY, width: width, height: 44)

    view.addSubview(okButton)
    okButton.frame = CGRect(x: defaultMargin,
                            y: UIScreen.main.bounds.height - 44 - defaultMargin,
                            width: width,
                            height: 44)
  }
}
