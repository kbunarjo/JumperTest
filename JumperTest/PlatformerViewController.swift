//
//  PlatformerViewController.swift
//  JumperTest
//
//  Created by Kevin Bunarjo on 10/25/20.
//

import SpriteKit
import UIKit

final class PlatformerViewController: UIViewController {
    private enum Constants {
        static let maxSpeed: CGFloat = 30
        static let doterImageLength: CGFloat = 80
    }
    private lazy var gameView = PlatformerGameView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))

    private var timer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(gameView)

//        motionManager.startAccelerometerUpdates()
//        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateGameFrame), userInfo: nil, repeats: true)
//
//        view.addSubview(doterImage)
//        doterImage.frame = CGRect(x: view.bounds.width / 2 - Constants.doterImageLength / 2,
//                                  y: view.bounds.width * (3 / 4) - Constants.doterImageLength / 2,
//                                  width: Constants.doterImageLength,
//                                  height: Constants.doterImageLength)
//        doterImage.backgroundColor = .green
    }

//    @objc private func updateGameFrame() {
//        updateCharacterTiltPosition()
//    }
//
//    private func updateCharacterTiltPosition() {
//        guard let accelerometerData = motionManager.accelerometerData else { return }
//
//        let xDelta = CGFloat(accelerometerData.acceleration.x) * Constants.maxSpeed
//        let newXPosition = doterImage.frame.minX + xDelta
//        guard newXPosition >= 0 && (newXPosition + doterImage.bounds.width) <= view.bounds.width else { return }
//
//        doterImage.frame = CGRect(x: newXPosition,
//                                  y: doterImage.frame.minY,
//                                  width: doterImage.frame.width,
//                                  height: doterImage.frame.height)
//    }
}

