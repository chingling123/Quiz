//
//  OfficialRegister.swift
//  QuizAdidas
//
//  Created by Laurent Lorena on 7/26/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit

var DataNascRegister: NSDate = NSDate()

class OfficialRegisterController: UIViewController, AddDateDelegate, UITextFieldDelegate, AKMaskFieldDelegate {

    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCPF: AKMaskField!
    @IBOutlet weak var btnComecar: UIButton!
    @IBOutlet weak var btnProsseguir: UIButton!
    @IBOutlet weak var btnDataNasc: UIButton!
    @IBOutlet weak var txtCelular: AKMaskField!
    
    
    var timer: NSTimer?
    var tempo: NSTimeInterval = 30

        var animateDistance = CGFloat()


    var dataNasc: NSDate?
    
    var user: CadastroModel = CadastroModel()
        
    override func viewDidLoad() {
        
        if(!idiomaGeral){
            txtCPF.placeholder = "PASSPORT NUMBER:"
            txtName.placeholder = "NAME:"
            txtCelular.placeholder = "CELLPHONE NUMBER:"
            btnProsseguir.setImage(UIImage(named: "bt_nextEN"), forState: UIControlState.Normal)
            btnComecar.setImage(UIImage(named: "bt_startEN"), forState: UIControlState.Normal)
            
            txtCPF.mask = "{........}"
            
            txtCPF.maskDelegate = self
            
            txtCelular.mask = "({dd}) {ddddd}-{dddd}"
            
            txtCelular.maskDelegate = self
            
        }else{
            txtCPF.placeholder = "CPF:"
            txtName.placeholder = "NOME:"
            txtCelular.placeholder = "NUMERO DO TELEFONE:"

            btnProsseguir.setImage(UIImage(named: "bt_prosseguirPT"), forState: UIControlState.Normal)
            btnComecar.setImage(UIImage(named: "bt_comecarPT"), forState: UIControlState.Normal)
            
            txtCPF.mask = "{ddd}.{ddd}.{ddd}-{dd}"
            //txtCPF.maskTemplate = "123.456.789-00"
            txtCPF.maskDelegate = self
            
            txtCelular.mask = "({dd}) {ddddd}-{dddd}"
            //txtCelular.maskTemplate = "/(99/) 99999-9999"
            txtCelular.maskDelegate = self
        }
        
        super.viewDidLoad()
        btnComecar.hidden = true
        txtCelular.hidden = true
       // txtName.becomeFirstResponder()
        btnDataNasc.hidden = true

        //let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(btnIdle(_:)))
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
        self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)

        self.txtName.addTarget(self, action: #selector(OfficialRegisterController.btnIdle(_:)), forControlEvents: UIControlEvents.EditingChanged)
        self.txtCelular.addTarget(self, action: #selector(OfficialRegisterController.btnIdle(_:)), forControlEvents: UIControlEvents.EditingChanged)
        self.txtCPF.addTarget(self, action: #selector(OfficialRegisterController.btnIdle(_:)), forControlEvents: UIControlEvents.EditingChanged)
        self.txtEmail.addTarget(self, action: #selector(OfficialRegisterController.btnIdle(_:)), forControlEvents: UIControlEvents.EditingChanged)


    }
    
    override func viewDidDisappear(animated: Bool) {
//        self.timer?.invalidate()
//        self.timer = nil;
    }
    
    
    @IBAction func btnIdle(textField: UITextField) {
        resetTimer()
    }
    
    func resetTimer() {
        self.timer?.invalidate()
        self.timer = nil
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
            self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
    }
    
    func decrementScore(){
        print("cadastro")
        navigationController?.popToRootViewControllerAnimated(true)
    }

    
    @IBAction func btnComecar(sender: AnyObject) {
        user.celular = txtCelular.text
        
        if(validarSegundo()){
            self.timer?.invalidate()
            self.timer = nil
            postUser()
        }else{
            if !idiomaGeral {
                let alert = UIAlertController(title: "Alert", message: "ALL FIELDS ARE MANDATORY", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Alerta", message: "TODOS OS CAMPOS SÃO OBRIGATORIOS", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        	
    }
    
    func postUser(){
        let api = ApiClient(contentType: "application/json", customUrl: nil)
        
        ProgressView.shared.showProgressView(self)
        
        api.criarCadastro(user) { (success, message) in
            ProgressView.shared.hideProgressView()
            
            if success == true{
                let usuarioRecebido = CadastroModel.init(respostas: message)
                
                CurrentUser.sharedUser.id = usuarioRecebido.id
                CurrentUser.sharedUser.nome = usuarioRecebido.nome
                CurrentUser.sharedUser.email = usuarioRecebido.email
                CurrentUser.sharedUser.documento = usuarioRecebido.documento
                CurrentUser.sharedUser.celular = usuarioRecebido.celular
                CurrentUser.sharedUser.dtaNasc = usuarioRecebido.dtaNasc
                CurrentUser.sharedUser.criadoEm = usuarioRecebido.criadoEm
                CurrentUser.sharedUser.pontos = usuarioRecebido.pontos
                CurrentUser.sharedUser.acesso = usuarioRecebido.acesso
                CurrentUser.sharedUser.futebol = usuarioRecebido.futebol
                CurrentUser.sharedUser.basquete = usuarioRecebido.basquete
                CurrentUser.sharedUser.codigoAcesso = usuarioRecebido.codigoAcesso
                
                print(String(CurrentUser.sharedUser.id) as String+"      "+(CurrentUser.sharedUser.nome)!)
                
                if(CurrentUser.sharedUser.id != 0){
                    print("Cadastro Criado")
                    self.toQuestions()
                }
            }else{
                self.performSegueWithIdentifier("cpfUsado", sender: nil)
            }
        }

        
    }

    @IBAction func btnProsseguir(sender: AnyObject) {
        
        self.resetTimer()
        
        user.nome = txtName.text
        user.email = txtEmail.text
        user.documento = txtCPF.text
        if(validarPrimeiro()){
            txtCPF.hidden = true
            if(!idiomaGeral){
                txtEmail.placeholder = "DATE OF BIRTH:"
            }else{
                txtEmail.placeholder = "DATA DE NASCIMENTO:"
            }
            btnDataNasc.hidden = false
            
            txtName.hidden = true
            txtEmail.text = nil
            txtName.text = nil
            txtCelular.hidden = false
            
            
            btnProsseguir.hidden = true
            btnComecar.hidden = false
        }else{
            if !idiomaGeral {
                let alert = UIAlertController(title: "Alert", message: "ALL FIELDS ARE MANDATORY", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Alerta", message: "TODOS OS CAMPOS SÃO OBRIGATORIOS", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        

    }
    
    
    @IBAction func btnDataNasc(sender: AnyObject) {
        self.resetTimer()
        textFieldShouldReturn()
    }
    
    //faz esconder teclado
    func textFieldShouldReturn() -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func addDate(dataNasc: NSDate){
        
        let dateFormatter = NSDateFormatter()
        let realDate = NSDateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        realDate.dateFormat = "MM/dd/yyyy"
        
        if (DataNascRegister != ""){
            txtEmail.text = dateFormatter.stringFromDate(dataNasc)
            user.dtaNasc = realDate.stringFromDate(dataNasc)
        }
        
    }
    
    func validarPrimeiro() -> Bool{
        if(user.nome == "" || user.email == "" || user.documento == ""){
            return false
        }else{
            return true
        }
    }
    
    func validarSegundo() -> Bool{
        if(user.celular == "" || user.dtaNasc == ""){
            return false
        }else{
            return true
        }
        
    }
    
    func toQuestions(){
        self.timer?.invalidate()
        self.timer = nil
        performSegueWithIdentifier("toQuestion", sender: nil)
    }
    
    @IBAction func btnBack(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "popoverDate"){
            let view = segue.destinationViewController as! DatePikerController
            view.delegate = self
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        resetTimer()
        
        let textFieldRect : CGRect = self.view.window!.convertRect(textField.bounds, fromView: textField)
        let viewRect : CGRect = self.view.window!.convertRect(self.view.bounds, fromView: self.view)
        
        let midline : CGFloat = textFieldRect.origin.y + 0.5 * textFieldRect.size.height
        let numerator : CGFloat = midline - viewRect.origin.y - MoveKeyboard.MINIMUM_SCROLL_FRACTION * viewRect.size.height
        let denominator : CGFloat = (MoveKeyboard.MAXIMUM_SCROLL_FRACTION - MoveKeyboard.MINIMUM_SCROLL_FRACTION) * viewRect.size.height
        var heightFraction : CGFloat = numerator / denominator
        
        if heightFraction > 1.0 {
            heightFraction = 1.0
        }
        
        let orientation : UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        if (orientation == UIInterfaceOrientation.Portrait || orientation == UIInterfaceOrientation.PortraitUpsideDown) {
            animateDistance = floor(MoveKeyboard.PORTRAIT_KEYBOARD_HEIGHT * heightFraction)
        } else {
            animateDistance = floor(MoveKeyboard.LANDSCAPE_KEYBOARD_HEIGHT * heightFraction)
        }
        
        var viewFrame : CGRect = self.view.frame
        viewFrame.origin.y -= animateDistance
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(NSTimeInterval(MoveKeyboard.KEYBOARD_ANIMATION_DURATION))
        
        self.view.frame = viewFrame
        
        UIView.commitAnimations()
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
        var viewFrame : CGRect = self.view.frame
        viewFrame.origin.y += animateDistance
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        
        UIView.setAnimationDuration(NSTimeInterval(MoveKeyboard.KEYBOARD_ANIMATION_DURATION))
        
        self.view.frame = viewFrame
        
        UIView.commitAnimations()
        
    }
    

    func maskFieldShouldReturn(maskField: AKMaskField) {
        maskField.resignFirstResponder()
    }
    
    
    func maskFieldDidBeginEditing(maskField: AKMaskField){
        
        resetTimer()
        
        let textFieldRect : CGRect = self.view.window!.convertRect(maskField.bounds, fromView: maskField)
        let viewRect : CGRect = self.view.window!.convertRect(self.view.bounds, fromView: self.view)
        
        let midline : CGFloat = textFieldRect.origin.y + 0.5 * textFieldRect.size.height
        let numerator : CGFloat = midline - viewRect.origin.y - MoveKeyboard.MINIMUM_SCROLL_FRACTION * viewRect.size.height
        let denominator : CGFloat = (MoveKeyboard.MAXIMUM_SCROLL_FRACTION - MoveKeyboard.MINIMUM_SCROLL_FRACTION) * viewRect.size.height
        var heightFraction : CGFloat = numerator / denominator
        
        if heightFraction > 1.0 {
            heightFraction = 1.0
        }
        
        let orientation : UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        if (orientation == UIInterfaceOrientation.Portrait || orientation == UIInterfaceOrientation.PortraitUpsideDown) {
            animateDistance = floor(MoveKeyboard.PORTRAIT_KEYBOARD_HEIGHT * heightFraction)
        } else {
            animateDistance = floor(MoveKeyboard.LANDSCAPE_KEYBOARD_HEIGHT * heightFraction)
        }
        
        var viewFrame : CGRect = self.view.frame
        viewFrame.origin.y -= animateDistance
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(NSTimeInterval(MoveKeyboard.KEYBOARD_ANIMATION_DURATION))
        
        self.view.frame = viewFrame
        
        UIView.commitAnimations()
    }
    
    func maskFieldDidEndEditing(maskField: AKMaskField){
        var viewFrame : CGRect = self.view.frame
        viewFrame.origin.y += animateDistance
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        
        UIView.setAnimationDuration(NSTimeInterval(MoveKeyboard.KEYBOARD_ANIMATION_DURATION))
        
        self.view.frame = viewFrame
        
        UIView.commitAnimations()
        
    }

}
