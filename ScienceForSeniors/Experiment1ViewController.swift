//
//  ViewController.swift
//  ScienceForSeniors
//
//  Created by Jasmine Jans on 3/11/20.
//  Copyright © 2020 EduTech. All rights reserved.
//

import UIKit
import RealityKit

class Experiment1ViewController: UIViewController {
    
    @IBOutlet var arExperimentView: ARView!
    @IBOutlet var NextButton: UIButton!
    
    var soapSteps:Experiment.DishSoap!
    var yeastSteps:Experiment.Yeast!
    var hpSteps:Experiment.HydrogenPeroxide!
    var FSteps:Experiment.FinalSteps!
    var end:Experiment.Finish!
    
    var currentScene:String!
    
    var nextActions:Experiment.NotifyAction!
    //var nextAction:Experiment.Yeast.Actions!
    //var hpAnchor:Experiment.HydrogenPeroxide!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.NextButton.isEnabled = false
        //self.NextButton.setTitle("Continue to next step", for: UIControl.State.normal)
        
        self.loadYeastSteps()
        
        //self.loadSoapSteps()
        
        //self.loadHPSteps()
        
        // Load the "soap" scene from the "Experiment" Reality File
        //let soapAnchor = try! Experiment.loadDishSoap()
        //soapAnchor.generateCollisionShapes(recursive: true)
        
        // Load the "yeast" scene from the "Experiment" Reality File
        //let yeastAnchor = try! Experiment.loadYeast()
        //yeastAnchor.generateCollisionShapes(recursive: true)
        
        // Load the "hydrogen peroxide" scene from the "Experiment" Reality File
        //let hpAnchor = try! Experiment.loadHydrogenPeroxide()
        //hpAnchor.generateCollisionShapes(recursive: true)
        
        // Add the soap anchor to the scene
        //arExperimentView.scene.anchors.append(soapAnchor)
        //arExperimentView.scene.anchors.append(yeastAnchor)
        //arExperimentView.scene.anchors.append(hpAnchor)
        //self.NextButton.isEnabled = false
        //let nextAction = yeastAnchor.actions.nextStepButton
        //self.setupNotifyActions()*/
    }
    
    func loadYeastSteps(){
        self.currentScene = "Yeast"
        
        Experiment.loadYeastAsync {result in
            switch result{
            case .success(let anchor):
                let yeastAnchor = anchor
               
               // Load the "yeast" scene from the "Experiment" Reality File
                yeastAnchor.generateCollisionShapes(recursive: true)

                self.arExperimentView.scene.anchors.append(yeastAnchor)

                self.yeastSteps = yeastAnchor
                
                self.NextButton.setTitle("Find the yeast", for: UIControl.State.disabled)
                
                self.setupYeastNotifyActions()
               
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    func loadSoapSteps(){
        self.currentScene = "Soap"
        print("in Soap scene")
        
        self.arExperimentView.scene.anchors.remove(at: 0)
        Experiment.loadDishSoapAsync {result in
            switch result{
            case .success(let anchor):
                let soapAnchor = anchor
                // Load the "soap" scene from the "Experiment" Reality File
                soapAnchor.generateCollisionShapes(recursive: true)
               
                // Add the soap anchor to the scene
                self.arExperimentView.scene.anchors.append(soapAnchor)
                print("added soap anchor")

                self.soapSteps = soapAnchor
                
                self.NextButton.setTitle("Find the soap", for: UIControl.State.disabled)
                
                self.setupSoapNotifyActions()

            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    func loadHPSteps(){
        self.currentScene = "HP"
        
        self.arExperimentView.scene.anchors.remove(at: 0)
        Experiment.loadHydrogenPeroxideAsync {result in
            switch result{
            case .success(let anchor):
                let hpAnchor = anchor

                hpAnchor.generateCollisionShapes(recursive: true)
               
                // Load the "hydrogen peroxide" scene from the "Experiment" Reality File
                self.arExperimentView.scene.anchors.append(hpAnchor)
                
                //arExperimentView.scene.anchors.append(hpAnchor)
                self.hpSteps = hpAnchor
                
                self.NextButton.setTitle("Find the Hyd. Perox.", for: UIControl.State.disabled)
                
                self.setupHPNotifyActions()
               
               //let nextAction = yeastAnchor.actions.nextStepButton
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    func loadFinalSteps(){
        self.currentScene = "Finish"
        
        self.arExperimentView.scene.anchors.remove(at: 0)
        Experiment.loadFinalStepsAsync {result in
            switch result{
            case .success(let anchor):
                let FSAnchor = anchor

                FSAnchor.generateCollisionShapes(recursive: true)
               
                // Load the "hydrogen peroxide" scene from the "Experiment" Reality File
                self.arExperimentView.scene.anchors.append(FSAnchor)
                
                //arExperimentView.scene.anchors.append(hpAnchor)
                self.FSteps = FSAnchor
                
                self.NextButton.setTitle("Tap the boxes next to each task to check them off", for: UIControl.State.disabled)
                
                self.setupFSNotifyActions()
               
               //let nextAction = yeastAnchor.actions.nextStepButton
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    func loadFinish(){
        self.currentScene = "End"
        
        self.arExperimentView.scene.anchors.remove(at: 0)
        Experiment.loadFinishAsync {result in
            switch result{
            case .success(let anchor):
                let endAnchor = anchor

                endAnchor.generateCollisionShapes(recursive: true)
               
                // Load the "hydrogen peroxide" scene from the "Experiment" Reality File
                self.arExperimentView.scene.anchors.append(endAnchor)
                
                //arExperimentView.scene.anchors.append(hpAnchor)
                self.end = endAnchor
                
                self.NextButton.setTitle("Try a new path...", for: UIControl.State.normal)
                
                self.NextButton.isEnabled = true
                print("enable button")
               
               //let nextAction = yeastAnchor.actions.nextStepButton
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    func setupYeastNotifyActions(){
        self.yeastSteps.actions.nextButton.onAction = self.nextButton(_:)
        //let nextAction = yeastAnchor.actions.nextButton
        //nextAction.onAction = self.nextButton(_:)
    }
    
    func setupHPNotifyActions(){
        self.hpSteps.actions.nextButton.onAction = self.nextButton(_:)
        //let nextAction = yeastAnchor.actions.nextButton
        //nextAction.onAction = self.nextButton(_:)
    }
    
    func setupSoapNotifyActions(){
        self.soapSteps.actions.nextButton.onAction = self.nextButton(_:)

        //let nextAction = yeastAnchor.actions.nextButton
        //nextAction.onAction = self.nextButton(_:)
    }
    
    func setupFSNotifyActions(){
        self.FSteps.actions.nextButton.onAction = self.nextButton(_:)
    }
    
    
    func nextButton(_ entity: Entity?){
       // guard let blah = entity else {return }
       // print(blah)
        
        self.NextButton.isEnabled = true
        self.NextButton.setTitle("Continue to next step...", for: UIControl.State.normal)
        print("enable button")
    }
    
    @IBAction func nextScene(sender:UIButton){
        self.NextButton.isEnabled = false
        
        if(currentScene == "Yeast"){
            self.yeastSteps.notifications.continueStep2.post()
            self.loadSoapSteps()
        }
        else if(currentScene == "Soap"){
            self.soapSteps.notifications.continueStep3.post()
            self.loadHPSteps()
        }
        else if(currentScene == "HP"){
            self.hpSteps.notifications.continueFinalSteps.post()
            self.loadFinalSteps()
        }
        else if(currentScene == "Finish"){
            self.FSteps.notifications.finish.post()
            self.loadFinish()
        }
        else{
            arExperimentView?.session.pause()
            arExperimentView?.removeFromSuperview()
            arExperimentView = nil
            NextButton?.removeFromSuperview()
            NextButton = nil
        }
    }
}
