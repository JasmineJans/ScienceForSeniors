//
//  Tutorial2ViewController.swift
//  ScienceForSeniors
//
//  View Controller for presenting the second tutorial scenario.
//  This tutorial scenario presents two objects with labels for the user to click to trigger an animation.
//
//  Created by Jasmine Jans on 4/14/20.
//  Copyright © 2020 EduTech. All rights reserved.
//

import Foundation
import UIKit
import RealityKit
import AVFoundation

class Tutorial2ViewController: UIViewController {
    
    @IBOutlet var arTut2View: ARView!
    @IBOutlet var audioButton: UIBarButtonItem!
    @IBOutlet var nextButton: UIButton!
    
    var playing = false
    var VoiceOver: AVPlayerItem!
    var VoiceOverPlayer: AVPlayer!
    
    var cylTapped = false
    var sphereTapped = false
    
    var Tut2:Tutorial2.Scene!
    
    /**
       Sets up the view with all necessary AR objects, buttons and views
        This loads the tutorial scenario 2 objects from reality composer project file.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isEnabled = false
        self.navigationItem.setHidesBackButton(true, animated: true);
        
        let tut2Anchor = try! Tutorial2.loadScene()
        tut2Anchor.generateCollisionShapes(recursive: true)
        
        arTut2View.scene.anchors.append(tut2Anchor)
        
        self.Tut2 = tut2Anchor
        
        self.setupNotifyActions()
        
       /* Tutorial2.loadSceneAsync {result in
            switch result{
            case .success(let anchor):
                let Tut2Anchor = anchor

                Tut2Anchor.generateCollisionShapes(recursive: true)
               
                self.arTut2View.scene.anchors.append(Tut2Anchor)
                
                self.Tut2 = Tut2Anchor
                
                self.setupNotifyActions()

            case .failure(let error):
                print(error)
                return
            }
        }*/
    }
    
    /**
        Ends the AR scene and removes it from the stack
    */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arTut2View?.session.pause()
        arTut2View?.removeFromSuperview()
        arTut2View = nil
    }
    
    /**
        Restricts rotation of the screen.
    */
    override func viewWillAppear(_ animated: Bool) {
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
    }
    
    /**
        Connects the handwritten UI actions based off of the notifications sent from the reality composer project scenes.
    */
    func setupNotifyActions(){
        self.Tut2.actions.sphereTapped.onAction = self.setSphereTap(_:)
        self.Tut2.actions.cylTapped.onAction = self.setCylTap(_:)
    }
    
    /**
       Sets up the handwritten UI action triggered by Reality Composer scene notification for indicating the sphere has been tapped.
        If the cylinder has already been tapped, it will also enable to next button.
    */
    func setSphereTap(_ entity: Entity?){
        self.sphereTapped = true
        print("sphere is tapped")
        
        if(self.cylTapped == true){
            self.nextButton.isEnabled = true
        }
    }
    
    /**
       Sets up the handwritten UI action triggered by Reality Composer scene notification for indicating the cylinder has been tapped.
        If the sphere has already been tapped, it will also enable to next button.
    */
    func setCylTap(_ entity: Entity?){
        self.cylTapped = true
        print("cyl is tapped")
        
        if(self.sphereTapped == true){
            self.nextButton.isEnabled = true
            print("enabling next button")
        }
    }
    
    /**
       Function called when the audio button is pressed to play specified audio track for page or pause audio track.
           Function also updates the graphic of the audio button to represent the current audio state.
    */
    @IBAction func playVoiceOver(sender:UIBarButtonItem){
        let audioFile = "Tutorial2.mp3"
       
        let path = Bundle.main.path(forResource: audioFile, ofType:nil)!
        let url = URL(fileURLWithPath: path)

        if(!playing){
            VoiceOver = AVPlayerItem(url: url)
            NotificationCenter.default.addObserver(self, selector: #selector(self.audioOver(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: VoiceOver)
            VoiceOverPlayer = AVPlayer(playerItem: VoiceOver)
            VoiceOverPlayer.play()
            playing = true
            sender.image = UIImage(systemName: "speaker.2.fill")
        }
        else{
            VoiceOverPlayer.pause()
            sender.image = UIImage(systemName: "speaker.fill")
            playing = false
        }
    }
    
    /**
       This function is triggered when audio file finishes executing and trigger an update to the audio button appearence.
    */
    @objc func audioOver(sender: NSNotification) {
        DispatchQueue.main.async {
            self.audioButton.image = UIImage(systemName: "speaker.fill")
            self.playing = false
        }
    }
    
    /**
       Function that is triggered when the user clicks the button to go to the next page.
       This function will end the audio file from playing so that it doesn't continue once the user has navigated away from the page.
    */
    @IBAction func EndAudio(sender:UIButton){
        if(playing){
            VoiceOverPlayer.pause()
            audioButton.image = UIImage(systemName: "speaker.fill")
            playing = false
        }
    }
    
    /**
    Function to call the unwind segue to return back to the About the App page at the begining of the tutorial.
       This function is called by the "Exit" barbutton item in the navigation bar.
    */
    @IBAction func backToTutorial(sender: UIBarButtonItem){
        performSegue(withIdentifier: "unwindToAboutApp", sender: self)
    }
}
