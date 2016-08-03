//
//  AlertaSMSViewController.swift
//  QuizAdidas
//
//  Created by Erik Nascimento on 03/08/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit

class AlertaSMSViewController: UIViewController {

    var timer: NSTimer?
    var tempo: NSTimeInterval = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
        self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okAction(sender: AnyObject) {
        decrementScore()
    }
    
    func decrementScore(){
        self.timer?.invalidate()
        self.timer = nil;
        navigationController?.popToRootViewControllerAnimated(true)
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
