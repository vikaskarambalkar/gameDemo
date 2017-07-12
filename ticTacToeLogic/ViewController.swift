//
//  swift
//  ticTacToeLogic
//
//  Created by vikas karambalkar on 7/6/17.
//  Copyright © 2017 com.vikas.ticTackToe. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    
    @IBOutlet var boardView: UIView!
    @IBAction func didSelectReset(_ sender: Any?) {
        resetGame()
    }
    
    func resetGame() {
        indexArray.removeAll()
        for index in 0..<9 {
            self.indexArray.append(.empty)
            if let block = self.boardView.viewWithTag(index) as? UIButton {
                setColor(color: colorFor(player: .empty), button: block, forPlayer: .empty)
            }
        }
        for layer in self.boardView.layer.sublayers! {
            
            if layer is CAShapeLayer {
                layer.removeFromSuperlayer()
            }
        }
        isUser = true
        level = 0
    }
    var indexArray: [player]! = []
    var isUser = true
    var level = 0
    
    let centerBlock = 4
    let cornerBlocks = [0,2,6,8]
    let sideBlocks = [1,3,5,7]
    let crossLines = [[0,4,8],[2,4,6]]
    let parallelLines = [[0,1,2],[0,3,6],[1,4,7],[2,5,8],[3,4,5],[6,7,8]]

    let greenColor = UIColor(red: 0.0784, green: 0.7412, blue: 0.6745, alpha: 1.0)
    let grayColor = UIColor(red: 0.9400, green: 0.9400, blue: 0.9400, alpha: 1.0)
    let whiteColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        resetGame()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didSelectButton(_ sender: Any) {
        
        if !indexArray.contains(player.empty) {
            return
        }
        if let button = sender as? UIButton {
            if isUser {
                if(indexArray[button.tag] == .empty) {
                    indexArray[button.tag] = .user
                    setColor(color: colorFor(player: .user), button: button, forPlayer: .user)
                    isUser = !isUser
                    
                }
                
            }
        }
    }
    
    func checkForUserWinAndContinue() {
        let userWin = checkForWinningLines(forPlayer: .user)
        if userWin {
//            showAlertWith(title: "FInished!", message: "you wone the puzzle")
            return
        }
        if indexArray.contains(.empty) {
            playComputer()
            let computerWin = checkForWinningLines(forPlayer: .computer)
            if computerWin {
//                showAlertWith(title: "FInished!", message: "you lost the puzzle")
                return
            }
            else if !indexArray.contains(.empty) {
                showAlertWith(title: "FInished!", message: "No one could win")
                return
            }
        }
        else if !indexArray.contains(.empty) {
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
        indexArray[index] = .computer
        if let block = self.boardView.viewWithTag(index) as? UIButton {
            setColor(color: colorFor(player: .computer), button: block, forPlayer: .computer)
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

    func getCheckingArray(forPlayer:player) -> [[Int]] {
        var userSelectedArray: [Int] = []
        for index in 0...8 {
            if indexArray[index] == forPlayer {
                userSelectedArray.append(index)
            }
        }
        var lineContaining: [Int] = []
        let mergedArray = crossLines + parallelLines
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
        
        let checkInArray = getCheckingArray(forPlayer: .user)
        for index in 0..<checkInArray.count {
            var userCount: [Int] = []
            var machineCount: [Int] = []
            var emptyCount: [Int] = []
            
            for subIndex in 0..<3 {
                
                if (indexArray[checkInArray[index][subIndex]] == .user)
                {
                    userCount.append(checkInArray[index][subIndex])
                }
                else if (indexArray[checkInArray[index][subIndex]] == .computer)
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
        
        let checkInArray = getCheckingArray(forPlayer: .computer)
        for index in 0..<checkInArray.count {
            var userCount: [Int] = []
            var machineCount: [Int] = []
            var emptyCount: [Int] = []
            
            for subIndex in 0..<3 {
                
                if (indexArray[checkInArray[index][subIndex]] == .user)
                {
                    userCount.append(checkInArray[index][subIndex])
                }
                else if (indexArray[checkInArray[index][subIndex]] == .computer)
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
        let checkInArray = getCheckingArray(forPlayer: .computer)
        for index in 0..<checkInArray.count {
            var userCount: [Int] = []
            var machineCount: [Int] = []
            var emptyCount: [Int] = []
            
            for subIndex in 0..<3 {
                
                if (indexArray[checkInArray[index][subIndex]] == .user)
                {
                    userCount.append(checkInArray[index][subIndex])
                }
                else if (indexArray[checkInArray[index][subIndex]] == .computer)
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
    
    func checkForWinningLines(forPlayer: player) -> Bool {
        let checkInArray = getCheckingArray(forPlayer: forPlayer)
        for index in 0..<checkInArray.count {
            var userCount: [Int] = []
            var machineCount: [Int] = []
            var emptyCount: [Int] = []
            
            for subIndex in 0..<3 {
                
                if (indexArray[checkInArray[index][subIndex]] == .user)
                {
                    userCount.append(checkInArray[index][subIndex])
                }
                else if (indexArray[checkInArray[index][subIndex]] == .computer)
                {
                    machineCount.append(checkInArray[index][subIndex])
                }
                else {
                    emptyCount.append(checkInArray[index][subIndex])
                }
            }
            
            if forPlayer == .user && userCount.count == 3 {
                let fromButton = self.boardView.viewWithTag(userCount[0])
                let toButton = self.boardView.viewWithTag(userCount[2])
                let fromPoint = fromButton?.center
                let toPoint = toButton?.center
                self.drawLine(from: fromPoint!, to: toPoint!, color: colorFor(player: .computer))
                return true
            }
            
            if forPlayer == .computer && machineCount.count == 3 {
                let fromButton = self.boardView.viewWithTag(machineCount[0])
                let toButton = self.boardView.viewWithTag(machineCount[2])
                let fromPoint = fromButton?.center
                let toPoint = toButton?.center
                self.drawLine(from: fromPoint!, to: toPoint!,color: colorFor(player: .user))
                
                return true
            }
            
        }
        return false
    }

    
    func checkForEmptyCenterBlock() -> Int {
        if indexArray[centerBlock] == .empty {
            return centerBlock
        }
        return -1
    }
    
    func getRandomEmptyBlock() -> Int {
        var Index = -1
        while Index == -1 {
            let diceRoll = Int(arc4random_uniform(8))
            print("diceRoll: \(diceRoll)")
            if diceRoll != centerBlock &&
                (self.indexArray[diceRoll] == .empty) {
                Index = diceRoll
                print("random selection: \(Index)")
            }
        }
        return Index
    }

    
    func checkForCornerBlock() -> Int {
        let index = -1
        for cornerIndex in cornerBlocks {
            if indexArray[cornerIndex] == .empty {
                return cornerIndex
            }
        }
        return index
    }
    
    func checkForSideBlock() -> Int {
        let index = -1
        for sideIndex in sideBlocks {
            if indexArray[sideIndex] == .empty {
                return sideIndex
            }
        }
        return index
    }
}


extension ViewController {
    enum player {
        case empty
        case user
        case computer
    }
    
    func colorFor(player: player) -> CGColor {
        switch player {
        case .user:
            return greenColor.cgColor
        case .computer:
            return grayColor.cgColor
        default:
            return whiteColor.cgColor
        }
    }
    
    func imageFor(player: player) -> UIImage? {
        switch player {
        case .user:
            return #imageLiteral(resourceName: "cross")
        case .computer:
            return #imageLiteral(resourceName: "round")
        default:
            return nil
        }
    }
    
    func setColor(color:CGColor, button:UIButton, forPlayer: player) {
        self.boardView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: { 
            button.backgroundColor = UIColor(cgColor: color)
            button.setBackgroundImage(self.imageFor(player: forPlayer), for: .normal)
        }) { (success) in
            if (success) {
                self.boardView.isUserInteractionEnabled = true
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
            self.resetGame()
            NSLog("OK Pressed")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ViewController {

    func drawLine(from: CGPoint, to: CGPoint, color: CGColor) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: from)
        linePath.addLine(to: to)
        line.path = linePath.cgPath
        line.strokeColor = color
        line.lineWidth = 26
        self.boardView.layer.addSublayer(line)
        UIView.animate(withDuration: 0.9) {
            line.lineJoin = kCALineJoinRound
        }
    }
    
}

