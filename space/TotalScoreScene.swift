//
//  TotalScoreScene.swift
//  space
//
//  Created by Kamila Kusainova on 04.07.17.
//  Copyright © 2017 sdu. All rights reserved.
//

import UIKit
import SpriteKit

class TotalScoreScene: SKScene, UITableViewDelegate, UITableViewDataSource {
    
    var backButton : SKSpriteNode!
    var playerLabel : SKLabelNode!
    var scores = [Int]()
    var names = ["player"]
    
    
     var scoreTableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = CGRect(x: 80, y: 80, width: screenWidth / 2, height: screenHeight / 1.5)
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
        backButton = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "homee")))
        backButton.size = CGSize(width: 100, height: 100)
        backButton.position = CGPoint(x: self.size.width / 6, y: self.size.height / 1.1)
        backButton.zPosition = 1
        backButton.name = "back"
        addChild(backButton)
        
        playerLabel = SKLabelNode(fontNamed: "Comic Sans MS")
        playerLabel.position = CGPoint(x: screenWidth / 2, y: screenHeight / 1.15)
        playerLabel.text = "players"
        playerLabel.fontSize = 40
        playerLabel.fontColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        addChild(playerLabel)
    }
    
    func getScores() {
        let defaults = UserDefaults.standard
        if let scoresFromDefaults = defaults.array(forKey: "scores") {
            scores = scoresFromDefaults as! [Int]
            scoreTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle  = .none
        
        let mylabel = UILabel(frame: CGRect(x: 100, y: -16, width: 100, height: 100))
        mylabel.text = String(scores[indexPath.row])
        mylabel.font = UIFont(name: "Comic Sans MS", size: 30)
        mylabel.textColor = .white
//        let mylabel2 = UILabel(frame: CGRect(x: 120, y: -20, width: 100, height: 100))
//        mylabel2.text = String(scores[indexPath.row])
        
        cell.addSubview(mylabel)
//        cell.addSubview(mylabel2)
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
}
