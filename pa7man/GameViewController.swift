//
//  GameViewController.swift
//  pa7man
//
//  Created by localadmin on 21.01.19.
//  Copyright © 2019 ch.cqd.pa7man. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit

private var gameViewController: UIViewController!

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authPlayer()
        
    }
    
    func authPlayer() {
        let localPlayer = GKLocalPlayer.local
        gameViewController = self
        
        localPlayer.authenticateHandler = {
            (view, error) in
            if view != nil {
                self.present(view!, animated: true, completion: nil)
            } else {
                if !GKLocalPlayer.local.isAuthenticated {
                    self.ask4GameCenter()
                } else {
                    self.gameOn()
                }
            }
        }
    }
    
    func gameOn() {
        if let skView = self.view as? SKView {
            if skView.scene == nil {
                let scene = GameScene(size: CGSize(width: self.view!.bounds.width * 2, height: self.view!.bounds.height * 2))
                skView.showsFPS = true
                skView.showsNodeCount = true
                skView.showsPhysics = true
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .aspectFill
                skView.presentScene(scene)
            }
        }
    }
    
    func ask4GameCenter() {
        let myAlert: UIAlertController = UIAlertController(title: "Attention", message: "Log into Game Center to record High Scores", preferredStyle: .alert)
        
        myAlert.addAction(UIAlertAction(title: "Ignore", style: .default, handler: { (action) in
            self.gameOn()
        }))
        myAlert.addAction(UIAlertAction(title: "Logon", style: .default, handler: { (action) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: { (success) in
                if success {
                    self.gameOn()
                }
            })
        }))
        self.view?.window?.rootViewController?.present(myAlert, animated: true, completion: nil)
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
