//
//  PreferenceViewController.swift
//  BetterTimer
//
//  Created by Myungji Choi on 24/07/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import UIKit

class PreferenceViewController: UIViewController {
  let defaultMargin: CGFloat = 24

  private var timerLabel: UILabel = {
    let label = UILabel()
    label.text = "시간"
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 17)
    return label
  }()

  private var timerField: UITextField = {
    let field = UITextField()
    field.borderStyle = UITextField.BorderStyle.line
    field.text = String(BTPreference.getInstance.userDefinedTimeInterval)
    return field
  }()

  private var okButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .red
    button.setTitle("완료", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 4
    return button
  }()

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
