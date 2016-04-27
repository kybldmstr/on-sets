//
//  ViewController.swift
//  ON-SETS
//
//  Created by Jordan Holmer on 4/12/16.
//  Copyright © 2016 Jordan Holmer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var levelPass: Int!
    var blueCount: Int!

    @IBOutlet weak var numberOfCardsLabel: UILabel!
    
    @IBOutlet weak var cardsStepper: UIStepper!
    
    @IBOutlet var collectionOfCardViews: Array<UIImageView>?
    var collectionOfCardImages: Array<UIImage> = [
        UIImage(named: "BR")!,
        UIImage(named: "BRY")!,
        UIImage(named: "BY")!,
        UIImage(named: "B")!,
        UIImage(named: "BRG")!,
        UIImage(named: "BRGY")!,
        UIImage(named: "BGY")!,
        UIImage(named: "BG")!,
        UIImage(named: "RG")!,
        UIImage(named: "RGY")!,
        UIImage(named: "GY")!,
        UIImage(named: "G")!,
        UIImage(named: "R")!,
        UIImage(named: "RY")!,
        UIImage(named: "BY")!,
        UIImage(named: "BLANK")!
    ]
    
    @IBOutlet var collectionOfGoalDiceViews: Array<UIImageView>?
    var collectionOfGoalDiceImages: Array<UIImage> = [
        UIImage(named: "one")!,
        UIImage(named: "two")!,
        UIImage(named: "three")!,
        UIImage(named: "four")!,
        UIImage(named: "five")!
    ]
    var collectionOfGoalDiceFlipImages: Array<UIImage> = [
        UIImage(named: "one_flip")!,
        UIImage(named: "two_flip")!,
        UIImage(named: "three_flip")!,
        UIImage(named: "four_flip")!,
        UIImage(named: "five_flip")!
    ]
    var goalDiceRolled: Array<Int> = [0,0,0]

    @IBOutlet var collectionOfBlueDiceViews: Array<UIImageView>?
    var collectionOfBlueDiceImages: Array<UIImage>! // will be set on view load
    
    @IBOutlet var collectionOfRedDiceViews: Array<UIImageView>?
    var collectionOfRedDiceImages: Array<UIImage> = [
        UIImage(named: "intersect")!,
        UIImage(named: "union")!,
        UIImage(named: "minus")!,
        UIImage(named: "prime")!
    ]
    
    @IBOutlet var collectionOfColoredDiceViews: Array<UIImageView>?
    var collectionOfColoredDiceImages: Array<UIImage> = [
        UIImage(named: "blue")!,
        UIImage(named: "red")!,
        UIImage(named: "green")!,
        UIImage(named: "yellow")!
    ]
    
    @IBAction func updateCardCount(sender: AnyObject) {
        numberOfCardsLabel.text = String(format:"%d", Int(cardsStepper.value))
    }
    
    // shuffle cards and roll cubes
    @IBAction func shuffleCards(sender: AnyObject) {
        for var i = 0; i < 14; i += 1 {
            collectionOfCardViews![i].image = nil
        }
        collectionOfCardImages.shuffle()
        for var card = 0; card < Int(cardsStepper.value); card += 1 {
            collectionOfCardViews![card].image = collectionOfCardImages[card]
        }
        for var goal = 0; goal < 3; goal += 1 {
            goalDiceRolled[goal] = Int(arc4random_uniform(UInt32(5)))
            collectionOfGoalDiceViews![goal].image = collectionOfGoalDiceImages[goalDiceRolled[goal]]
        }
        for var blue = 0; blue < 3; blue += 1 {
            collectionOfBlueDiceViews![blue].image = collectionOfBlueDiceImages[Int(arc4random_uniform(UInt32(blueCount)))]
        }
        for var red = 0; red < 4; red += 1 {
            collectionOfRedDiceViews![red].image = collectionOfRedDiceImages[Int(arc4random_uniform(UInt32(4)))]
        }
        for var color = 0; color < 8; color += 1 {
            collectionOfColoredDiceViews![color].image = collectionOfColoredDiceImages[Int(arc4random_uniform(UInt32(4)))]
        }
    }
    
    //flip cards and/or flip number cubes
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInView(self.view)
            
            for var card = 0; card < Int(cardsStepper.value); card += 1 {
                if collectionOfCardViews![card].frame.contains(location) {
                    if collectionOfCardViews![card].image == UIImage(named: "FLIPPED") {
                        collectionOfCardViews![card].image = collectionOfCardImages[card]
                    } else {
                        collectionOfCardViews![card].image = UIImage(named: "FLIPPED")
                    }
                }
            }
            for var goal = 0; goal < 3; goal += 1 {
                if collectionOfGoalDiceViews![goal].frame.contains(location) {
                    if collectionOfGoalDiceViews![goal].image == collectionOfGoalDiceImages[goalDiceRolled[goal]] {
                        collectionOfGoalDiceViews![goal].image = collectionOfGoalDiceFlipImages[goalDiceRolled[goal]]
                    } else {
                        collectionOfGoalDiceViews![goal].image = collectionOfGoalDiceImages[goalDiceRolled[goal]]
                    }
                }
            }
        }
    }
    
    // move the cubes
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInView(self.view)
            
            for var goal = 0; goal < 3; goal += 1 {
                if collectionOfGoalDiceViews![goal].frame.contains(location) {
                    collectionOfGoalDiceViews![goal].center = location
                    collectionOfGoalDiceViews![goal].image = collectionOfGoalDiceImages[goalDiceRolled[goal]]
                }
            }
            for var blue = 0; blue < 3; blue += 1 {
                if collectionOfBlueDiceViews![blue].frame.contains(location) {
                    collectionOfBlueDiceViews![blue].center = location
                }
            }
            for var red = 0; red < 4; red += 1 {
                if collectionOfRedDiceViews![red].frame.contains(location) {
                    collectionOfRedDiceViews![red].center = location
                }
            }
            for var color = 0; color < 8; color += 1 {
                if collectionOfColoredDiceViews![color].frame.contains(location) {
                    collectionOfColoredDiceViews![color].center = location
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set rules for level
        // default is 6-12 cards, only need to change for Senior Division
        if (levelPass == 3) {
            cardsStepper.minimumValue = 10
            cardsStepper.maximumValue = 14
            numberOfCardsLabel.text = String(format:"%d", Int(cardsStepper.value))
        }
        // default is to use special symbols except for elementary
        if (levelPass == 0) {
            collectionOfBlueDiceImages = [
                UIImage(named: "universe")!,
                UIImage(named: "nullset")!
            ]
            blueCount = 2
        } else {
            collectionOfBlueDiceImages = [
                UIImage(named: "equal")!,
                UIImage(named: "subset")!,
                UIImage(named: "universe")!,
                UIImage(named: "nullset")!
            ]
            blueCount = 4
        }

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension Array {
    mutating func shuffle() {
        for i in 0 ..< (count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            if(i != j) {
                swap(&self[i], &self[j])
            }
        }
    }
}
