//
//  AgendaController.swift
//  QuizAdidas
//
//  Created by Laurent Lorena on 7/29/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit

class AgendaController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource{
    
    var timer: NSTimer?
    var tempo: NSTimeInterval = 30
    @IBOutlet weak var dtpAgenda: UIPickerView!
    @IBOutlet weak var imgBG: UIImageView!
    
    var agendaHorarios:AgendaHorariosArray = AgendaHorariosArray()
    
    let api = ApiClient(contentType: "application/json", customUrl: nil)
    
    var horarioAgenda:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressView.shared.showProgressView(self)
        api.getAgenda2 { (success, message) in
            ProgressView.shared.hideProgressView()
            if success{
                print(message)
                self.agendaHorarios = AgendaHorarios().initialize(message!)
                self.dtpAgenda.reloadAllComponents()
            }else{
                print("erro")
            }
        }
        
        origemView = "minimo"

        // Do any additional setup after loading the view.
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
            self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.imgBG.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewDidDisappear(animated: Bool) {
//        self.timer?.invalidate()
//        self.timer = nil;
    }
    
    func handleTap(sender: AnyObject) {
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
    
    @IBAction func btnConfirmar(sender: AnyObject) {
        if horarioAgenda != nil{
            let ag = AgendumPost()
            ag.horario = horarioAgenda
            ag.idCadastro = CurrentUser.sharedUser.id
            ProgressView.shared.showProgressView(self)
            api.postAgenda2(ag) { (success, message) in
                ProgressView.shared.hideProgressView()
                if(success){
                    self.enviarSMS(CurrentUser.sharedUser.celular!)
//                    let alert = UIAlertController(title: "Alerta", message: "HORÁRIO AGENDADO COM SUCESSO", preferredStyle: UIAlertControllerStyle.Alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    self.performSegueWithIdentifier("fromAgenda", sender: nil)
                }else{
                    let alert = UIAlertController(title: "Alerta", message: "HORÁRIO NÃO DISPONÍVEL PARA AGENDAMENTO, TENTE OUTRO!", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.dtpAgenda.reloadAllComponents()
                }
            }
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
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.agendaHorarios.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.agendaHorarios[row].horaToDisplay
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(self.agendaHorarios[row].horario)
        horarioAgenda = self.agendaHorarios[row].horario!
    }

}
