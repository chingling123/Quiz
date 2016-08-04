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
    @IBOutlet weak var MiniTextPoints: UILabel!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!idiomaGeral){
            MiniTextPoints.text = "POINTS"
            btnQuero.setImage(UIImage(named: "bt_want_participateEN"), forState: UIControlState.Normal)
            btnProsseguir.setImage(UIImage(named: "bt_continueEN"), forState: UIControlState.Normal)
            btnEncerrar.setImage(UIImage(named: "bt_finishEN"), forState: UIControlState.Normal)
            imgRecebera.image = UIImage(named: "bt_cod_smsEN")
        }else{
            MiniTextPoints.text = "PONTOS"
            btnQuero.setImage(UIImage(named: "bt_quero_continuarPT"), forState: UIControlState.Normal)
            btnProsseguir.setImage(UIImage(named: "bt_prosseguirPT"), forState: UIControlState.Normal)
            btnEncerrar.setImage(UIImage(named: "bt_encerrar_participacaoPT"), forState: UIControlState.Normal)
            imgRecebera.image = UIImage(named: "bt_cod_sms")
        }
        
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
        self.timer?.invalidate()
        self.timer = nil;
    }
    
    @IBAction func btnIdle(sender: AnyObject) {
        self.resetTimer()
    }
    
    func decrementScore(){
        print("pontuacao")
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
        var textPontos: String!
        var textDicas: String!
        var myRange = NSRange()
        var myRange2 = NSRange()

        
        if(self.pontos < 6){
            if(!idiomaGeral){
                origemView = "maximo"
                lblTextPontos.text = "YOU`VE MADE"
                
                lblDicas.text = "YOU CAN KEEP PLAYONG AND WIN MORE. GO TO THE NEXT TOTEM"
                lblResultado.text = ""
                btnQuero.hidden = false
                btnEncerrar.hidden = false
                MiniTextPoints.text = "POINTS"
            }else{
                origemView = "maximo"
                lblTextPontos.text = "VOCÊ FEZ"
                lblResultado.text = ""
                lblDicas.text = "VOCÊ PODE CONTINUAR NO JOGO E GANHAR MAIS BÔNUS. DIRIJA-SE AO PRÓXIMO TOTEM"
                MiniTextPoints.text = "PONTOS"
                btnQuero.hidden = false
                btnEncerrar.hidden = false
            }
            
        }else{
            
            if(!idiomaGeral){
                MiniTextPoints.text = "POINTS"
                textPontos = "YOU`VE WON 2 EXTRA MINUTES IN THE BASKETBALL GAME OR"
                textDicas = "6 ADDTIONAL KICKS IN THE SOCCER GAME"
                myRange = NSRange(location: 6, length: 19)
                myRange2 = NSRange(location: 0, length: 18)
                 lblTextPontos.text = "CONGRATULATIONS! YOU ́VE MAX ́D OUT!"
            }else{
                MiniTextPoints.text = "PONTOS"
                textPontos = "VOCÊ GANHOU 2 MINUTOS EXTRA NA ATIVAÇÃO DE BASQUETE"
                textDicas = "OU 6 CHUTES ADICIONAIS NA ATIVAÇÃO DE FUTEBOL"
                lblTextPontos.text = "PARABÉNS VOCÊ FEZ A PONTUAÇÃO MÁXIMA"
                myRange = NSRange(location: 5, length: 16)
                myRange2 = NSRange(location: 3, length: 19)
            }
            
            lblPontos.text = "6"
            origemView = "minimo"

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
            if(!idiomaGeral){
                
               imgRecebera.hidden = true
            }else{
               imgRecebera.hidden = false
            }
            
            
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
