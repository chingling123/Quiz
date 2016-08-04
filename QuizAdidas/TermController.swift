//
//  TermController.swift
//  QuizAdidas
//
//  Created by Laurent Lorena on 7/26/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit


class TermController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var btnTermAcpet: UIButton!
    @IBOutlet weak var swtTermAcept: UISwitch!
    @IBOutlet weak var textRules: UITextView!
    @IBOutlet weak var textRulesEN: UITextView!
    
    @IBOutlet weak var imgBG: UIImageView!
    
    
    var timer: NSTimer?
    var tempo: NSTimeInterval = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textRulesEN.hidden = true
        
        if(!idiomaGeral){
            imgBG.image = UIImage(named: "bg10EN")
            btnTermAcpet.setImage(UIImage(named: "bt_acceptEN"), forState: UIControlState.Normal)
            textRules.hidden = true
            textRulesEN.hidden = false
        }else{
            imgBG.image = UIImage(named: "bg10PT")
            btnTermAcpet.setImage(UIImage(named: "bt_aceitoPT"), forState: UIControlState.Normal)
            textRules.hidden = false
            textRulesEN.hidden = true
        }
        
        
        btnTermAcpet.enabled = false
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
            self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(TermController.handleTap(_:)))
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.resetTimer()
        self.timer = nil;
    }

    
    override func viewDidDisappear(animated: Bool) {
        //self.timer?.invalidate()
    }
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        print("capturou gesto na view")
        self.resetTimer()
    }
    
    func resetTimer() {
        self.timer?.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
            self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
    }
    
    func decrementScore(){
        print("regulamento")
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func btnTermAcept(sender: AnyObject) {
        if(swtTermAcept.on){
            self.timer?.invalidate()
            self.timer = nil;
            performSegueWithIdentifier("toCreateRegister", sender: nil)
        }
    }

    @IBAction func swtTermAcept(sender: AnyObject) {
        if(swtTermAcept.on){
            btnTermAcpet.enabled = true
        }else{
             btnTermAcpet.enabled = false
        }
        
    }
}
