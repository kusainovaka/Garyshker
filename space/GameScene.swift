//
//  GameScene.swift
//  space
//
//  Created by Kamila Kusainova on 26.06.17.
//  Copyright © 2017 sdu. All rights reserved.
//

import SpriteKit
import GameplayKit
import EasyPeasy
import CoreMotion

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var state = GameState.tutorial {
        didSet {
            stateChanged(to: state)
        }
    }
    var score = 0
    
    var background: SKSpriteNode!
    var player: SKSpriteNode!
    var pauseButton: SKSpriteNode!
    var swipeSprite: SKSpriteNode!
    var scoreLabel  = SKLabelNode()
    var updateTime = TimeInterval()
    var yieldTime  = TimeInterval()
    // Touch handling
    var location = CGPoint.zero
    var entryX: CGFloat = 0
    var lock = false
    var playerEmitter = SKEmitterNode()
    var i: Float = 4
    let manager = CMMotionManager()
        let pauseView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    
    //View
//     private lazy var pauseView: UIView = {
//        let gamePauseView = UIView()
//        gamePauseView.backgroundColor = UIColor.red
//        return gamePauseView
//        
//    }()
    private lazy var gameOverView: UIView = {
        let goview = UIView()
        goview.backgroundColor = UIColor(red: 69/255, green: 50/255, blue: 88/255, alpha: 100)
        goview.layer.borderWidth = 3
        goview.layer.borderColor = UIColor.white.cgColor
        return goview
    }()
    
    private lazy var menuButton: UIButton = {
        let mButton = UIButton()
        mButton.setImage(#imageLiteral(resourceName: "homee"), for: .normal)
        mButton.addTarget(self, action: #selector(backToMenu), for: .touchUpInside)
        return mButton
    }()
    private lazy var restartButton: UIButton = {
        let gameRestart = UIButton()
        gameRestart.setImage(#imageLiteral(resourceName: "loading5"), for: .normal)
        gameRestart.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        return gameRestart
    }()
    
    private lazy var gameOverLabel: UILabel = {
        let gameOver = UILabel()
        gameOver.text = "GAME OVER"
        gameOver.textColor = .white
        gameOver.font = UIFont(name: "Comic Sans MS", size: 40)
        
        return gameOver
    }()
    
    private lazy var finishScoreLabel: UILabel = {
        let finishScore = UILabel()
        finishScore.font = UIFont(name: "Comic Sans MS", size: 30)
        finishScore.textColor = UIColor(red: 85/255, green: 190/255, blue: 240/255, alpha: 100)
        return finishScore
    }()
    private lazy var highScoreLabel: UILabel = {
        let highScore = UILabel(frame: CGRect(x: self.size.width / 7 , y: self.size.height / 3.8, width: 200, height: 50))
        
        highScore.font = UIFont(name: "Comic Sans MS", size: 30)
        highScore.textAlignment = .center
        highScore.textColor = UIColor(red: 85/255, green: 190/255, blue: 240/255, alpha: 100)
        return highScore
    }()
    
    // MARK: - Did move to skVIew
    override func didMove(to view: SKView) {
        
        //        manager.startAccelerometerUpdates()
        //        manager.accelerometerUpdateInterval = 0.1
        //        manager.startAccelerometerUpdates(to: OperationQueue.main){
        //            (data, error) in
        //            self.physicsWorld.gravity = CGVector(dx: CGFloat((data?.acceleration.x)! * 5), dy: 0)
        //        }
        self.backgroundColor = UIColor(red: 53/255, green: 43/255, blue: 77/255, alpha: 100)
        setupWorldPhysics()
        moveBackground()
        createPlayer()
        createHUD()
        configurePauseView()
        
        
        
        state = .tutorial
    }
    
    // MARK: - Scene ovrrided methods
    override func update(_ currentTime: TimeInterval) {
        var timeSinceLastUpdate = currentTime - updateTime
        updateTime = currentTime
        i -= 0.005
        
        if timeSinceLastUpdate > 2.0{
            timeSinceLastUpdate = 1/60
            updateTime = currentTime
        }
        guard state == .play else { return }
        updateTimerInterval(timeSinceLastUpdate: timeSinceLastUpdate)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "player" { state = .end }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if state == .tutorial {
            state = .play
            return
        }
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "pauseButton" {
            state = .pause
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            location = touch.location(in: self)
            if !lock {
                entryX = location.x
                lock = true
            }
            let dX = abs(Int32(abs(Int32(location.x)) - abs(Int32(entryX))))
            if dX > 1 {
                player.position.x = location.x
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lock = false
        entryX = 0.0
    }
    
    // MARK: - States
    func stateChanged(to state: GameState) {
        
        switch state {
        case .tutorial:
            addTutorial()
        case .play:
            removeTutorial()
            showHUD()
            playerEmitter.isHidden = false
        case .pause:
            pauseGame()
        case .end:
            stopGame()
        }
    }
    func configurePauseView() {
        
       pauseView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let pauseLabel = UILabel(frame: CGRect(x: screenWidth / 3.5, y: screenHeight / 8, width: 200, height: 150))
        pauseLabel.text = "PAUSE"
        pauseLabel.font = UIFont(name: "Comic Sans MS", size: 50)
        pauseLabel.textColor = .white
        
        let playButton = UIButton(frame: CGRect(x: screenWidth / 4, y: screenHeight / 3, width: 200, height: 200))
        playButton.setImage(#imageLiteral(resourceName: "playbutton"), for: .normal)
        playButton.addTarget(self, action: #selector(backToGame), for: .touchUpInside)
        
        let restartButton = UIButton(frame: CGRect(x: screenWidth / 1.8 , y: screenHeight / 1.5, width: 120, height: 120))
        restartButton.setImage(#imageLiteral(resourceName: "loading5"), for: .normal)
        restartButton.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        
        let menuButton = UIButton(frame: CGRect(x: screenWidth / 8, y: screenHeight / 1.5, width: 120, height: 120))
        menuButton.setImage(#imageLiteral(resourceName: "homee"), for: .normal)
        menuButton.addTarget(self, action: #selector(backToMenu), for: .touchUpInside)
        
        pauseView.addSubview(restartButton)
        pauseView.addSubview(menuButton)
        pauseView.addSubview(playButton)
        pauseView.addSubview(pauseLabel)
//        pauseViewLayouts()
    }

    
    func gameOverPresent(){
        view?.addSubview(gameOverView)
        scoreLabel.removeFromParent()
        finishScoreLabel.text = "score: \(score)"
        highScoreLabel.text = "best score: \(Model.sharedInstance.highscore)"
        
        let defaults = UserDefaults.standard
        if var scores = defaults.array(forKey: "scores") {
            scores.append(score)
            defaults.set(scores, forKey: "scores")
        } else {
            let scores = [score]
            defaults.set(scores, forKey: "scores")
        }
        
        Model.sharedInstance.highscore = defaults.integer(forKey: "Saved")
        if score > Model.sharedInstance.highscore{
            Model.sharedInstance.highscore = score
            defaults.set(Model.sharedInstance.highscore, forKey: "Saved")
        }
        
        gameOverView.addSubview(gameOverLabel)
        gameOverView.addSubview(finishScoreLabel)
        gameOverView.addSubview(highScoreLabel)
        gameOverView.addSubview(restartButton)
        gameOverView.addSubview(menuButton)
        gameOverLayouts()
        }
    
    // MARK: - Actions
    func addRandom(){
        let randomNumber = Int(arc4random_uniform(6))
        addRow(type: RowType(rawValue: randomNumber)!)
    }
    
    func updateTimerInterval(timeSinceLastUpdate: TimeInterval){
        yieldTime += timeSinceLastUpdate
        if yieldTime > 1.5{
            yieldTime = 0
            score+=1
            scoreLabel.text = "\(score)"
            addRandom()
        }
    }
    
    func pauseGame(){
        hideHUD()
        view?.isPaused = true
        view?.addSubview(pauseView)
        
    }
    
    func stopGame(){
        self.view?.isPaused = true
        hideHUD()
        gameOverPresent()
    }
    
    func backToGame() {
        state = .play
        pauseView.removeFromSuperview()
        self.view?.isPaused = false
        showHUD()
    }
    
    func restartGame(){
        gameOverView.removeFromSuperview()
        pauseView.removeFromSuperview()
        let gameScene = GameScene(size: screenSize)
        self.view?.presentScene(gameScene)
    }
    
    func backToMenu() {
        gameOverView.removeFromSuperview()
        pauseView.removeFromSuperview()
        let gameScene = MenuScene(size: screenSize)
        self.view?.presentScene(gameScene)
    }
    
    private func gameOverLayouts(){
        gameOverView <- [
            Right(25),
            Left(25),
            Top(75),
            Bottom(70)
        ]
        menuButton <- [
            Top(380),
            Left(40),
            //            Right(200),
            //            Bottom(80)
            Height(100),
            Width(100)
        ]
        restartButton <- [
            Top(380),
            Right(40),
            Height(100),
            Width(100)
        ]
        gameOverLabel <- [
            Top(30),
            Left(50)
        ]
        finishScoreLabel <- [
            Top(120),
            Left(100),
            Right(90)
            
        ]
        highScoreLabel <- [
            Top(10).to(finishScoreLabel),
            Left(60),
            Right(60)
        ]
      
    }
//    func pauseViewLayouts(){
//    pauseView <- [
//        Top(20),
//        Right(30),
//        Left(30),
//        Bottom(20)
//        ]
//    
//    
//    }
}
