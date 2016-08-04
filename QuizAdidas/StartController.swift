//
//  ViewController.swift
//  QuizAdidas
//
//  Created by Laurent Lorena on 7/26/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit
import Foundation

var idiomaGeral = true

class StartController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        CurrentUser.sharedUser.pontos = 0
    }
    
    @IBAction func btnStartEN(sender: AnyObject) {
        idiomaGeral = false
        self.performSegueWithIdentifier("fromStart", sender: nil)
    }

    @IBAction func btnStartPT(sender: AnyObject) {
        idiomaGeral = true
    }

}

