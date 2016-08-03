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
    

    
    @IBOutlet weak var dtpDataNasc: UIDatePicker!
    var delegate: AddDateDelegate?

    public override func viewDidLoad() {
        dtpDataNasc.maximumDate = NSCalendar.currentCalendar().dateByAddingUnit(.Year, value: -14, toDate: NSDate(), options: [])
    }
    
    @IBAction func btnOk(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: {()->Void in
            self.delegate?.addDate(self.dtpDataNasc.date)
        });
    }

}
