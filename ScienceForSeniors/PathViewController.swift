//
//  PathViewController.swift
//  ScienceForSeniors
//
//  This is the view controller for the screen that presents the different path options (Learn, Experiment, Discover).
//  This handwritten class was set for defining an unwind seegue from the paths and the tutorial.
//
//  Created by Jasmine Jans on 4/4/20.
//  Copyright © 2020 EduTech. All rights reserved.
//

import Foundation
import UIKit
import RealityKit
import AVFoundation

class PathViewController: UIViewController {
    
    /**
       Sets up the view with all necessary buttons and viewa
    */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
        Restricts rotation of the screen.
    */
    override func viewWillAppear(_ animated: Bool) {
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
    }
    
    /**
       Defines an unwind segue for when other pages navigate pack to this page.
           This allows a user to go back to this page without causing a back up in navigation.
    */
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    }
    
    
}
