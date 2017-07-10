//
//  ViewController.swift
//  ticTacToeLogic
//
//  Created by vikas karambalkar on 7/6/17.
//  Copyright © 2017 com.vikas.ticTackToe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var indexArray = [0,0,0,0,0,0,0,0,0]
    var isUser = true
    var level = 0
    
    let centerBlock = 4
    let cornerBlocks = [0,2,6,8]
    let sideBlocks = [1,3,5,7]
    
    @IBOutlet var blockButtons: [UIButton]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didSelectButton(_ sender: Any) {
        
        if let button = sender as? UIButton {
            if isUser {
                button.backgroundColor = .red
                indexArray[button.tag] = 1
                playComputer()
            }
            else {
                button.backgroundColor = .green

            }
        }
        isUser = !isUser
    }
    

    func playComputer() {
        if level == 0 {
            playFirstLevel()
        }
        isUser = !isUser
    }
    
    func playFirstLevel() {
        let index = getRandomEmptyBlock()
        indexArray[index] = 2
        blockButtons[index].backgroundColor = .green
    }
    
    func getRandomEmptyBlock() -> Int {
        var Index = -1
        while Index == -1 {
            let diceRoll = Int(arc4random_uniform(9))
            if (self.indexArray[diceRoll] == 0) {
                Index = diceRoll
            }
        }
        return Index
    }
    
}


