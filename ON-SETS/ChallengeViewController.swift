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
    var challengie: Int!
    var challengeType: Int!
    var timer = NSTimer()
    var counter: Int = 5

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
        } else { //second time choosing
            challengie = playerSelector.selectedSegmentIndex
            messageLabel.text = "Select SCORE when ready to present"
            playerSelector.hidden = true
            doneButton.hidden = true
            scoreButton.hidden = false
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
    }
    
    @IBAction func noAction(sender: AnyObject) {
        yesButton.hidden = true
        noButton.hidden = true
        if(challengeType == 0) { //now
            var scoreMessage = "Player "
            scoreMessage += String(challenger+1)
            scoreMessage += ": 2 points. Player "
            scoreMessage += String(challengie+1)
            scoreMessage += ": 6 points."
            messageLabel.text = scoreMessage
        } else {
            var scoreMessage = "Player "
            scoreMessage += String(challenger+1)
            scoreMessage += ": 6 points. Player "
            scoreMessage += String(challengie+1)
            scoreMessage += ": 2 points."
            messageLabel.text = scoreMessage
        }
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
