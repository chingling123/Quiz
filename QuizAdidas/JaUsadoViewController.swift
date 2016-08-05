//
//  JaUsadoViewController.swift
//  QuizAdidas
//
//  Created by Erik Nascimento on 8/4/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit

class JaUsadoViewController: UIViewController {

    @IBOutlet weak var imgBG: UIImageView!
    
    var timer: NSTimer?
    var tempo: NSTimeInterval = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if(!idiomaGeral){
            imgBG.image = UIImage(named: "existingDoc")
        }else{
            imgBG.image = UIImage(named: "cpfExistente")
        }
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(self.tempo, target: self, selector: #selector(self.decrementScore), userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func decrementScore(){
        print("cpfusado")
        navigationController?.popToRootViewControllerAnimated(true)
    }

    override func viewDidDisappear(animated: Bool) {
        print("mapa disappear")
        self.timer?.invalidate()
        self.timer = nil;
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
