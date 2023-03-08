//
//  ViewController.swift
//  Reverbify
//
//  Created by Misbah Imtiaz on 2/27/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // starts animation with half second delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.animate()
        })
        
        // stops the animation after 4 seconds, goes to next screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            // This should either be the login page, or
            // if that user is signed in, the home page
                
            // Present the next view controller
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginController
            loginVC.modalTransitionStyle = .crossDissolve
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true)
        }
    }
    
    private func animate() {
        // pulse animation of logo
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.autoreverse, .repeat], animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }, completion: nil)
    }

}

