//
//  ViewController.swift
//  BetterTimer
//
//  Created by Myungji Choi on 31/01/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import UIKit


import SnapKit
import RxSwift
import RxCocoa

final class MainController: UIViewController {
  init(_ viewModel: MainViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  let viewModel: MainViewModel
  let disposeBag = DisposeBag()

  let defaultMargin: CGFloat = 24
  var isShownViewComponent: Bool = true

  var statusBarHidden = false {
    didSet {
      UIView.animate(withDuration: 2) {
        self.setNeedsStatusBarAppearanceUpdate()
      }
    }
  }

  var arcView: MainArcView?
  private lazy var timerLabel = UILabel().then {
    $0.textColor = .red
    $0.font = UIFont.systemFont(ofSize: 40, weight: .ultraLight)
    $0.textAlignment = .center
  }

  private lazy var restartButton = UIButton().then {
    $0.setTitle("Refresh", for: .normal)
    $0.setTitleColor(.red, for: .normal)
  }

  private lazy var preferenceButton = UIButton().then {
    $0.setTitle("Edit", for: .normal)
    $0.setTitleColor(.red, for: .normal)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    UIView.animateKeyframes(withDuration: 6,
                            delay: 0,
                            options: .calculationModeCubic,
                            animations: {
        UIView.addKeyframe(withRelativeStartTime: 0,
                           relativeDuration: 1.0 / 6.0) {
                            self.timerLabel.alpha = 1
                            self.restartButton.alpha = 1
                            self.preferenceButton.alpha = 1
                            self.statusBarHidden = false
        }

        UIView.addKeyframe(withRelativeStartTime: 2.0 / 6.0,
                           relativeDuration: 4.0 / 6.0) {
                            self.timerLabel.alpha = 0
                            self.restartButton.alpha = 0
                            self.preferenceButton.alpha = 0
                            self.statusBarHidden = true
        }
    })
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
    setupBinding()
  }

  func setupUI() {
    view.backgroundColor = .white
    view.addSubview(timerLabel)
    timerLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-220)
      $0.leading.equalToSuperview().offset(defaultMargin)
      $0.trailing.equalToSuperview().offset(-defaultMargin)
      $0.height.equalTo(30)
    }

    view.addSubview(restartButton)
    restartButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(defaultMargin)
      $0.trailing.equalToSuperview().offset(-defaultMargin)
      $0.top.equalTo(timerLabel.snp.bottom).offset(8)
      $0.height.equalTo(30)
    }

    view.addSubview(preferenceButton)
    preferenceButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(defaultMargin)
      $0.width.equalTo(60)
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-defaultMargin)
      $0.height.equalTo(44)
    }

    arcView = MainArcView(frame: CGRect.zero)
    view.addSubview(arcView!)
    arcView?.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(defaultMargin)
      $0.trailing.equalToSuperview().offset(-defaultMargin)
      $0.centerY.equalToSuperview()
      $0.height.equalTo(arcView!.snp.width)
    }
    statusBarHidden = true
  }

  func setupBinding() {
    restartButton.rx.tap
      .subscribe(viewModel.restartSubject)
      .disposed(by: disposeBag)

    preferenceButton.rx.tap
      .subscribe(viewModel.preferenceSubject)
      .disposed(by: disposeBag)

    viewModel.currentTime
      .bind(to: timerLabel.rx.text)
      .disposed(by: disposeBag)

    viewModel.timer
      .subscribe(onNext: {
        print($0)
      }).disposed(by: disposeBag)
  }

  override func viewDidAppear(_ animated: Bool) {
    UIView.animate(withDuration: 4) {
      self.timerLabel.alpha = 0
      self.restartButton.alpha = 0
      self.preferenceButton.alpha = 0
    }
  }
}

extension MainController {
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }

  override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
    return .fade
  }

  override var prefersStatusBarHidden: Bool {
    return statusBarHidden
  }
}
