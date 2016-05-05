//
//  ChallengeViewController.swift
//  ON-SETS
//
//  Created by Jordan Holmer on 5/3/16.
//  Copyright © 2016 Jordan Holmer. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController {
    
    var numberOfPlayers: Int!
    var challenger: Int = -1
    var challengie: Int = -1
    var thirdPartySide: Int!
    var thirdParty: Int!
    var challengeType: Int!
    var timer = NSTimer()
    var counter: Int = 121
    
    var firstJudgement: Bool!
    var secondJudgement: Bool!
    var secondJudge = false

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var challengeTypeSelector: UISegmentedControl!
    @IBOutlet weak var playerSelector: UISegmentedControl!
    @IBOutlet weak var challengeButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    
    @IBAction func continueAction(sender: AnyObject) {
        
        if(challenger < 0) { //first time choosing
            messageLabel.text = "Who is being challenged?"
            challenger = playerSelector.selectedSegmentIndex
        } else if(challengie < 0) { //second time choosing
            challengie = playerSelector.selectedSegmentIndex
            messageLabel.text = "Who will the third party side with?"
        } else {
            thirdPartySide = playerSelector.selectedSegmentIndex
            messageLabel.text = "Select SCORE when ready to present"
            playerSelector.hidden = true
            doneButton.hidden = true
            scoreButton.hidden = false
            whoseOnThird()
            startTimer()
        }
    }
    
    @IBAction func challengeAction(sender: AnyObject) {
        challengeType = challengeTypeSelector.selectedSegmentIndex
        playerSelector.hidden = false
        doneButton.hidden = false
        challengeTypeSelector.hidden = true
        challengeButton.hidden = true
        messageLabel.text = "Who is the challenger?"
    }
    
    func whoseOnThird() {
        let thirdSum = challengie + challenger
        if (thirdSum == 1) {
            thirdParty = 2
        }
        if (thirdSum == 2) {
            thirdParty = 1
        }
        if(thirdSum == 3) {
            thirdParty = 0
        }
        
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
        if(counter >= 0) {
            timerLabel.text = String(counter)
        } else {
            score()
        }
    }
    
    @IBAction func scoreAction(sender: AnyObject) {
        score()
    }
    
    func score() {
        endTimer()
        scoreButton.hidden = true
        timerLabel.hidden = true
        yesButton.hidden = false
        noButton.hidden = false
        
        var finalMessage = "Did player "
        if (challengeType == 0) { //now
            finalMessage += String(challenger+1)
        } else { //never
            finalMessage += String(challengie+1)
        }
        finalMessage += " present a correct solution?"
        
        messageLabel.text = finalMessage
        
    }
    
    @IBAction func yesAction(sender: AnyObject) {
        
        if(!secondJudge) {
            firstJudgement = true
            secondJudge = true
            if (challengeType == 0) { //now
                if (thirdPartySide == challenger) { //side with now challenger
                    messageLabel.text = "Did player thirdparty present a correct solution?"
                } else {
                    secondJudgement = false // third party is wrong
                    displayScore()
                }
            } else { //never {
                if (thirdPartySide == challengie) {
                    messageLabel.text = "Did player thirdparty present a correct solution?"
                } else {
                    secondJudgement = false
                    displayScore()
                }
            }
        } else {
            secondJudgement = true
            displayScore()
        }
        
        
        
        /*
        yesButton.hidden = true
        noButton.hidden = true
        if(challengeType == 0) { //now
            var scoreMessage = "Player "
            scoreMessage += String(challenger+1)
            scoreMessage += ": 6 points. Player "
            scoreMessage += String(challengie+1)
            scoreMessage += ": 2 points."
            messageLabel.text = scoreMessage
        } else {
            var scoreMessage = "Player "
            scoreMessage += String(challenger+1)
            scoreMessage += ": 2 points. Player "
            scoreMessage += String(challengie+1)
            scoreMessage += ": 6 points."
            messageLabel.text = scoreMessage
        }
 */
    }
    
    @IBAction func noAction(sender: AnyObject) {
        
        if(!secondJudge) {
            firstJudgement = false
            secondJudge = true
            if (challengeType == 0) { //now
                if (thirdPartySide == challenger) { //side with now challenger
                    messageLabel.text = "Did player thirdparty present a correct solution?"
                } else {
                    secondJudgement = true // third party is wrong
                    displayScore()
                }
            } else { //never {
                if (thirdPartySide == challengie) {
                    messageLabel.text = "Did player thirdparty present a correct solution?"
                } else {
                    secondJudgement = true
                    displayScore()
                }
            }
        } else {
            secondJudgement = false
            displayScore()
        }
    }
    
    func displayScore() {
        yesButton.hidden = true
        noButton.hidden = true
        
        var scoreMessage = "P"
        
        if (challengeType == 0) { //now
            
            scoreMessage += String(challenger + 1)
            scoreMessage += ": "
            
            if (firstJudgement!) {
                scoreMessage += "6pts. "
            } else {
                scoreMessage += "2pts. "
            }
            scoreMessage += "P"
            scoreMessage += String(thirdParty + 1)
            scoreMessage += ": "
            if (secondJudgement!) {
                scoreMessage += "4pts. "
            } else {
                scoreMessage += "2pts. "
            }
            scoreMessage += "P"
            scoreMessage += String(challengie + 1)
            scoreMessage += ": "
            if (firstJudgement! || secondJudgement!) {
                scoreMessage += "2pts."
            } else {
                scoreMessage += "6pts."
            }
        } else { //never
            
            scoreMessage += String(challengie + 1)
            scoreMessage += ": "
            
            if (firstJudgement!) {
                scoreMessage += "6pts. "
            } else {
                scoreMessage += "2pts. "
            }
            scoreMessage += "P"
            scoreMessage += String(thirdParty + 1)
            scoreMessage += ": "
            if (secondJudgement!) {
                scoreMessage += "4pts. "
                secondJudgement = false
            } else {
                scoreMessage += "2pts. "
            }
            scoreMessage += "P"
            scoreMessage += String(challenger + 1)
            scoreMessage += ": "
            if (firstJudgement! || secondJudgement!) {
                scoreMessage += "2pts."
            } else {
                scoreMessage += "6pts."
            }
        }
        messageLabel.text = scoreMessage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerSelector.hidden = true
        doneButton.hidden = true
        scoreButton.hidden = true
        yesButton.hidden = true
        noButton.hidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
