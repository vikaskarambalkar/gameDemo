//
//  ViewController.swift
//  ticTacToeLogic
//
//  Created by vikas karambalkar on 7/6/17.
//  Copyright © 2017 com.vikas.ticTackToe. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    
    @IBAction func didSelectReset(_ sender: Any?) {
        for index in 0..<indexArray.count {
            indexArray[index] = 0
            if let block = self.view.viewWithTag(index) as? UIButton {
                setColor(color: .yellow, button: block, forPlayer: .empty)
            }
        }
        isUser = true
        level = 0
        
    }
    var indexArray = [0,0,0,0,0,0,0,0,0]
    var isUser = true
    var level = 0
    
    static let centerBlock = 4
    static let cornerBlocks = [0,2,6,8]
    static let sideBlocks = [1,3,5,7]
    static let crossLines = [[0,4,8],[2,4,6]]
    static let parallelLines = [[0,1,2],[0,3,6],[1,4,7],[2,5,8],[3,4,5],[6,7,8]]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didSelectButton(_ sender: Any) {
        
        if !indexArray.contains(0) {
            return
        }
        if let button = sender as? UIButton {
            if isUser {
                if(indexArray[button.tag] == 0) {
                    indexArray[button.tag] = 1
                    setColor(color: .red, button: button, forPlayer: .user)
                    isUser = !isUser
                    
                }
                
            }
        }
    }
    
    func checkForUserWinAndContinue() {
        let userWin = checkForWinningLines(forPlayer: 1)
        if userWin {
            showAlertWith(title: "FInished!", message: "you wone the puzzle")
            return
        }
        if indexArray.contains(0) {
            playComputer()
            let computerWin = checkForWinningLines(forPlayer: 2)
            if computerWin {
                showAlertWith(title: "FInished!", message: "you lost the puzzle")
                return
            }
            else if !indexArray.contains(0) {
                showAlertWith(title: "FInished!", message: "No one could win")
                return
            }
        }
        else if !indexArray.contains(0) {
            showAlertWith(title: "FInished!", message: "No one could win")
            return
        }
    }

    func playComputer() {
        if level == 0 {
            playFirstLevel()
        }
        else if level == 1 {
            playSecondLevel()
        }
        else if level == 2 {
            playThirdLevel()
        }
        else if level == 3 {
            playFourthLevel()
        }
    }
    
    func setBlockSelectedWithTag(index: Int) {
        indexArray[index] = 2
        if let block = self.view.viewWithTag(index) as? UIButton {
            setColor(color: .gray, button: block, forPlayer: .computer)
            level += 1
            isUser = !isUser
        }
    }
    
}

extension ViewController {
    func playFirstLevel() {
        let index = getRandomEmptyBlock()
        setBlockSelectedWithTag(index: index)
    }
    
    
}

extension ViewController {
    func playSecondLevel() {
        var index = checkForTwoFilledUserAndOneEmptyBlock()
        if index != -1 {
            setBlockSelectedWithTag(index: index)
            return
        }
        index = checkForOneFilledComputerAndTwoEmptyBlock()
        if index != -1 {
            setBlockSelectedWithTag(index: index)
            return
        }
        index = checkForEmptyCenterBlock()
        if index != -1 {
            setBlockSelectedWithTag(index: index)
            return
        }
        index = checkForCornerBlock()
        if index != -1 {
            setBlockSelectedWithTag(index: index)
            return
        }
    }
}

extension ViewController {
    
    func playThirdLevel() {
        var index = checkForTwoFilledComputerAndOneEmptyBlock()
        if index != -1 {
            setBlockSelectedWithTag(index: index)
            return
        }
        index = checkForTwoFilledUserAndOneEmptyBlock()
        if index != -1 {
            setBlockSelectedWithTag(index: index)
            return
        }
        index = checkForEmptyCenterBlock()
        if index != -1 {
            setBlockSelectedWithTag(index: index)
            return
        }
        index = checkForCornerBlock()
        if index != -1 {
            setBlockSelectedWithTag(index: index)
            return
        }
    }

}

extension ViewController {
    
    func playFourthLevel() {
        var index = checkForTwoFilledComputerAndOneEmptyBlock()
        if index != -1 {
            setBlockSelectedWithTag(index: index)
            return
        }
        index = checkForTwoFilledUserAndOneEmptyBlock()
        if index != -1 {
            setBlockSelectedWithTag(index: index)
            return
        }
        index = checkForEmptyCenterBlock()
        if index != -1 {
            setBlockSelectedWithTag(index: index)
            return
        }
        index = checkForCornerBlock()
        if index != -1 {
            setBlockSelectedWithTag(index: index)
            return
        }
        index = checkForSideBlock()
        if index != -1 {
            setBlockSelectedWithTag(index: index)
            return
        }
    }
    
}

extension ViewController {

    func getCheckingArray(forPlayer:Int) -> [[Int]] {
        var userSelectedArray: [Int] = []
        for index in 0...8 {
            if indexArray[index] == forPlayer {
                userSelectedArray.append(index)
            }
        }
        var lineContaining: [Int] = []
        let mergedArray = ViewController.crossLines + ViewController.parallelLines
        for index in 0..<userSelectedArray.count {
            for subIndex in 0..<mergedArray.count {
                if(mergedArray[subIndex].contains(userSelectedArray[index])) {
                    if !(lineContaining.contains(subIndex)) {
                        lineContaining.append(subIndex)
                    }
                }
            }
        }
        var checkInArray: [[Int]] = []
        for index in 0..<lineContaining.count {
            checkInArray.append(mergedArray[lineContaining[index]])
        }
        return checkInArray
    }
    
    
    func checkForTwoFilledUserAndOneEmptyBlock() -> Int {
        
        let checkInArray = getCheckingArray(forPlayer: 1)
        for index in 0..<checkInArray.count {
            var userCount: [Int] = []
            var machineCount: [Int] = []
            var emptyCount: [Int] = []
            
            for subIndex in 0..<3 {
                
                if (indexArray[checkInArray[index][subIndex]] == 1)
                {
                    userCount.append(checkInArray[index][subIndex])
                }
                else if (indexArray[checkInArray[index][subIndex]] == 2)
                {
                    machineCount.append(checkInArray[index][subIndex])
                }
                else {
                    emptyCount.append(checkInArray[index][subIndex])
                }
            }
            
            if emptyCount.count == 1 && userCount.count == 2 {
                return emptyCount[0]
            }
        }
        return -1
    }
    
    func checkForTwoFilledComputerAndOneEmptyBlock() -> Int {
        
        let checkInArray = getCheckingArray(forPlayer: 2)
        for index in 0..<checkInArray.count {
            var userCount: [Int] = []
            var machineCount: [Int] = []
            var emptyCount: [Int] = []
            
            for subIndex in 0..<3 {
                
                if (indexArray[checkInArray[index][subIndex]] == 1)
                {
                    userCount.append(checkInArray[index][subIndex])
                }
                else if (indexArray[checkInArray[index][subIndex]] == 2)
                {
                    machineCount.append(checkInArray[index][subIndex])
                }
                else {
                    emptyCount.append(checkInArray[index][subIndex])
                }
            }
            if emptyCount.count == 1 && machineCount.count == 2 {
                return emptyCount[0]
            }
        }
        return -1
    }
    
    func checkForOneFilledComputerAndTwoEmptyBlock() -> Int {
        let checkInArray = getCheckingArray(forPlayer: 2)
        for index in 0..<checkInArray.count {
            var userCount: [Int] = []
            var machineCount: [Int] = []
            var emptyCount: [Int] = []
            
            for subIndex in 0..<3 {
                
                if (indexArray[checkInArray[index][subIndex]] == 1)
                {
                    userCount.append(checkInArray[index][subIndex])
                }
                else if (indexArray[checkInArray[index][subIndex]] == 2)
                {
                    machineCount.append(checkInArray[index][subIndex])
                }
                else {
                    emptyCount.append(checkInArray[index][subIndex])
                }
            }
            
            if emptyCount.count == 2 && machineCount.count == 1 {
                return emptyCount[0]
            }
        }
        return -1
    }
    
    func checkForWinningLines(forPlayer: Int) -> Bool {
        let checkInArray = getCheckingArray(forPlayer: forPlayer)
        for index in 0..<checkInArray.count {
            var userCount: [Int] = []
            var machineCount: [Int] = []
            var emptyCount: [Int] = []
            
            for subIndex in 0..<3 {
                
                if (indexArray[checkInArray[index][subIndex]] == 1)
                {
                    userCount.append(checkInArray[index][subIndex])
                }
                else if (indexArray[checkInArray[index][subIndex]] == 2)
                {
                    machineCount.append(checkInArray[index][subIndex])
                }
                else {
                    emptyCount.append(checkInArray[index][subIndex])
                }
            }
            
            if forPlayer == 1 && userCount.count == 3 {
                return true
            }
            
            if forPlayer == 2 && machineCount.count == 3 {
                return true
            }
            
        }
        return false
    }

    
    func checkForEmptyCenterBlock() -> Int {
        if indexArray[ViewController.centerBlock] == 0 {
            return ViewController.centerBlock
        }
        return -1
    }
    
    func getRandomEmptyBlock() -> Int {
        var Index = -1
        while Index == -1 {
            let diceRoll = Int(arc4random_uniform(8))
            print("diceRoll: \(diceRoll)")
            if diceRoll != ViewController.centerBlock &&
                (self.indexArray[diceRoll] == 0) {
                Index = diceRoll
                print("random selection: \(Index)")
            }
        }
        return Index
    }

    
    func checkForCornerBlock() -> Int {
        let index = -1
        for cornerIndex in ViewController.cornerBlocks {
            if indexArray[cornerIndex] == 0 {
                return cornerIndex
            }
        }
        return index
    }
    
    func checkForSideBlock() -> Int {
        let index = -1
        for sideIndex in ViewController.sideBlocks {
            if indexArray[sideIndex] == 0 {
                return sideIndex
            }
        }
        return index
    }
    
    func checkForAnyBlock() -> Int {
        let emptyIndex = -1
        for index in indexArray {
            if indexArray[index] == 0 {
                return index
            }
        }
        return emptyIndex
    }
}


extension ViewController {
    enum player {
        case empty
        case user
        case computer
    }
    
    func setColor(color:UIColor, button:UIButton, forPlayer: player) {
        self.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: { 
            button.backgroundColor = color
        }) { (success) in
            if (success) {
                self.view.isUserInteractionEnabled = true
                if forPlayer == .user {
                    self.checkForUserWinAndContinue()
                }
            }
        }
    }
    
    func showAlertWith(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Replay", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.didSelectReset(nil)
            NSLog("OK Pressed")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

