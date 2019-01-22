//
//  GameScene.swift
//  pa7man
//
//  Created by localadmin on 21.01.19.
//  Copyright © 2019 ch.cqd.pa7man. All rights reserved.
//
// mazeMan

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, touchMe, SKPhysicsContactDelegate {
    
    struct PhysicsCat {
        static let rien: UInt32 = 0
        static let pacMan: UInt32 = 0b1
        static let mazeMan: UInt32 = 0b1 << 1
    }
    
    struct ObjectSpace {
        static let base: CGFloat = 0
        static let rings: CGFloat = 1
        static let doors: CGFloat = 2
        static let player: CGFloat = 4
    }
    
    var manager: CMMotionManager!
    
    func spriteTouched(box: TouchableSprite) {
        print("ouch")
    }
    
    
    var pacman: TouchableSprite?
    var maze: TouchableSprite?
    
    override func didMove(to view: SKView){
        let texture2U = SKTexture(imageNamed: "pacman-png-15.png")
        pacman = TouchableSprite(texture: texture2U, color: UIColor.yellow, size: CGSize(width: 50, height: 50))
        pacman?.position = CGPoint(x: self.view!.bounds.maxX, y: self.view!.bounds.maxY)
        pacman?.delegate = self
        
        pacman?.physicsBody = SKPhysicsBody.init(circleOfRadius: 25 )
        pacman?.physicsBody?.categoryBitMask = PhysicsCat.pacMan
        pacman?.physicsBody?.collisionBitMask = PhysicsCat.mazeMan
        pacman?.physicsBody?.contactTestBitMask = PhysicsCat.pacMan | PhysicsCat.mazeMan
        pacman?.physicsBody?.affectedByGravity = false
        pacman?.zPosition = ObjectSpace.player
        
        addChild(pacman!)
        
        manager = CMMotionManager()
        if manager.isAccelerometerAvailable {
            manager.startDeviceMotionUpdates()
        }
        
//        var path = CGMutablePath()
//        let center = CGPoint(x: 0, y: 0)
//        path.move(to: center)
//        let p1 = CGPoint(x: 0, y: self.view!.frame.height)
//        let p2 = CGPoint(x: self.view!.frame.width, y: 0)
//        let endP = CGPoint(x: self.view!.frame.width, y: 256)
//        path.addCurve(to: endP, control1: p1, control2: p2)
////        path.addLine(to: endP)
//
//        let shape = SKShapeNode()
//        shape.path = path
//        shape.strokeColor = UIColor.red
//        shape.lineWidth = 2
//        shape.zPosition = 1
//
//        let texture = view.texture(from: shape)
//
//        shape.physicsBody = SKPhysicsBody(edgeChainFrom: path)
//        shape.physicsBody?.categoryBitMask = PhysicsCat.mazeMan
//        shape.physicsBody?.collisionBitMask = PhysicsCat.pacMan
//        shape.physicsBody?.contactTestBitMask = PhysicsCat.pacMan | PhysicsCat.mazeMan
//        shape.physicsBody?.affectedByGravity = false
//        addChild(shape)
        
        
        let centralP = CGPoint(x: self.view!.bounds.maxX, y: self.view!.bounds.maxY)
        let bend:CGFloat = 64
        let door: CGFloat = 64
        let sizeV: CGFloat = 96
        var prandomValue:Int = 0
        var randomValue:Int
        
        let randomSource = GKARC4RandomSource()
        let randomDistribution = GKRandomDistribution(randomSource: randomSource, lowestValue: 0, highestValue: 3)
        
        for loop in 1...8 {
            
        let tweek = CGFloat(loop)
        repeat {
            randomValue = randomDistribution.nextInt()
        } while randomValue == prandomValue
        prandomValue = randomValue
        print("randomV \(randomValue)")
        
        let sP = CGPoint(x: centralP.x, y: centralP.y + sizeV * tweek)
        let eP = CGPoint(x: centralP.x + sizeV * tweek, y: centralP.y)
        let cP = CGPoint(x: centralP.x + (bend * tweek), y: centralP.y + (bend * tweek))
            if randomValue != 0 {
                circleSlice(startP: sP, endP: eP, controlP: cP, color: nil)
            } else {
                let eP = CGPoint(x: centralP.x + sizeV * tweek, y: centralP.y + door)
                let cP = CGPoint(x: centralP.x + (bend * tweek), y: centralP.y + (bend * tweek))
                circleSlice(startP: sP, endP: eP, controlP: cP, color: UIColor.blue)
            }
        
        let sP2 = eP
        let eP2 = CGPoint(x: centralP.x, y: centralP.y - sizeV * tweek)
        let cP2 = CGPoint(x: centralP.x + (bend * tweek), y: centralP.y - (bend * tweek))
            if randomValue != 1 {
                circleSlice(startP: sP2, endP: eP2, controlP: cP2, color: nil)
            } else {
                let eP2 = CGPoint(x: centralP.x + door, y: centralP.y - sizeV * tweek)
                let cP2 = CGPoint(x: centralP.x + (bend * tweek), y: centralP.y - (bend * tweek) + door)
                circleSlice(startP: sP2, endP: eP2, controlP: cP2, color: UIColor.green)
            }
        let sP3 = eP2
        let eP3 = CGPoint(x: centralP.x - sizeV * tweek, y: centralP.y)
        let cP3 = CGPoint(x: centralP.x - (bend * tweek), y: centralP.y - (bend * tweek))
            if randomValue != 2 {
                circleSlice(startP: sP3, endP: eP3, controlP: cP3, color: nil)
            } else {
                let eP3 = CGPoint(x: centralP.x - sizeV * tweek, y: centralP.y - door)
                let cP3 = CGPoint(x: centralP.x - (bend * tweek) + door, y: centralP.y - (bend * tweek))
                circleSlice(startP: sP3, endP: eP3, controlP: cP3, color: UIColor.purple)
            }
        let sP4 = eP3
        let eP4 = sP
        let cP4 = CGPoint(x: centralP.x - (bend * tweek), y: centralP.y + (bend * tweek))
            if randomValue != 3 {
                circleSlice(startP: sP4, endP: eP4, controlP: cP4, color: nil)
            } else {
                let eP4 = CGPoint(x: centralP.x - door, y: centralP.y + sizeV * tweek)
                let cP4 = CGPoint(x: centralP.x - (bend * tweek) + door, y: centralP.y + (bend * tweek) )
                circleSlice(startP: sP4, endP: eP4, controlP: cP4, color: UIColor.yellow)
            }
        }
        
        physicsWorld.contactDelegate = self
    }
    
    func circleSlice(startP: CGPoint, endP: CGPoint, controlP: CGPoint, color: UIColor?)  {
//
        let beginBox = SKShapeNode(circleOfRadius: 10)
        beginBox.position = startP
        beginBox.fillColor = UIColor.purple
        beginBox.strokeColor = UIColor.purple
//
        let redBox = SKShapeNode(circleOfRadius: 10)
        redBox.position = controlP
        if color == nil {
            redBox.fillColor = UIColor.red
            redBox.strokeColor = UIColor.red
        } else {
            redBox.fillColor = color!
            redBox.strokeColor = color!
        }
//
        let endBox = SKShapeNode(circleOfRadius: 10)

        endBox.position = endP
        endBox.fillColor = UIColor.white
        endBox.strokeColor = UIColor.white
//

        addChild(beginBox)
        addChild(endBox)
        addChild(redBox)

        
        let line2 = UIBezierPath()
//        line2.move(to: beginBox.position)
//        line2.addCurve(to: endBox.position, controlPoint1: redBox.position, controlPoint2: blueBox.position)
        
        line2.move(to: beginBox.position)
        line2.addQuadCurve(to: endBox.position, controlPoint: redBox.position)
        
        let line2Dashed = SKShapeNode(path: line2.cgPath.copy(dashingWithPhase: 2, lengths: [4, 4]))
        line2Dashed.physicsBody = SKPhysicsBody(edgeChainFrom: line2.cgPath)
        line2Dashed.physicsBody?.categoryBitMask = PhysicsCat.mazeMan
        line2Dashed.physicsBody?.collisionBitMask = PhysicsCat.pacMan
        line2Dashed.physicsBody?.contactTestBitMask = PhysicsCat.pacMan | PhysicsCat.mazeMan
        line2Dashed.physicsBody?.affectedByGravity = false
        line2Dashed.zPosition = ObjectSpace.rings
        addChild(line2Dashed)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        let direct = manager.deviceMotion?.attitude
//        print("direct \(direct)")
        if direct != nil {
            if direct!.pitch > 0.1 || direct!.pitch < -0.1 {
                pacman?.position.x = (pacman?.position.x)! + CGFloat(direct!.pitch * 10)
            }
            if direct!.roll > 0.1 || direct!.roll < -0.1 {
                pacman?.position.y = (pacman?.position.y)! + CGFloat(direct!.roll * 10)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
//        print("contact \(contact)")
    }
}
