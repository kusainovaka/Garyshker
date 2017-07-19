//
//  MenuScene.swift
//  space
//
//  Created by Kamila Kusainova on 26.06.17.
//  Copyright © 2017 sdu. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation
import EasyPeasy

class MenuScene: SKScene{
    
    var backgroundNode: SKSpriteNode!
    var playButton: SKSpriteNode!
    var scoreButton: SKSpriteNode!
    var musicButton: SKSpriteNode!
    
    let gradientView = UIView(frame: screenBounds)
    var musicBoll = true
    var backgroundMusic: SKAudioNode!
    var musicON: SKTexture!
    var musicOFF: SKTexture!
    var musicplay : SKAction!
//    var soundOff = false{
//        didSet {
//            // 1
//            let imageName = soundOff ? "offMusic" : "onMusic"
//            musicButton.texture = SKTexture(imageNamed: imageName)
//            
//            // 2
//            let action = soundOff ? SKAction.pause() : SKAction.play()
//            backgroundMusic?.run(action)
//            
//            backgroundMusic?.autoplayLooped = !soundOff
//            
//            // 3
//            UserDefaults.standard.set(soundOff, forKey: "pref_sound")
//            UserDefaults.standard.synchronize()
//        }
//        
//    }
    var soundOff = false
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        
//        musicButton = SKSpriteNode()
//        backgroundMusic =  SKAudioNode(fileNamed: "menuSound.mp3") as SKAudioNode
//        
//        soundOff = UserDefaults.standard.bool(forKey: "pref_sound")
//        
        
        createBackground()
        createMenuItem()
        
    }
    
    
    func createBackground(){
        backgroundNode = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "MenuBackground")))
        
        backgroundNode.position = CGPoint(x: self.size.width / 2 , y: self.size.height / 2)
        backgroundNode.size = CGSize(width: screenWidth, height: screenHeight)
        backgroundNode.zPosition = 0
        addChild(backgroundNode)
    }
    
    func createMenuItem(){
        playButton = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "playbutton")))
        playButton.size = CGSize(width: 230, height: 230)
        playButton.position = CGPoint(x: self.size.width / 2 + 10, y: self.size.height / 6)
        playButton.zPosition = 1
        playButton.name = "playButton"
        
        addChild(playButton)
        
        scoreButton = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Scorebutton")))
        scoreButton.size = CGSize(width: 130, height: 130)
        scoreButton.position = CGPoint(x:  self.size.width / 6.8, y: self.size.height / 8 - 50)
        scoreButton.zPosition = 1
        scoreButton.name = "scoreButton"
        addChild(scoreButton)
        
        
        musicON = SKTexture(image: #imageLiteral(resourceName: "onMusic"))
        musicOFF = SKTexture(image: #imageLiteral(resourceName: "offMusic"))
        musicButton = SKSpriteNode(texture: musicON)
        
        musicButton.isHidden = false
        musicButton.size = CGSize(width: 50, height: 50)
        musicButton.position = CGPoint(x:  self.size.width / 1.1 - 20, y: self.size.height / 8 - 50)
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
            if soundOff == false{
            musicButton.texture = musicON
                musicplay = SKAction.playSoundFileNamed("menuSound.mp3", waitForCompletion: false)
                print(soundOff)
                run(musicplay)
                soundOff = true
            }else{
            musicButton.texture = musicOFF
                musicplay = SKAction.stop()
                run(musicplay)
                soundOff = false
            }
        }
    }
    
    //   private func backgroundLayout(){
    //    backgroundNode <- [
    //        Top(0),
    //        Left(0),
    //        Right(0),
    //        Bottom(0)
    //        ]
    //    
    //    }
    
}

