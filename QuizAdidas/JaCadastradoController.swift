//
//  JaCadastrado.swift
//  QuizAdidas
//
//  Created by Laurent Lorena on 7/26/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit

class JaCadastradoController: UIViewController, AKMaskFieldDelegate {

    @IBOutlet weak var lblWarning: UILabel!
    @IBOutlet weak var txtCPF: AKMaskField!
    @IBOutlet weak var imgBack: UIImageView!
    
    var timer: NSTimer?
    var tempo: NSTimeInterval = 30

    var animateDistance = CGFloat() 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblWarning.hidden = true
        
        txtCPF.mask = "{ddd}.{ddd}.{ddd}-{dd}"
        //txtCPF.maskTemplate = "123.456.789-00"
        txtCPF.maskDelegate = self
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
            self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.imgBack.addGestureRecognizer(gestureRecognizer)
        self.txtCPF.addGestureRecognizer(gestureRecognizer)
        
        self.txtCPF.addTarget(self, action: #selector(JaCadastradoController.btnIdle(_:)), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    override func viewDidDisappear(animated: Bool) {
//        self.timer?.invalidate()
//        self.timer = nil;
    }
    
    func btnIdle(sender: AnyObject){
        self.resetTimer()
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

    @IBAction func btnValidar(sender: AnyObject) {
        
        txtCPF.resignFirstResponder()
        
        if(txtCPF.text == ""){
            lblWarning.text = "Esqueceu de nos informar seu documento!"
            lblWarning.hidden = false
        }else{
            ProgressView.shared.showProgressView(self)
            let api = ApiClient(contentType: "application/json", customUrl: nil)
            api.postCPF(txtCPF.text!, completion: { (success, message) in
                
                CurrentUser().intialize(message)
                ProgressView.shared.hideProgressView()
                if(success){
                    self.timer?.invalidate()
                    self.timer = nil;
                    self.performSegueWithIdentifier("fromJaCadastrado", sender: nil)
                }else{
                    self.timer?.invalidate()
                    self.timer = nil;
                    self.lblWarning.text = "CPF não cadastrado ou atingiu maximo de pontos"
                    self.lblWarning.hidden = false
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
