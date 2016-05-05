//
//  ViewController.swift
//  ON-SETS
//
//  Created by Jordan Holmer on 4/12/16.
//  Copyright © 2016 Jordan Holmer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var levelPass: Int!         //holds the level choosen from the title screen
    var playerPass: Int!        //holds the number of players chosen from the title screen
    var blueCount: Int!         //used for differentiating between 2 and 4 blue cubes in play depending on the level
    var timer = NSTimer()
    var counter: Int = 60       //placeholder
    
    // the following variables are for movement of cubes
    var isMoving: Bool = false  //true if user is in the middle of moving a cube
    var isGoal: Bool = false    //true if user is moving a goal cube
    var isBlue: Bool = false    //true if user is moving a blue cube
    var isRed: Bool = false     //true if user is moving a red cube
    var isColor: Bool = false   //true if user is moving a color cube
    var indexFound: Int?        //hold the value of the index for which specific cube is being moved
    
    

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var numberOfCardsLabel: UILabel!
    @IBOutlet weak var cardsLabelText: UILabel!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var challengeButton: UIButton!
    
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
        cardsLabelText.hidden = true
        cardsStepper.hidden = true
        numberOfCardsLabel.hidden = true
        shuffleButton.hidden = true
        challengeButton.hidden = false
    }
    
    @IBAction func startButton(sender: AnyObject) {
        startTimer()
    }
    
    @IBAction func resetButton(sender: AnyObject) {
        endTimer()
        counter = 60
        timerLabel.text = String(counter)
    }
    
    @IBAction func pauseButton(sender: AnyObject) {
        endTimer()
    }
    
    
    //flip cards and/or flip number cubes
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInView(self.view)
            
            for var card = 0; card < Int(cardsStepper.value)  ; card += 1 {
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
    
    /*
    SPRINT 2 GOAL
    DEBUG THE MOVEMENT
    PROBLEM: WHEN USER MOVES ONE CUBE OVER THE OTHER IT WILL PICK UP ANOTHER IMAGEVIEW
    CURRENT STATUS: BUG SQUASHED!!!!!!
    */
    // move the cubes
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let location = touch.locationInView(self.view)
            
            // if no cube has started moving yet check to see if a cube has been touched
            // after determining which cube has been touched set the boolean variables
            // in addition set the indexFound variable to contain the index at which the cube was found
            if (!isMoving) {
                for var goal = 0; (goal < 3) && !isMoving; goal += 1 {
                    if collectionOfGoalDiceViews![goal].frame.contains(location) {
                        isMoving = true
                        isGoal = true
                        indexFound = goal
                    }
                }
                for var blue = 0; (blue < 3) && !isMoving; blue += 1 {
                    if collectionOfBlueDiceViews![blue].frame.contains(location) {
                        isMoving = true
                        isBlue = true
                        indexFound = blue
                    }
                }
                for var red = 0; (red < 4) && !isMoving; red += 1 {
                    if collectionOfRedDiceViews![red].frame.contains(location) {
                        isMoving = true
                        isRed = true
                        indexFound = red
                    }
                }
                for var color = 0; (color < 8) && !isMoving; color += 1 {
                    if collectionOfColoredDiceViews![color].frame.contains(location) {
                        isMoving = true
                        isColor = true
                        indexFound = color
                    }
                }
            // if a cube is in the process of being moved then stop searching and just move it
            } else {
                if isGoal {
                    collectionOfGoalDiceViews![indexFound!].center = location
                    collectionOfGoalDiceViews![indexFound!].image = collectionOfGoalDiceImages[goalDiceRolled[indexFound!]]
                }
                if isBlue {
                    collectionOfBlueDiceViews![indexFound!].center = location
                }
                if isRed {
                    collectionOfRedDiceViews![indexFound!].center = location
                }
                if isColor {
                    collectionOfColoredDiceViews![indexFound!].center = location
                }
            }
        }
    }
    
    /*
    When touches have ended reset all boolean variables
    This is necessary so that on the next cube movement
    the variables are fresh and not in states from the 
    previous movement
    */
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isMoving = false
        isGoal = false
        isBlue = false
        isRed = false
        isColor = false
    }
    
    
    
    func startTimer() {
        timer.invalidate() // just in case this button is tapped multiple times
        
        // start the timer
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerAction"), userInfo: nil, repeats: true)
    }
    
    func endTimer() {
        timer.invalidate()
    }
    
    func timerAction() {
        counter = counter - 1
        timerLabel.text = String(counter)
    }
    
    @IBAction func newGame(sender: AnyObject) {
        cardsLabelText.hidden = false
        cardsStepper.hidden = false
        numberOfCardsLabel.hidden = false
        shuffleButton.hidden = false
        challengeButton.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        challengeButton.hidden = true
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
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        //do som stuff from the popover
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //segue for the popover configuration window
        if segue.identifier == "challengeSegue" {
            let controller = segue.destinationViewController
            controller.popoverPresentationController!.delegate = self
            controller.preferredContentSize = CGSize(width: 400, height: 200)
            
            let svc = segue.destinationViewController as! ChallengeViewController
            svc.numberOfPlayers = playerPass
        }
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
