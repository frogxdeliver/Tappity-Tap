//
//  MainMenu.swift
//  Tappity Tap
//
//  Created by user150450 on 4/1/19.
//  Copyright © 2019 FROG. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene{
    
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

