//
//  ViewController.swift
//  ticTacToeLogic
//
//  Created by vikas karambalkar on 7/6/17.
//  Copyright © 2017 com.vikas.ticTackToe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBAction func didSelectReset(_ sender: Any) {
        for index in 0..<indexArray.count {
            print(index)
            indexArray[index] = 0
            if let block = self.view.viewWithTag(index) as? UIButton {
                block.backgroundColor = .lightGray
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
                button.backgroundColor = .red
                self.indexArray[button.tag] = 1
                isUser = !isUser
                if indexArray.contains(0) {
                    playComputer()
                }
            }
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
        
        }
        else if level == 3 {
        
        }

    }
    
    func setBlockSelectedWithTag(tag: Int) {
    
        if let block = self.view.viewWithTag(tag) as? UIButton {
            block.backgroundColor = .green
        }
    }
    
    
}

extension ViewController {
    func playFirstLevel() {
        let index = getRandomEmptyBlock()
        indexArray[index] = 2
        setBlockSelectedWithTag(tag: index)
        level += 1
        isUser = !isUser
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

extension ViewController {
    func playSecondLevel() {
        let index = checkForTwoFilledAndOneEmpty()
        indexArray[index] = 2
        setBlockSelectedWithTag(tag: index)
        level += 1
        isUser = !isUser
    }
    
    func checkForTwoFilledAndOneEmpty() -> Int {
    
        var userSelectedArray: [Int] = []
        for index in 0...8 {
            if indexArray[index] == 1 {
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
        
        print(mergedArray)
        print(lineContaining)
        print(checkInArray)

        
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
            print("found userCount:\(userCount.count) at \(userCount), machineCount:\(machineCount.count) at \(machineCount), emptyIndex:\(emptyCount.count) at \(emptyCount)")
            
            if emptyCount.count == 1 && userCount.count == 2 {
                return emptyCount[0]
            }
        }
        return 1
    }
    
    func checkInCrossLines() -> Int {
    
        
        return 1
    }
}

extension ViewController {
    
    func playThirdLevel() {
        level += 1
        isUser = !isUser
    }

}

extension ViewController {
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}


