//
//  GameOver.swift
//  Tappity Tap
//
//  Created by user150450 on 4/8/19.
//  Copyright © 2019 FROG. All rights reserved.
//

import Foundation
import SpriteKit
class GameOverScene: SKScene{
    let won: Bool
    
    init(size: CGSize, won: Bool){
        self.won = won
        super.init(size: size)
    }
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView){
        //looks at the won bool and chooses the winning or loosing image
        //and sound to play
        var background: SKSpriteNode
        background = SKSpriteNode(imageNamed: "GameOver")
        
        
        background.position =
            CGPoint(x: size.width/2, y: size.height/2)
        self.addChild(background)
        
        //after 3 seconds it calls a block of code
        //that creates a new instance of GameScene and transitions
        let wait = SKAction.wait(forDuration: 3.0)
        let block = SKAction.run{
            let myScene = GameScene(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        self.run(SKAction.sequence([wait, block]))
    }
}
