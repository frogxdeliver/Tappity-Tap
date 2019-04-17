//
//  GameScene.swift
//  Tappity Tap
//
//  Created by user150450 on 4/1/19.
//  Copyright © 2019 FROG. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var playerAlive = true
    var gameOver = false
    let playerMovePointsPerSec: CGFloat = 200
    var velocity = CGPoint.zero
    let adventurer = SKSpriteNode(imageNamed: "jump")
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    let cameraNode = SKCameraNode()
    let cameraMovePointsPerSec: CGFloat = 200.0
    let playableRect: CGRect
    var cameraRect : CGRect {
        let x = cameraNode.position.x - size.width/2 + (size.width - playableRect.width)/2
        let y = cameraNode.position.y - size.height/2 + (size.height - playableRect.height)/2
        return CGRect(x: x, y: y, width: playableRect.width, height: playableRect.height)
    }
    
    
    override func didMove(to view: SKView) {
        //16:9 aspect ratio
        /*let maxAspectRatio: CGFloat = 16.0/9.0
         let maxAspectRatioHeight = size.width / maxAspectRatio
         let playableMargin: CGFloat = (size.height - maxAspectRatioHeight)/2*/
        
        for i in 0...1 {
            let background = backgroundNode()
            background.anchorPoint = CGPoint.zero
            background.position =
                CGPoint(x: CGFloat(i)*background.size.width, y: 0)
            background.name = "background"
            background.zPosition = -1
            addChild(background)
            
            let floor = floorNode()
            floor.anchorPoint = CGPoint.zero
            floor.position = CGPoint(x:CGFloat(i)*floor.size.width, y:0)
            floor.name = "floor"
            floor.zPosition = 1
            addChild(floor)
        }
        adventurer.position = CGPoint(x: 500, y: 150)
        adventurer.setScale(2.5)
        addChild(adventurer)
        
        //let actionMove = SKAction.moveBy(x: size.width - adventurer.size.width, y: 0, duration: 25)
        
        //adventurer.run(SKAction.sequence([actionMove]))
        
        
        
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width/2, y: size.width/3.5)
        
    }
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else{
            dt = 0
        }
        lastUpdateTime = currentTime
        
        move(sprite: adventurer, velocity: CGPoint(x: playerMovePointsPerSec, y: 0))
        
        moveCamera()
        boundsCheck()
        
        //testing game over
        /*DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            self.gameOver = true
            print("GameOver")
            //create a new Scene
            let gameOverScene = GameOverScene(size: self.size, won: false)
            gameOverScene.scaleMode = self.scaleMode
            //transition to the new scene
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            //call the scene
            self.view?.presentScene(gameOverScene, transition: reveal)
        })*/
        
        if (!playerAlive && !gameOver){
            gameOver = true
            print("GameOver")
            //create a new Scene
            let gameOverScene = GameOverScene(size: size, won: false)
            gameOverScene.scaleMode = scaleMode
            //transition to the new scene
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            //call the scene
            view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    //used for the red box, animating, and error code
    override init(size: CGSize){
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin,
                              width: size.width,
                              height: playableHeight)
     
        super.init(size: size)
    }
    required init(coder aDecoder: NSCoder){
        fatalError("initi(coder:) has not been implemented") //6
    }
    
    
    //Creates the cycle from background1 to background2
    func backgroundNode() -> SKSpriteNode {
        //creating a SKSpriteNode (instead of a SKNode)  with no texture
        let backgroundNode = SKSpriteNode()
        backgroundNode.anchorPoint = CGPoint.zero
        backgroundNode.name = "background"
        
        //creates background1
        let background1 = SKSpriteNode(imageNamed: "background1")
        background1.anchorPoint = CGPoint.zero
        background1.position = CGPoint(x: 0, y: 0)
        backgroundNode.addChild(background1)
        
        //creates background2, which both will be used later in sequence
        let background2 = SKSpriteNode(imageNamed: "background2")
        background2.anchorPoint = CGPoint.zero
        background2.position =
            CGPoint(x: background1.size.width, y:0)
        backgroundNode.addChild(background2)
        
        //sets the backgroundNode based on the size of the 2 background images
        backgroundNode.size = CGSize(
            width: background1.size.width + background2.size.width,
            height: background1.size.height)
        return backgroundNode
    }
    
    func floorNode() -> SKSpriteNode {
        let floorNode = SKSpriteNode()
        floorNode.anchorPoint = CGPoint.zero
        floorNode.name = "floor"
        
        let floor1 = SKSpriteNode(imageNamed: "Jungle_Floor_1")
        floor1.anchorPoint = CGPoint.zero
        floor1.setScale(3.5)
        //Whereever the player is
        //floor1.position = CGPoint
        floorNode.addChild(floor1)
        
        let floor2 = SKSpriteNode(imageNamed: "Jungle_Floor_2")
        floor2.anchorPoint = CGPoint.zero
        floor2.setScale(3.5)
        floor2.position =
            CGPoint(x: floor1.size.width, y:0)
        floorNode.addChild(floor2)
        
        floorNode.size = CGSize(
            width: floor1.size.width + floor2.size.width,
            height: floor1.size.height)
        return floorNode
        
    }
    
    func moveCamera(){
        let backgroundVelocity = CGPoint(x: cameraMovePointsPerSec, y: 0)
        let amountToMove = backgroundVelocity * CGFloat(dt)
        cameraNode.position += amountToMove
        
        enumerateChildNodes(withName: "background") { node, _ in
            let background = node as! SKSpriteNode
            if background.position.x + background.size.width < self.cameraRect.origin.x {
                background.position = CGPoint(x: background.position.x + background.size.width*2, y: background.position.y)
            }
        }
        enumerateChildNodes(withName: "floor") { node, _ in
            let floor = node as! SKSpriteNode
            if floor.position.x + floor.size.width < self.cameraRect.origin.x {
                floor.position = CGPoint(x: floor.position.x + floor.size.width*2, y: floor.position.y)
            }
        }
    }
    
    /*
     //calculates the current visible playable area
     var cameraRect : CGRect{
     let x = cameraNode.position.x - size.width/2
     + (size.width - playableRect.width)/2
     let y = cameraNode.position.y - size.height/2
     + (size.height - playableRect.height)/2
     return CGRect(x: x,
     y: y,
     width: playableRect.width,
     height: playableRect.height)
     }*/
    
    //detect screen taps
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        jump()
    }
    
    //the adventurer jumps
    func jump(){
        let actionJump = SKAction.moveBy(x: 0, y: +200, duration: 0.8)
        let actionWait = SKAction.moveBy(x: 0, y: 0, duration: 0.8)
        let actionFall = SKAction.moveBy(x: 0, y: -200, duration: 0.8)
        adventurer.run(SKAction.sequence([actionJump]))
        adventurer.run(SKAction.sequence([actionWait, actionFall]))
    }
    
    func boundsCheck(){
        if adventurer.position.y >= 500{
            adventurer.position.y = 500
        }
        if adventurer.position.y < 150{
            adventurer.position.y = 150
        }
    }
    
    func spawnCoin(){
        let coin = SKSpriteNode(imageNamed: "coin")
        coin.name = "coin"
        coin.position = CGPoint(
            x: cameraRect.maxX + coin.size.width/2,
            y: CGFloat.random(
                min: cameraRect.minY + coin.size.height/2,
                max: cameraRect.maxY - coin.size.height/2))
        addChild(coin)
    }
    
    func move(sprite: SKSpriteNode, velocity: CGPoint){
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
                                   y: velocity.y * CGFloat(dt))
        
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x,
                                  y: sprite.position.y + amountToMove.y)
    }
    
}
