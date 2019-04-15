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
        /*var textures: [SKTexture] = []
         //animates the zombie with an array looping through different images
         for i in 1...4{
         textures.append(SKTexture(imageNamed: ":zombie\(i)"))
         }
         textures.append(textures[2])
         textures.append(textures[1])
         
         zombieAnimation = SKAction.animate(with: textures,
         timePerFrame: 0.1)*/
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
        //Whereever the player is
        //floor1.position = CGPoint
        floorNode.addChild(floor1)
        
        let floor2 = SKSpriteNode(imageNamed: "Jungle_Floor_2")
        floor2.anchorPoint = CGPoint.zero
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
    }
    
    /*
     //calculates the amount the camera needs to move
     func moveCamera() {
     let backgroundVelocity =
     CGPoint(x: cameraMovePointsPerSec, y: 0)
     let amountToMove = backgroundVelocity * CGFloat(dt)
     cameraNode.position += amountToMove
     }
     
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
    
    
}
