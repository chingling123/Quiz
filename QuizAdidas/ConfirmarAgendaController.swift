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
    //viewCerteza
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTemCerteza: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    
    //viewGostaria
    @IBOutlet weak var lblQuerPedalar: UILabel!
    @IBOutlet weak var lblAgendeSuaParticipação: UILabel!
    @IBOutlet weak var btnNao: UIButton!
    @IBOutlet weak var btnSim: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!idiomaGeral){
            
            //ViewCerteza
            lblTemCerteza.text = "Are your sure you don`t want to schedule your participation now?"
            btnBack.setTitle("BACK", forState: UIControlState.Normal)
            btnYes.setTitle("YES", forState: UIControlState.Normal)
            
            //ViewGostaria
            btnNao.setTitle("NO", forState: UIControlState.Normal)
            btnSim.setTitle("YES", forState: UIControlState.Normal)
            lblQuerPedalar.text = "WOULD YOU LIKE TO SCHEDULE YOUR PARTICIPATION AND RIDE A BIKE ON THE STREETS OF MONACO OR RUN ON A RUNNING TRACK ALONGSIDE GREAT ATHLETES?"
            lblAgendeSuaParticipação.text = "SCHEDULE HERE YOUR VIRTUAL EXPERIECNCE AT THE ADIDAS CREATORS BASE."
            
        }else{
            //ViewCerteza
            lblTemCerteza.text = "Tem certeza de que não quer agendar agora?"
            btnBack.setTitle("VOLTAR", forState: UIControlState.Normal)
            btnYes.setTitle("SIM", forState: UIControlState.Normal)
            
            //ViewGostaria
            lblQuerPedalar.text = "QUER PEDALAR PELAS RUAS DE MÔNACO OU CORRER NUMA PISTA DE ATLETISMO AO LADO DE GRANDES ATLETAS?"
            lblAgendeSuaParticipação.text = "AGENDE SUA PARTICIPAÇÃO NA EXPERIÊNCIA DE REALIDADE VIRTUAL DA ADIDAS CREATORS BASE."
            btnNao.setTitle("NÃO", forState: UIControlState.Normal)
            btnSim.setTitle("SIM", forState: UIControlState.Normal)
            
        }
        
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
