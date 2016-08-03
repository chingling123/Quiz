//
//  PresentationController.swift
//  QuizAdidas
//
//  Created by Laurent Lorena on 7/26/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit

class PresentationController: UIViewController {
    
    var timer: NSTimer?
    var tempo: NSTimeInterval = 30

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
        self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
        

    }
    
    override func viewDidDisappear(animated: Bool) {
        self.timer!.invalidate()
        self.timer = nil;
    }
    
    @IBAction func btnIdle(sender: AnyObject) {
        self.resetTimer()
    }
    
    func decrementScore(){
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func resetTimer() {
        print("timer2")
        self.timer!.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
        self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
    }

}
