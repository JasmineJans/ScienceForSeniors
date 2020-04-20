//
//  LearnSciViewController.swift
//  ScienceForSeniors
//
//  View Controller for presenting the first experience Learn path AR.
//  This screen presents the ARView with the molecular reaction animation.
//
//  Created by Jasmine Jans on 3/13/20.
//  Copyright © 2020 EduTech. All rights reserved.
//

import UIKit
import RealityKit

class LearnSciViewController: UIViewController {
    
    @IBOutlet var arLearnSciView: ARView!
    
    var aniAnchor:LearnSci1.ChemReaction!
    
    /**
       Sets up the view with all necessary AR objects, buttons and views
        This loads the learn animation from teh reality composer project file.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let aniAnchor = try! LearnSci1.loadChemReaction()
        aniAnchor.generateCollisionShapes(recursive: true)
        
        arLearnSciView.scene.anchors.append(aniAnchor)
    }
    
    /**
        Restricts rotation of the screen.
    */
    override func viewWillAppear(_ animated: Bool) {
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
    }
    
    /**
        Ends the AR scene and removes it from the stack
    */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arLearnSciView?.session.pause()
        arLearnSciView?.removeFromSuperview()
        arLearnSciView = nil
    }
}
