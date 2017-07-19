//
//  ScoreScene.swift
//  space
//
//  Created by Kamila Kusainova on 30.06.17.
//  Copyright © 2017 sdu. All rights reserved.
////

import UIKit

class ScoreScene: UITableView, UITableViewDelegate, UITableViewDataSource{
    
    var names = ["name"]
    var scores = [Any]()
    
    var tableView = UITableView()
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = UIColor.clear
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.frame = CGRect(x: 80,y: 80,width:screenWidth / 1.5 ,height:screenHeight)
        self.delegate = self
        self.dataSource = self
        getScores()
    }
    
    func getScores() {
        let defaults = UserDefaults.standard
        if let scoresFromDefaults = defaults.array(forKey: "scores") {
            scores = scoresFromDefaults
            tableView.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
         cell = UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: "cell")

        cell.backgroundColor = .clear
        cell.selectionStyle  = .none
//        cell.textLabel?.text = names[indexPath.row]
//        cell.detailTextLabel?.text = String(describing: scores[indexPath.row])
        let labelName = UILabel(frame: CGRect(x: 20, y: -20, width: 100, height: 100))
        labelName.text = names[indexPath.row]
        let labelScore = UILabel(frame: CGRect(x: 160, y: -20, width: 100, height: 100))
        labelScore.text = String(describing: scores[indexPath.row])
        cell.addSubview(labelName)
        cell.addSubview(labelScore)
        
        return cell
    }
   
    
}
