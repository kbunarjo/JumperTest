//
//  PlatformerScene.swift
//  JumperTest
//
//  Created by Kevin Bunarjo on 10/25/20.
//

import CoreMotion
import SpriteKit

protocol PlatformerSceneDelegate: AnyObject {
    func updateScore(to score: Int)
    func didEndGame()
}

final class PlatformerScene: SKScene {
    private enum Constants {
        static let avatarLength: CGFloat = 85
        static let heightWithMaxPlatformSpacing: CGFloat = 20000
        static let initialPlatformSpacing: CGFloat = 100
        static let maximumAdditionalPlatformSpacing: CGFloat = 100
    }

    enum Categories {
        static let avatar: UInt32 = 1 << 0
        static let branch: UInt32 = 1 << 1
    }

    private let foregroundNode = SKNode()

    private lazy var avatarNode: SKSpriteNode = {
        let node = SKSpriteNode()
        node.color = .green
        node.name = "avatar"
        let width: CGFloat = Constants.avatarLength
        let height: CGFloat = Constants.avatarLength

        node.size = CGSize(width: width, height: height)
        node.position = CGPoint(x: size.width / 2, y: 80.0)
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.restitution = 1.0
        node.physicsBody?.friction = 0.0
        node.physicsBody?.angularDamping = 0.0
        node.physicsBody?.linearDamping = 0.0
        node.physicsBody?.usesPreciseCollisionDetection = true
        node.physicsBody?.categoryBitMask = Categories.avatar
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.contactTestBitMask = Categories.branch
        return node
    }()

    weak var platformerDelegate: PlatformerSceneDelegate?

    private let motionManager = CMMotionManager()
    private var xAcceleration: CGFloat = 0.0
    private lazy var scaleFactor = size.width / 320.0

    private var tallestPlatformHeight: CGFloat = 1220
    private var currentPlatformSpacing: CGFloat = 100
    override init(size: CGSize) {
        super.init(size: size)

        physicsWorld.gravity = CGVector(dx: 0.0, dy: -3.0)
        physicsWorld.contactDelegate = self

        let firstPlatformHeight: CGFloat = 320
        createPlatformAtHeight(yValue: firstPlatformHeight, type: .normal)
        createPlatformAtHeight(yValue: firstPlatformHeight + Constants.initialPlatformSpacing, type: .normal)
        createPlatformAtHeight(yValue: firstPlatformHeight + Constants.initialPlatformSpacing * 2, type: .normal)
        createPlatformAtHeight(yValue: firstPlatformHeight + Constants.initialPlatformSpacing * 3, type: .normal)
        createPlatformAtHeight(yValue: firstPlatformHeight + Constants.initialPlatformSpacing * 4, type: .normal)
        createPlatformAtHeight(yValue: firstPlatformHeight + Constants.initialPlatformSpacing * 5, type: .normal)
        createPlatformAtHeight(yValue: firstPlatformHeight + Constants.initialPlatformSpacing * 6, type: .normal)
        createPlatformAtHeight(yValue: firstPlatformHeight + Constants.initialPlatformSpacing * 7, type: .normal)
        createPlatformAtHeight(yValue: firstPlatformHeight + Constants.initialPlatformSpacing * 8, type: .normal)
        createPlatformAtHeight(yValue: firstPlatformHeight + Constants.initialPlatformSpacing * 9, type: .normal)

        setupViews()
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { accelerometerData, error in
            self.xAcceleration = (CGFloat(accelerometerData?.acceleration.x ?? 0) * 0.75) + (self.xAcceleration * 0.25)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // If we're already playing, ignore touches
        if avatarNode.physicsBody!.isDynamic {
            return
        }
        // Start the player by putting them into the physics simulation
        avatarNode.physicsBody?.isDynamic = true
        avatarNode.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 175))
    }

    private var score: Int = 0 {
        didSet {
            platformerDelegate?.updateScore(to: score)
        }
    }
    private var maxPlayerY: CGFloat = 80
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)

        // Update the score.
        if avatarNode.position.y > maxPlayerY {
            score += Int(avatarNode.position.y - maxPlayerY)
            maxPlayerY = avatarNode.position.y
        }

        // Calculate player y offset
        if (avatarNode.position.y - foregroundNode.position.y) > 0 {
            foregroundNode.position = CGPoint(x: 0.0, y: -(avatarNode.position.y - 200.0))
        }

        // Check if the user has lost
        if avatarNode.position.y < maxPlayerY - 400 {

            self.view?.isPaused = true

        }

        // Add new platforms if necessary
        if tallestPlatformHeight - maxPlayerY < 1000 {
            let percentOfGettingBreakableBranch = 0.9 * min(maxPlayerY / Constants.heightWithMaxPlatformSpacing, 1)
            let spacing = Constants.initialPlatformSpacing + min(maxPlayerY / Constants.heightWithMaxPlatformSpacing, 1) * Constants.maximumAdditionalPlatformSpacing
            
            createPlatformAtHeight(yValue: tallestPlatformHeight + spacing, type: randomBooleanWith(chance: percentOfGettingBreakableBranch) ? .breakable : .normal)
            createPlatformAtHeight(yValue: tallestPlatformHeight + 2 * spacing, type: randomBooleanWith(chance: percentOfGettingBreakableBranch) ? .breakable : .normal)

            tallestPlatformHeight += 2 * spacing

            // Remove any uncessecary platforms
            foregroundNode.children.forEach {
                if let objectNode = $0 as? PlatformerObjectNode {
                    objectNode.checkNodeRemoval(playerY: maxPlayerY)
                }
            }
        }
    }

    private func randomBooleanWith(chance: CGFloat) -> Bool {
        let randomValue = arc4random_uniform(100)
        return randomValue < Int(chance * 100)
    }

    override func didSimulatePhysics() {
        // Set velocity based on x-axis acceleration
        avatarNode.physicsBody?.velocity = CGVector(dx: xAcceleration * 800.0, dy: avatarNode.physicsBody!.velocity.dy)
        // Check x bounds
        if avatarNode.position.x < -20.0 {
            avatarNode.position = CGPoint(x: self.size.width + 20.0, y: avatarNode.position.y)
        } else if (avatarNode.position.x > self.size.width + 20.0) {
            avatarNode.position = CGPoint(x: -20.0, y: avatarNode.position.y)
        }
    }

    private func setupViews() {
        addChild(foregroundNode)

        foregroundNode.addChild(avatarNode)
    }

    private func createPlatformAtHeight(yValue: CGFloat, type: BranchNode.BranchType) {
        let xValueBounds = (BranchNode.size.width / 2)..<(size.width - BranchNode.size.width / 2)
        let randomXValue = CGFloat.random(in: xValueBounds)
        let node = BranchNode(branchType: type)
        let scaledPosition = CGPoint(x: randomXValue, y: yValue)
        node.position = scaledPosition
        node.name = "NODE_PLATFORM"

        // 3
        node.physicsBody = SKPhysicsBody(rectangleOf: BranchNode.size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = Categories.branch
        node.physicsBody?.collisionBitMask = 0

        foregroundNode.addChild(node)
    }
}

extension PlatformerScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        // 2
        let whichNode = (contact.bodyA.node != avatarNode) ? contact.bodyA.node : contact.bodyB.node
        let other = whichNode as! PlatformerObjectNode
        
        // 3
        other.collisionWithPlayer(avatarNode)
    }
}
