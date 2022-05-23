//
//  Onboarding3ViewController.swift
//  Tekton_GoogleMaps
//
//  Created by Miguel on 23/05/22.
//

import Foundation
import UIKit

class Onboarding3ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "tabNavigationController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
}
