//
//  QuestionsController.swift
//  QuizAdidas
//
//  Created by Laurent Lorena on 7/29/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit

class QuestionsController: UIViewController {
    
    var counter = 15
    var timer: NSTimer?
    var tempo: NSTimeInterval = 40
    var rTempo: NSTimeInterval = 15
    var pontos: Int = 0
    var perguntas = [PerguntaModel]()
    var i: Int = 0
    var respondidas:[RespostaModel]!
    
    var respostaCerta: String!

    @IBOutlet var lblCounter: UILabel!
    @IBOutlet weak var btnOpcaoB: UIButton!
    @IBOutlet weak var btnOpcaoC: UIButton!
    @IBOutlet weak var btnOpcaoA: UIButton!
    @IBOutlet weak var btnProsseguir: UIButton!
    @IBOutlet weak var lblPergunta: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        respondidas = [RespostaModel(),RespostaModel(),RespostaModel(),RespostaModel(),RespostaModel(),RespostaModel()]
        if(CurrentUser.sharedUser.pontos != nil){
            pontos = CurrentUser.sharedUser.pontos!
        }
    
        setCustomBtn()
        getPerguntas()
        
    }
    
    func getPerguntas(){
        ProgressView.shared.showProgressView(self)
        let api = ApiClient(contentType: "application/json", customUrl: nil)
        api.getPerguntas { (success, message) in

            for i in message!{
                let p = PerguntaModel.init(pergunta: i as! JSONDictionary)
                self.perguntas.append(p)
            }
            

            self.CreateQuestionTimer()
            self.realQuiz()
            ProgressView.shared.hideProgressView()
        }
    }
    
    func CreateQuestionTimer(){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
    }
    
    func updateCounter() {
        self.counter -= 1
        if self.counter < 0 {
            self.proxPorTempo()
        }
        else {
            self.lblCounter.text = "\(self.counter)"
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
//        self.timer?.invalidate()
//        self.timer = nil;
    }
    
    func realQuiz(){
        
        if(i==6){
            sendRespostas()
        }else{
        
            self.respostaCerta = perguntas[self.i].respc
            //self.respondidas.append(RespostaModel())
            self.respondidas[self.i].idPergunta = perguntas[self.i].id
            self.respondidas[self.i].idCadastro = CurrentUser.sharedUser.id
            self.respondidas[self.i].resposta1 = "Não respondeu"
            self.respondidas[self.i].correta = false
            
            var respostas: Array<String> = []
            respostas.append(perguntas[self.i].respA!)
            respostas.append(perguntas[self.i].respB!)
            respostas.append(perguntas[self.i].respc!)
            
            respostas = shuffle(respostas)
        
            lblPergunta.text = perguntas[self.i].questao
            btnOpcaoA.setTitle(String(format: "A) %@", respostas[0]), forState: UIControlState.Normal)
            btnOpcaoB.setTitle(String(format: "B) %@", respostas[1]), forState: UIControlState.Normal)
            btnOpcaoC.setTitle(String(format: "C) %@", respostas[2]), forState: UIControlState.Normal)
        
            print("\(self.i) \(respondidas[self.i].idCadastro)")
        
        }
        
    }

    
    func proxPorTempo(){
        
        self.counter = 15
        self.lblCounter.text = "\(self.counter)"
        self.i += 1
        //self.resetTimer(rTempo)
        self.resetTimer(tempo)
        self.realQuiz()
    }
    
    func strTratament(str: String) -> String{
        return str.substringWithRange(Range<String.Index>(start: str.startIndex.advancedBy(3), end: str.endIndex.advancedBy(0)))
    }
    
    @IBAction func btnOpcaoA(sender: UIButton) {
        self.resetTimer(self.tempo)
        
        if(strTratament(sender.titleLabel!.text!) == self.respostaCerta){
            pontos = pontos+1
            self.respondidas[self.i].correta = true
        }else{
            self.respondidas[self.i].correta = false
        }
        self.respondidas[self.i].resposta1 = strTratament(sender.titleLabel!.text!)
        self.proxPorTempo()
        
    }
    
    @IBAction func btnOpcaoB(sender: UIButton) {
        self.resetTimer(self.tempo)
        
        if(strTratament(sender.titleLabel!.text!) == self.respostaCerta){
            pontos = pontos+1
            self.respondidas[self.i].correta = true
        }else{
            self.respondidas[self.i].correta = false
        }
        self.respondidas[self.i].resposta1 = strTratament(sender.titleLabel!.text!)
        self.proxPorTempo()
    }
    
    @IBAction func btnOpcaoC(sender: UIButton) {
        self.resetTimer(self.tempo)
        
        if(strTratament(sender.titleLabel!.text!) == self.respostaCerta){
            pontos = pontos+1
            self.respondidas[self.i].correta = true
        }else{
            self.respondidas[self.i].correta = false
        }
        self.respondidas[self.i].resposta1 = strTratament(sender.titleLabel!.text!)
        self.proxPorTempo()
    }
    
    
    func setCustomBtn(){
        
        btnOpcaoA.titleLabel!.text = ""
        btnOpcaoB.titleLabel!.text = ""
        btnOpcaoC.titleLabel!.text = ""
        lblPergunta.text = ""
        
        btnOpcaoA.layer.borderWidth = 2
        btnOpcaoA.layer.cornerRadius = 15
        btnOpcaoA.layer.masksToBounds = true
        btnOpcaoA.layer.borderColor = UIColor (red: 1, green: 0, blue: 0, alpha: 1).CGColor
        
        btnOpcaoB.layer.borderWidth = 2
        btnOpcaoB.layer.cornerRadius = 15
        btnOpcaoB.layer.masksToBounds = true
        btnOpcaoB.layer.borderColor = UIColor (red: 1, green: 0, blue: 0, alpha: 1).CGColor
        
        btnOpcaoC.layer.borderWidth = 2
        btnOpcaoC.layer.cornerRadius = 15
        btnOpcaoC.layer.masksToBounds = true
        btnOpcaoC.layer.borderColor = UIColor (red: 1, green: 0, blue: 0, alpha: 1).CGColor
    
    }
    
    func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
        let countVar = list.count
        for i in 0..<(countVar - 1) {
            let j = Int(arc4random_uniform(UInt32(countVar - i))) + i
            if i != j{
                swap(&list[i], &list[j])
            }
        }
        return list
    }
    
    @IBAction func btnIdle(sender: AnyObject) {
        self.resetTimer(self.tempo)
    }
    
    func resetTimer(temp : NSTimeInterval) {
        self.timer!.invalidate()
        self.timer = nil
        if(i < 6){
            self.CreateQuestionTimer()
        }
//        self.timer?.invalidate()
//        self.timer = NSTimer.scheduledTimerWithTimeInterval(
//            temp, target: self, selector: #selector(QuestionsController.decrementScore), userInfo: nil, repeats: false)
    }
    
    func decrementScore(){
        self.timer?.invalidate()
        self.timer = nil;
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "goToResult") {
            let secondViewController = segue.destinationViewController as! PontuacaoController
            secondViewController.pontos = self.pontos
        }
    }
    
    func sendRespostas(){
        ProgressView.shared.showProgressView(self)
        let api = ApiClient(contentType: "application/json", customUrl: nil)
        
        api.postRespostas(respondidas){ (success, message) in
            ProgressView.shared.hideProgressView()
            self.performSegueWithIdentifier("goToResult", sender: self.pontos)
        }
        
    }


}
