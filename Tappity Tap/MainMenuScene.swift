//
//  MainMenu.swift
//  Tappity Tap
//
//  Created by user150450 on 4/1/19.
//  Copyright © 2019 FROG. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene{
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "TappityTap")
        //background.size = 
        background.position = CGPoint(x: size.width/2, y: size.width/2)
        self.addChild(background)
    }
    //transitions the main menu scene to the game scene after the scene is touched
    func sceneTapped(){
        let myScene = GameScene(size:self.size)
        myScene.scaleMode = scaleMode
        let reveal = SKTransition.doorway(withDuration:1.5)
        self.view?.presentScene(myScene, transition: reveal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneTapped()
    }
}

