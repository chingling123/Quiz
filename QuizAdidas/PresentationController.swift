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

    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var btnProsseguir: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!idiomaGeral){
            imgBG.image = UIImage(named: "bg3EN")
            btnProsseguir.setImage(UIImage(named: "bt_continueEN"), forState: UIControlState.Normal)
            
        }else{
            imgBG.image = UIImage(named: "bg3")
            btnProsseguir.setImage(UIImage(named: "bt_prosseguirPT"), forState: UIControlState.Normal)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
        self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.imgBG.addGestureRecognizer(gestureRecognizer)

    }
    
    func handleTap(sender: AnyObject) {
        self.resetTimer()
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
