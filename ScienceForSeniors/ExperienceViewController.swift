//
//  ExperienceViewController.swift
//  ScienceForSeniors
//
//  This is the view controller for the screen that presents the different experience options (Exploding Eggs is the only implemented experience).
//  This handwritten class was set for defining an unwind seegue from the tutorial.
//
//  Created by Jasmine Jans on 4/18/20.
//  Copyright © 2020 EduTech. All rights reserved.
//

import Foundation
import UIKit
import RealityKit
import AVFoundation

class ExperienceViewController: UIViewController {
    
    /**
        Restricts rotation of the screen.
    */
    override func viewWillAppear(_ animated: Bool) {
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
    }
    
    /**
       Sets up the view with all necessary buttons and viewa
    */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
       Defines an unwind segue for when other pages navigate pack to this page.
           This allows a user to go back to this page without causing a back up in navigation.
    */
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    }
}
