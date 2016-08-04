//
//  QueroParticiparController.swift
//  QuizAdidas
//
//  Created by Laurent Lorena on 7/29/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit

class QueroParticiparController: UIViewController {

    @IBOutlet weak var lblPreMap4: UILabel!
    @IBOutlet weak var lblPreMap3: UILabel!
    @IBOutlet weak var lblPreMap2: UILabel!
    @IBOutlet weak var lblPreMap1: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMap: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!idiomaGeral){
            btnMap.setImage(UIImage(named: "bt_mapEN"), forState: UIControlState.Normal)
            btnBack.setImage(UIImage(named: "bt_back-1EN"), forState: UIControlState.Normal)
        }else{
            btnMap.setImage(UIImage(named:"bt_mapaPT" ), forState: UIControlState.Normal)
            btnBack.setImage(UIImage(named:"bt_voltarPT" ), forState: UIControlState.Normal)
        }

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
