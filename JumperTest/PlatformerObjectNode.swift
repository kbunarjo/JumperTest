//
//  PlatformerObjectNode.swift
//  JumperTest
//
//  Created by Kevin Bunarjo on 10/25/20.
//

import SpriteKit

class PlatformerObjectNode: SKNode {
    func collisionWithPlayer(_ player: SKNode) { }
    func checkNodeRemoval(playerY: CGFloat) {
        if playerY > self.position.y + 300.0 {
            self.removeFromParent()
        }
    }
}

final class BranchNode: PlatformerObjectNode {
    static let size = CGSize(width: UIScreen.main.bounds.width * 0.15, height: 20)
    enum BranchType: Int {
        case normal = 0
        case breakable
    }

    private let branchType: BranchType
    init(branchType: BranchType) {
        self.branchType = branchType
        let sprite: SKSpriteNode = {
            switch branchType {
            case .breakable:
                return SKSpriteNode(color: .white, size: Self.size)
            case .normal:
                return SKSpriteNode(color: .brown, size: Self.size)
            }
        }()
        super.init()
        addChild(sprite)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func collisionWithPlayer(_ player: SKNode) {
        // 1
        // Only bounce the player if they're falling
        if player.physicsBody?.velocity.dy ?? 0 < 0 {
            // 2
            player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: 440.0)

            // Remove if it is a Break type platform
            switch branchType {
            case .breakable:
                self.removeFromParent()
            case .normal:
                break
            }
        }
    }
}
