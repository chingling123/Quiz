//
//  NoSMSController.swift
//  QuizAdidas
//
//  Created by Laurent Lorena on 7/26/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit

class NoSMSController: UIViewController, AKMaskFieldDelegate {

    @IBOutlet weak var txtSMS: AKMaskField!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet var lblAlert: UILabel!
    var alertaTitle: String!
    var alertaText: String!
    var celularInvalido: String!
    
    
    @IBOutlet weak var btnReenviar: UIButton!
    @IBOutlet weak var btnVoltar: UIButton!
    @IBOutlet weak var lblSMS: UILabel!
    
    var timer: NSTimer?
    var tempo: NSTimeInterval = 30
    
    var animateDistance = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!idiomaGeral){
            celularInvalido = "Cellphone not found."
            alertaTitle = "ALERT"
            alertaText = "FORGOT TO INSERT THE  CELLPHONE NUMBER"
            btnVoltar.setImage(UIImage(named: "bt_backEN"), forState: UIControlState.Normal)
            btnReenviar.setImage(UIImage(named: "bt_validateEN"), forState: UIControlState.Normal)
            lblSMS.text = "TYPE IN THE PHONE NUMBER YOU INFORMED IN THE REGISTRATION"
        }else{
            celularInvalido = "Celular não encontrado."
            alertaTitle = "ALERTA"
            alertaText = "ESQUECEU DE INSERIR O NUMERO DO CELULAR"
            lblSMS.text = "DIGITE SEU TELEFONE UTILIZADO NO CADASTRO"
            btnVoltar.setImage(UIImage(named: "bt_voltarPT"), forState: UIControlState.Normal)
            btnReenviar.setImage(UIImage(named: "bt_reeviarPT"), forState: UIControlState.Normal)

        }
        
        self.lblAlert.hidden = true
        
        txtSMS.mask = "({dd}) {ddddd}-{dddd}"
        //txtSMS.maskTemplate = "/(99/) 99999-9999"
        txtSMS.maskDelegate = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.imgBack.addGestureRecognizer(gestureRecognizer)
        self.txtSMS.addGestureRecognizer(gestureRecognizer)
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
        self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
    }
    
    override func viewDidDisappear(animated: Bool) {
        print("nosms disappear")
        self.timer?.invalidate()
        self.timer = nil;
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
        print("nosms")
        navigationController?.popToRootViewControllerAnimated(true)
    }


    @IBAction func btnReeviar(sender: AnyObject) {
        if(txtSMS.text == ""){
            let alert = UIAlertController(title: alertaTitle, message: alertaText, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            ProgressView.shared.showProgressView(self)
            let api = ApiClient(contentType: "application/json", customUrl: nil)
            api.postReSMS(txtSMS.text!, completion: { (success, message) in
                ProgressView.shared.hideProgressView()
//                self.timer?.invalidate()
//                self.timer = nil;
                if(success){
                    self.performSegueWithIdentifier("smsText", sender: nil)
                }else{
                    self.lblAlert.text = self.celularInvalido
                    self.lblAlert.hidden = false
                }
            })
        }
    }
    @IBAction func voltarAction(sender: AnyObject) {
        
        decrementScore()
    }
    
    func maskFieldShouldReturn(maskField: AKMaskField) {
        maskField.resignFirstResponder()
    }
    
    
    func maskFieldDidBeginEditing(maskField: AKMaskField){
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
