//
//  AlertaSMSFinalViewController.swift
//  QuizAdidas
//
//  Created by Erik Nascimento on 03/08/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit

class AlertaSMSFinalViewController: UIViewController {

    @IBOutlet var bkgImg: UIImageView!
    var timer: NSTimer?
    var tempo: NSTimeInterval = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(!idiomaGeral){
            bkgImg.image = UIImage(named: "TelasIngles")
        }else{
            bkgImg.image = UIImage(named: "Telas Quiz altarado9")
        }
        
        // Do any additional setup after loading the view.
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
            self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.timer?.invalidate()
        self.timer = nil;
    }
    
    func decrementScore(){
        self.performSegueWithIdentifier("final", sender: nil)
    }
    

    
}
