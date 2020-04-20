//
//  Experiment1ViewController.swift
//  ScienceForSeniors
//
//  View Controller for presenting the first experience Experiment path AR.
//  This screen presents the ARView that includes the experiment ingredient object recognition and instructions for completing the experiment.
//
//  Created by Jasmine Jans on 3/11/20.
//  Copyright © 2020 EduTech. All rights reserved.
//

import UIKit
import RealityKit

class Experiment1ViewController: UIViewController {
    
    @IBOutlet var arExperimentView: ARView!
    @IBOutlet var NextButton: UIButton!
    
    //set up the anchors and objects that will be used from reality composer project
    var soapSteps:Experiment.DishSoap!
    var yeastSteps:Experiment.Yeast!
    var hpSteps:Experiment.HydrogenPeroxide!
    var FSteps:Experiment.FinalSteps!
    var end:Experiment.Finish!
    
    var currentScene:String!
    
    //sets up the possible notify actions set up in the reality composer project
    var nextActions:Experiment.NotifyAction!
    
    /**
        Sets up the view with all necessary AR anchors and obejcts and buttons.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.NextButton.isEnabled = false
        self.NextButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        //load the reality composer objects and anchors
        self.loadYeastSteps()
        self.loadSoapSteps()
        self.loadHPSteps()
        
        //set up the main button to be disabled with instructions
        self.NextButton.setTitle("Once loaded, tap the Yeast label for your first instructions", for: UIControl.State.disabled)
    }
    
    /**
        Restricts rotation of the screen.
    */
    override func viewWillAppear(_ animated: Bool) {
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
    }
    

    /**
        Ends the AR scene and removes it from the stack
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arExperimentView.session.pause()
        arExperimentView.removeFromSuperview()
        arExperimentView = nil
    }
    
    /**
        Loads all the anchors and AR objects from the Yeast scene in the reality composer project file
     */
    func loadYeastSteps(){
        //self.currentScene = "Yeast"
        
        Experiment.loadYeastAsync {result in
            switch result{
            case .success(let anchor):
                let yeastAnchor = anchor
               
               // Load the "yeast" scene from the "Experiment" Reality File
                yeastAnchor.generateCollisionShapes(recursive: true)

                //add the yeast anchor to the screen
                self.arExperimentView.scene.anchors.append(yeastAnchor)

                self.yeastSteps = yeastAnchor
                
                self.setupYeastNotifyActions()
               
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    
    /**
        Loads all the anchors and AR objects from the Soap scene in the reality composer project file
     */
    func loadSoapSteps(){
        print("in Soap scene")
        
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
                
                self.setupSoapNotifyActions()

            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    /**
       Loads all the anchors and AR objects from the Hydrogen Peroxide scene in the reality composer project file
    */
    func loadHPSteps(){
        self.currentScene = "HP"
        
        Experiment.loadHydrogenPeroxideAsync {result in
            switch result{
            case .success(let anchor):
                let hpAnchor = anchor
                
                // Load the "hp" scene from the "Experiment" Reality File
                hpAnchor.generateCollisionShapes(recursive: true)
               
                // Add the hp anchor to the scene
                self.arExperimentView.scene.anchors.append(hpAnchor)
                
                self.hpSteps = hpAnchor
                
                self.setupHPNotifyActions()
               
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    /**
       Loads all the anchors and AR objects from the Final scene in the reality composer project file
    */
    func loadFinalSteps(){
        self.currentScene = "Finish"
        
        self.arExperimentView.scene.anchors.remove(at: 0)
        Experiment.loadFinalStepsAsync {result in
            switch result{
            case .success(let anchor):
                let FSAnchor = anchor

                FSAnchor.generateCollisionShapes(recursive: true)
               
                self.arExperimentView.scene.anchors.append(FSAnchor)
                
                self.FSteps = FSAnchor
                
                self.NextButton.setTitle("Tap the boxes next to each task to check them off", for: UIControl.State.disabled)
                
                self.setupFSNotifyActions()

            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    /**
       Loads all the anchors and AR objects from the Finishing scene in the reality composer project file
    */
    func loadFinish(){
        self.currentScene = "End"
        
        self.arExperimentView.scene.anchors.remove(at: 0)
        Experiment.loadFinishAsync {result in
            switch result{
            case .success(let anchor):
                let endAnchor = anchor

                endAnchor.generateCollisionShapes(recursive: true)
               
                self.arExperimentView.scene.anchors.append(endAnchor)

                self.end = endAnchor
                
                self.NextButton.setTitle("Try a new path", for: UIControl.State.normal)
                
                self.NextButton.isEnabled = true
                print("enable button")
               
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    /**
       Connects the handwritten UI actions based off of the notifications sent from the reality composer project scenes.
    */
    func setupYeastNotifyActions(){
        self.yeastSteps.actions.clickYeastLabel.onAction = self.showSoapHelpLabel(_:)
    }
    
    /**
       Connects the handwritten UI actions based off of the notifications sent from the reality composer project scenes.
    */
    func setupHPNotifyActions(){
        self.hpSteps.actions.nextButton.onAction = self.nextButton(_:)
        self.hpSteps.actions.hideSoap.onAction = self.hideSoap(_:)
    }
    
    /**
        Connects the handwritten UI actions based off of the notifications sent from the reality composer project scenes.
    */
    func setupSoapNotifyActions(){
        self.soapSteps.actions.clickDishSoap.onAction = self.showHPHelpLabel(_:)
        self.soapSteps.actions.hideYeast.onAction = self.hideYeast(_:)
    }
    
    /**
       Connects the handwritten UI actions based off of the notifications sent from the reality composer project scenes.
    */
    func setupFSNotifyActions(){
        self.FSteps.actions.nextButton.onAction = self.nextButton(_:)
        self.FSteps.actions.hideHP.onAction = self.hideHP(_:)
    }
    
    /**
       Sets up the handwritten UI action triggered by Reality Composer scene notification for showing the soap label.
    */
    func showSoapHelpLabel(_ entity: Entity?){
        self.soapSteps.notifications.showSoapTapMe.post()
        self.NextButton.setTitle("Tap the Soap label for your second instructions", for: UIControl.State.disabled)
    }
    
    /**
       Sets up the handwritten UI action triggered by Reality Composer scene notification for showing the hyfrogen peroxide label.
    */
    func showHPHelpLabel(_ entity: Entity?){
        self.hpSteps.notifications.showHPTapMe.post()
        self.NextButton.setTitle("Tap the Hydrogen Peroxide label for your second instructions", for: UIControl.State.disabled)
    }
    
    /**
       Sets up the handwritten UI action triggered by Reality Composer scene notification for hiding the yeast label.
    */
    func hideYeast(_ entity: Entity?){
        self.yeastSteps.notifications.hideAllYeast.post()
    }
    
    /**
       Sets up the handwritten UI action triggered by Reality Composer scene notification for hiding the soap label.
    */
    func hideSoap(_ entity: Entity?){
        self.soapSteps.notifications.hideAllSoap.post()
    }
    
    /**
       Sets up the handwritten UI action triggered by Reality Composer scene notification for showing the Hydrogen peroxide label.
    */
    func hideHP(_ entity: Entity?){
        self.hpSteps.notifications.hideAllHP.post()
    }
    
    /**
       Sets up the handwritten UI action triggered by Reality Composer scene notification for enabling the next button and updating its text
    */
    func nextButton(_ entity: Entity?){
        self.NextButton.isEnabled = true
        self.NextButton.setTitle("Continue to next step...", for: UIControl.State.normal)
        //print("enable button")
    }
    
    /**
       Sets up the handwritten UI action triggered by the click of the Next UI button to either post actions to the relity composer file or navigate to a different scene in the UI.
    */
    @IBAction func nextScene(sender:UIButton){
        self.NextButton.isEnabled = false
        
        if(currentScene == "HP"){
            self.hpSteps.notifications.continueFinalSteps.post()
            currentScene = "Finish"
            self.loadFinalSteps()
        }
        else if(currentScene == "Finish"){
            self.FSteps.notifications.finish.post()
            self.loadFinish()
        }
        else{
            //print("should segue")
            performSegue(withIdentifier: "unwindToPath", sender: sender)

            NextButton?.removeFromSuperview()
            NextButton = nil
        }
    }
}
