//
//  QueroParticiparController.swift
//  QuizAdidas
//
//  Created by Laurent Lorena on 7/29/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit

class QueroParticiparController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.timer = NSTimer.scheduledTimerWithTimeInterval(
            self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.imgBG.addGestureRecognizer(gestureRecognizer)
    }

    
    var timer: NSTimer?
    var tempo: NSTimeInterval = 30
    @IBOutlet weak var imgBG: UIImageView!

    
    override func viewDidDisappear(animated: Bool) {
//        self.timer?.invalidate()
//        self.timer = nil;
    }
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        resetTimer()
    }
    func resetTimer() {
        self.timer?.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
            tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
    }
    
    func decrementScore(){
        self.timer?.invalidate()
        self.timer = nil;
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func btnVoltar(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }


}
