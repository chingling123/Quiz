//
//  RegisterChoose.swift
//  QuizAdidas
//
//  Created by Laurent Lorena on 7/26/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit

class RegisterChooseController: UIViewController {
    
    var timer: NSTimer?
    var tempo: NSTimeInterval = 30
    
    @IBOutlet weak var btnNaoCadastrado: UIButton!
    @IBOutlet weak var btnJaCadastrado: UIButton!
    @IBOutlet weak var btnSemSMS: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!idiomaGeral){
            btnSemSMS.setImage(UIImage(named: "bt_resendEN"), forState: UIControlState.Normal)
            btnJaCadastrado.setImage(UIImage(named: "bt_already_registeredEN"), forState: UIControlState.Normal)
            btnNaoCadastrado.setImage(UIImage(named: "bt_not_registeredEN"), forState: UIControlState.Normal)
        }
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
            self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.timer?.invalidate()
        self.timer = nil;
    }
    
    @IBAction func btnIdle(sender: AnyObject) {
        self.resetTimer()
    }
    
    func resetTimer() {
        self.timer?.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
            self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
    }
    
    func decrementScore(){
        navigationController?.popToRootViewControllerAnimated(true)
    }

    
}
