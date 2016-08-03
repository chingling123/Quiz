//
//  PontuacaoController.swift
//  QuizAdidas
//
//  Created by Laurent Lorena on 7/29/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit


var origemView: String?

class PontuacaoController: UIViewController {
    
    var timer: NSTimer?
    var tempo: NSTimeInterval = 30

    
    var pontos : Int?
    @IBOutlet weak var lblPontos: UILabel!
    @IBOutlet weak var lblTextPontos: UILabel!
    @IBOutlet weak var lblResultado: UILabel!
    @IBOutlet weak var lblDicas: UILabel!
    @IBOutlet weak var btnQuero: UIButton!
    @IBOutlet weak var btnEncerrar: UIButton!
    @IBOutlet weak var btnProsseguir: UIButton!
    @IBOutlet weak var imgRecebera: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblPontos.text = String(pontos!)
        btnQuero.hidden = true
        btnEncerrar.hidden = true
        btnProsseguir.hidden = true
        imgRecebera.hidden = true
        
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
            self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.btnIdle(_:)))
        self.view.addGestureRecognizer(gestureRecognizer)
 
        settingResultado()
    }
    
    override func viewDidDisappear(animated: Bool) {
//        self.timer?.invalidate()
//        self.timer = nil;
    }
    
    @IBAction func btnIdle(sender: AnyObject) {
        self.resetTimer()
    }
    
    func decrementScore(){
        self.timer?.invalidate()
        self.timer = nil;
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func resetTimer() {
        self.timer?.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
            self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
    }


    func settingResultado(){
        print(self.pontos)
        if(self.pontos < 36){
            origemView = "maximo"
            lblTextPontos.text = "VOCÊ FEZ"
            lblDicas.text = "VOCÊ PODE CONTINUAR NO JOGO E GANHAR MAIS BÔNUS. DIRIJA-SE AO PRÓXIMO TOTEM"
            
            btnQuero.hidden = false
            btnEncerrar.hidden = false
            
        }else{
            
            lblPontos.text = "36"
            origemView = "minimo"
            let myRange = NSRange(location: 5, length: 16)
            let myRange2 = NSRange(location: 3, length: 19)
            let textPontos = "VOCÊ GANHOU 2 MINUTOS EXTRA NA ATIVAÇÃO DE BASQUETE"
            let textDicas = "OU 6 CHUTES ADICIONAIS NA ATIVAÇÃO DE FUTEBOL"
            let myMutableString = NSMutableAttributedString(string: textPontos)
            
            myMutableString.addAttributes([NSFontAttributeName:UIFont(
                name: "adineuePRO-Black",
                size: 21.0)!], range: myRange)
            
            let myMutableString2 = NSMutableAttributedString(string: textDicas)
            
            myMutableString2.addAttributes([NSFontAttributeName:UIFont(
                name: "adineuePRO-Black",
                size: 21.0)!], range: myRange2)
            
            lblResultado.attributedText = myMutableString
            lblDicas.attributedText = myMutableString2
            
            btnQuero.hidden = true
            btnEncerrar.hidden = true
            btnProsseguir.hidden = false
            imgRecebera.hidden = false
            
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

}
