//
//  DatePikerController.swift
//  QuizAdidas
//
//  Created by Laurent Lorena on 7/28/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit

protocol AddDateDelegate {
    func addDate(data: NSDate)
}

public class DatePikerController: UIViewController{
    

    @IBOutlet var okButton: UIButton!
    
    @IBOutlet weak var dtpDataNasc: UIDatePicker!
    var delegate: AddDateDelegate?

    public override func viewDidLoad() {
        
        okButton.layer.cornerRadius = 10
        okButton.layer.masksToBounds = true
        
        if !idiomaGeral {
            dtpDataNasc.locale = NSLocale(localeIdentifier: "en-US")
        }else{
            dtpDataNasc.locale = NSLocale(localeIdentifier: "pt-BR")
        }
        
        //dtpDataNasc.maximumDate = NSCalendar.currentCalendar().dateByAddingUnit(.Year, value: -14, toDate: NSDate(), options: [])
    }
    
    @IBAction func btnOk(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: {()->Void in
            self.delegate?.addDate(self.dtpDataNasc.date)
        });
    }

}
