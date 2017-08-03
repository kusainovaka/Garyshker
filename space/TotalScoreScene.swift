//
//  TotalScoreScene.swift
//  space
//
//  Created by Kamila Kusainova on 04.07.17.
//  Copyright © 2017 sdu. All rights reserved.
//

import UIKit
import SpriteKit
import EasyPeasy

class TotalScoreScene: SKScene, UITableViewDelegate, UITableViewDataSource {
    
    var backButton : SKSpriteNode!
    var playerLabel : SKLabelNode!
    var scores = [Int]()
    var names = ["player"]
    
    private lazy var scoreTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        return tableView
    }()
  
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        
        backToMenu()
        view.addSubview(scoreTableView)
        getScores()
        scoreTableView.delegate = self
        scoreTableView.dataSource = self
    }
    
    func backToMenu(){
        backButton = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "back")))
        backButton.setScale(0.5)
        backButton.position = CGPoint(x: screenWidth / 7, y: screenHeight / 1.08)
        backButton.size = CGSize(width: screenWidth / 5.85, height: screenHeight / 10.4)
        backButton.zPosition = 1
        backButton.name = "back"
        addChild(backButton)
        
        playerLabel = SKLabelNode(fontNamed: "Ubuntu")
        playerLabel.position = CGPoint(x: screenWidth / 2, y: screenHeight / 1.1)
        playerLabel.text = "SCORES"
        playerLabel.fontSize = screenWidth / 9.4
        playerLabel.fontColor = UIColor(red: 254/255, green: 245/255, blue: 227/255, alpha: 100)
        addChild(playerLabel)
    }
    
    func getScores() {
        let defaults = UserDefaults.standard
        if let scoresFromDefaults = defaults.array(forKey: "scores") {
            scores = scoresFromDefaults as! [Int]
            scoreTableView.reloadData()
            tableViewLayouts()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle  = .none
        scores.sort(){$0 > $1}
        cell.textLabel?.text = String(scores[indexPath.row])
        cell.textLabel?.font = UIFont(name: "Ubuntu", size: 25)
        cell.textLabel?.textColor = UIColor(red: 254/255, green: 245/255, blue: 227/255, alpha: 100)
        cell.textLabel?.textAlignment = .center

        return cell
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "back" {
            scoreTableView.removeFromSuperview()
            let menuScene = MenuScene(size: self.size)
            self.view?.presentScene(menuScene)
        }
    }
    private func tableViewLayouts(){
    scoreTableView <- [
        Right(100),
        Left(100),
        Top(100),
        Bottom(100)
        ]
    
    }
}
