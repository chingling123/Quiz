//
//  ConfirmarAgendaController.swift
//  QuizAdidas
//
//  Created by Laurent Lorena on 7/29/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit

class ConfirmarAgendaController: UIViewController {
    
    var origem: String!

    @IBOutlet weak var viewGostaria: UIView!
    @IBOutlet weak var viewTemCerteza: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewGostaria.hidden = true
        viewTemCerteza.hidden = true
        viewGostaria.layer.cornerRadius = 25
        viewGostaria.layer.masksToBounds = true
        viewTemCerteza.layer.cornerRadius = 25
        viewTemCerteza.layer.masksToBounds = true
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
            self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.imgBG.addGestureRecognizer(gestureRecognizer)
        
        you()

    }
    
    
    var timer: NSTimer?
    var tempo: NSTimeInterval = 30
    @IBOutlet weak var imgBG: UIImageView!
    
    
    override func viewDidDisappear(animated: Bool) {
//        self.timer?.invalidate()
//        self.timer = nil;
    }
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        self.resetTimer()
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

    
    func you(){
        if(origemView == "maximo"){
            viewGostaria.hidden = false
            viewTemCerteza.hidden = true
        }else{
            viewTemCerteza.hidden = false
            viewGostaria.hidden = true
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "nao"{
            enviarSMS(CurrentUser.sharedUser.celular!)
        }
    }
    
    func enviarSMS(celular: String){
        let dadosSMS = AgendumPost()
        dadosSMS.idCadastro = CurrentUser.sharedUser.id
        dadosSMS.horario = celular
        let api = ApiClient(contentType: "application/json", customUrl: nil)
        api.postSMS(dadosSMS) { (success, message) in
            
        }
    }
    
    @IBAction func btnVoltar(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

}
