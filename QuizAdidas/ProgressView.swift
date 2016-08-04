import UIKit


public class ProgressView : UIViewController {
    
    var rootViewController:UIViewController!
    let r = CAReplicatorLayer()
    
    class var shared: ProgressView {
        struct Static {
            static let instance: ProgressView = ProgressView()
        }
        Static.instance.view.frame = UIScreen.mainScreen().bounds
        return Static.instance
    }
    
    func showProgressView(viewController: UIViewController) {
        viewController.view.addSubview(view)
        
        self.view.backgroundColor = UIColor(white: 0x000000, alpha: 0.3)
        
        //let screen = UIScreen.mainScreen().bounds
        
        r.bounds = CGRect(x: self.view.frame.width/2-40, y: self.view.frame.height/2-40, width: 120.0, height: 120.0)
        r.cornerRadius = 10.0
        r.backgroundColor = UIColor(white: 0.0, alpha: 0.75).CGColor
        r.position = view.center

        let label = UILabel(frame: CGRectMake( self.view.frame.width/2-60,self.view.frame.height/2-60,r.bounds.width,r.bounds.height))
        
        if(!idiomaGeral){
            label.text = "Loading"
        }else{
            label.text = "Carregando"
        }
        
        
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        

        self.view.layer.addSublayer(r)
        self.view.addSubview(label)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.alpha = 1
        })
    }
    
    override public func viewWillLayoutSubviews() {
       // r.position = view.center
    }
    
    func hideProgressView() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.alpha = 0
            }) { (done:Bool) -> Void in
                self.view.removeFromSuperview()
        }
        
    }
}