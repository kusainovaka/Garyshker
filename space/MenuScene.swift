//
//  MenuScene.swift
//  space
//
//  Created by Kamila Kusainova on 26.06.17.
//  Copyright © 2017 sdu. All rights reserved.
//

import Foundation
import SpriteKit
import EasyPeasy

class MenuScene: SKScene{
    
    var backgroundNode: SKSpriteNode!
    var playButton: SKSpriteNode!
    var scoreButton: SKSpriteNode!
    var musicButton: SKSpriteNode!
    
    let gradientView = UIView(frame: screenBounds)
    var musicON: SKTexture!
    var musicOFF: SKTexture!
    var backgroundMusic:SKAudioNode!
    var shineEmitter:SKEmitterNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        createBackground()
        shineAdd()
        createMenuItem()
    }
    
    func shineAdd(){
        shineEmitter = SKEmitterNode(fileNamed: "shine.sks")!
        shineEmitter.position = CGPoint(x: screenWidth / 10, y: screenHeight)
        shineEmitter.zPosition = 1
        shineEmitter.isHidden = false
        addChild(shineEmitter)
    }
    
    func createBackground(){
        backgroundNode = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "MenuBackground")))
        backgroundNode.position = CGPoint(x: screenWidth / 2.1  , y: screenHeight / 2)
        backgroundNode.size = CGSize(width: screenWidth, height: screenHeight)
        backgroundNode.zPosition = 0
        addChild(backgroundNode)
    }
    
    func createMenuItem(){
        //90
        playButton = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "pla")))
        playButton.position = CGPoint(x: screenWidth / 2, y: screenHeight / 4)
        playButton.size = CGSize(width: screenWidth / 4.16, height: screenHeight / 7.40)
        playButton.zPosition = 1
        playButton.name = "playButton"
        
        addChild(playButton)
        
        //70
        scoreButton = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "score")))
        scoreButton.position = CGPoint(x: screenWidth / 4, y: screenHeight / 9)
        scoreButton.size = CGSize(width: screenWidth / 5.35, height: screenHeight / 9.52)
        scoreButton.zPosition = 1
        scoreButton.name = "scoreButton"
        addChild(scoreButton)

        musicON = SKTexture(image: #imageLiteral(resourceName: "musicOn"))
        
        musicOFF = SKTexture(image: #imageLiteral(resourceName: "musicOff"))
        if Model.sharedInstance.sound == true{
            musicButton = SKSpriteNode(texture: musicON)
        }else {
           musicButton = SKSpriteNode(texture: musicOFF)
        }
       
        musicButton.isHidden = false
        musicButton.position = CGPoint(x: screenWidth / 1.25, y: screenHeight / 9 )
        musicButton.size = CGSize(width: screenWidth / 5.35, height: screenHeight / 9.52)
        musicButton.zPosition = 1
        musicButton.name = "musicButton"
        addChild(musicButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "playButton" {
            let gameScen = GameScene(size: self.size)
            self.view?.presentScene(gameScen)
        } else if node.name == "scoreButton" {
            let scoreScene = TotalScoreScene(size: self.size)
            self.view?.presentScene(scoreScene)
        } else if node.name == "musicButton" {
            if Model.sharedInstance.sound == true{
                musicButton.texture = musicOFF
                Model.sharedInstance.sound = false
            }else if Model.sharedInstance.sound == false{
                musicButton.texture = musicON
                Model.sharedInstance.sound = true
            }
        }
    }
}

