//
//  PlatformerGameView.swift
//  JumperTest
//
//  Created by Kevin Bunarjo on 10/30/20.
//

import SpriteKit
import UIKit

final class PlatformerGameView: SKView {
    private let scoreLabel: UILabel = {
        let lab = UILabel()
        lab.text = "0"
        lab.textColor = .white
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()

    lazy var platformerScene = PlatformerScene(size: CGSize(width: bounds.width,
                                                            height: bounds.height))

    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        showsFPS = true
        showsNodeCount = true
        ignoresSiblingOrder = true

        platformerScene.scaleMode = .resizeFill
        platformerScene.platformerDelegate = self
        presentScene(platformerScene)

        addSubview(scoreLabel)
        scoreLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        scoreLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlatformerGameView: PlatformerSceneDelegate {
    func updateScore(to score: Int) {
        scoreLabel.text = numberFormatter.string(from: score as NSNumber)
    }

    func didEndGame() {
        //
    }
}
