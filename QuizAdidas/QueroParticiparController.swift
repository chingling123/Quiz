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
    
    var timer: NSTimer?
    var tempo: NSTimeInterval = 30
    @IBOutlet weak var imgBG: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!idiomaGeral){
            btnMap.setImage(UIImage(named: "bt_mapEN"), forState: UIControlState.Normal)
            btnBack.setImage(UIImage(named: "bt_back-1EN"), forState: UIControlState.Normal)
            lblPreMap1.text = "TO KEEP PLAYING,"
            lblPreMap2.text = "PLEASE TYPE IN THE CPF / PASSPORT NUMBER IN THE NEXT TOTEM"
            lblPreMap3.text = "AND GATHER MORE POINTS AT EACH CORRECT ANSWER"
            lblPreMap4.text = ""
        }else{
            btnMap.setImage(UIImage(named:"bt_mapaPT" ), forState: UIControlState.Normal)
            btnBack.setImage(UIImage(named:"bt_voltarPT" ), forState: UIControlState.Normal)
            lblPreMap1.text = "PARA CONTINUAR NO JOGO,"
            lblPreMap2.text = "INSIRA O CPF DE CADASTRO NO TOTEM MAIS PRÓXIMO"
            lblPreMap3.text = "E ACUMULE MAIS PONTOS A CADA NOVA"
            lblPreMap4.text = "PERGUNTA RESPONDIDA CORRETAMENTE"
        }
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
            self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.imgBG.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewDidDisappear(animated: Bool) {
        print("particiar disappear")
        self.timer?.invalidate()
        self.timer = nil;
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
        print("participar")
        self.timer?.invalidate()
        self.timer = nil;
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func btnVoltar(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }


}
