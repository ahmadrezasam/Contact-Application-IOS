//
//  StartVC.swift
//  AhmadrezaSamiei_Project
//
//  Created by CTIS Student on 1.01.2022.
//  Copyright © 2022 CTIS. All rights reserved.
//

import UIKit
import Lottie

class AnimationVC: UIViewController {
    
    @IBOutlet weak var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lottieAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.performSegue(withIdentifier: "mySegue", sender: nil)  
        }
    }
    
    func lottieAnimation(){
        let animationView = AnimationView(name: "loading-circles")
        animationView.frame = CGRect(x: 0, y: 0, width: 360, height: 400)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFit
        view.addSubview(animationView)
        animationView.play()
        //animationView.loopMode = .loop
    }
    
}
