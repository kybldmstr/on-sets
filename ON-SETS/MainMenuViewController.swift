//
//  MainMenuViewController.swift
//  ON-SETS
//
//  Created by Jordan Holmer on 4/27/16.
//  Copyright © 2016 Jordan Holmer. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    @IBOutlet weak var levelSelector: UISegmentedControl!
    @IBOutlet weak var playerSelector: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "firstSegue") {
            let svc = segue.destinationViewController as! RulesViewController
            svc.levelPass = levelSelector.selectedSegmentIndex
            svc.playerPass = playerSelector.selectedSegmentIndex
        }
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
