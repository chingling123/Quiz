//
//  LanguageController.swift
//  QuizAdidas
//
//  Created by Laurent Lorena on 7/26/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit

class LanguageController: UIViewController {
    
    var timer: NSTimer?
    var tempo: NSTimeInterval = 30
    
    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var btnComecar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!idiomaGeral){
            imgBG.image = UIImage(named: "ng2EN")
            btnComecar.setImage(UIImage(named: "bt_beginEN"), forState: UIControlState.Normal)
        }else{
            imgBG.image = UIImage(named: "bg2")
            btnComecar.setImage(UIImage(named: "bt_comecarPT"), forState: UIControlState.Normal)
        }
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(self.tempo, target: self, selector: #selector(LanguageController.decrementScore), userInfo: nil, repeats: false)

    }
    
    override func viewDidDisappear(animated: Bool) {
//        self.timer!.invalidate()
//        self.timer = nil;
    }
    
    @IBAction func btnIdle(sender: AnyObject) {
        self.resetTimer()
    }
    
    func resetTimer() {
        print("timer1")
        self.timer!.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
            self.tempo, target: self, selector: #selector(LanguageController.decrementScore), userInfo: nil, repeats: false)
    }
    
    func decrementScore(){
        self.timer?.invalidate()
        self.timer = nil;
        navigationController?.popToRootViewControllerAnimated(true)
    }


    @IBAction func btnSouBR(sender: AnyObject) {
        self.timer?.invalidate()
        self.timer = nil;
        performSegueWithIdentifier("SegExplanation", sender: self)
    }
    
}
