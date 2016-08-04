//
//  MapasController.swift
//  QuizAdidas
//
//  Created by Laurent Lorena on 7/29/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit

class MapasController: UIViewController {

    @IBOutlet weak var imgMapa: UIImageView!
    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet var lblMap: UILabel!
    @IBOutlet var btnVoltar: UIButton!
    @IBOutlet var btnIr: UIButton!
    
    var timer: NSTimer?
    var tempo: NSTimeInterval = 60
    
    let recognizer = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!idiomaGeral){
            lblMap.text = "MAP"
            btnVoltar.setImage(UIImage(named: "bt_backEN"), forState: UIControlState.Normal)
            btnIr.setImage(UIImage(named: "bt_proximo_totem"), forState: UIControlState.Normal)

        }else{
            lblMap.text = "MAPA"
            btnVoltar.setImage(UIImage(named: "bt_voltarPT"), forState: UIControlState.Normal)
            btnIr.setImage(UIImage(named: "bt_next_totemEN"), forState: UIControlState.Normal)
        }
        
        recognizer.addTarget(self, action: #selector(MapasController.profileImageHasBeenTapped))
        
        //finally, this is where we add the gesture recognizer, so it actually functions correctly
        imgMapa.addGestureRecognizer(recognizer)
        
        imgMapa.hidden = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.imgBG.addGestureRecognizer(gestureRecognizer)
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
    }
    
    override func viewDidDisappear(animated: Bool) {
//        self.timer?.invalidate()
//        self.timer = nil;
    }
    
    func profileImageHasBeenTapped(){
        imgMapa.hidden = true
    }
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        resetTimer()
        imgMapa.hidden = true
    }
    
    func resetTimer() {
        self.timer?.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
        self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
    }
    
    func decrementScore(){
        self.timer?.invalidate()
        self.timer = nil;
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func btnMapa1(sender: AnyObject) {
        resetTimer()
        imgMapa.hidden = false
        imgMapa.image = UIImage(named: "mapa1")
        
    }
    @IBAction func voltarAction(sender: AnyObject) {
        self.timer?.invalidate()
        self.timer = nil;
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func btnMapa2(sender: AnyObject) {
        resetTimer()
        imgMapa.image = UIImage(named: "mapa2")
        imgMapa.hidden = false
    }
}
