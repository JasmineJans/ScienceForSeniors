//
//  Tutorial3ViewController.swift
//  ScienceForSeniors
//
//  View Controller for presenting the fourth tutorial scenario.
//  This tutorial scenario presents 3 objects very spread out that when approached closely with the camera, perform little actions.
//
//  Created by Jasmine Jans on 4/14/20.
//  Copyright © 2020 EduTech. All rights reserved.
//

import Foundation
import UIKit
import RealityKit
import AVFoundation

class Tutorial4ViewController: UIViewController {
    
    @IBOutlet var arTut4View: ARView!
    @IBOutlet var NextButton: UIButton!
    @IBOutlet var audioButton: UIBarButtonItem!
    
    var playing = false
    var VoiceOver: AVPlayerItem!
    var VoiceOverPlayer: AVPlayer!
    
    var Tut4:Tutorial4.Scene!
    
    /**
       Sets up the view with all necessary AR objects, buttons and views
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        Tutorial4.loadSceneAsync {result in
            switch result{
            case .success(let anchor):
                let Tut4Anchor = anchor

                Tut4Anchor.generateCollisionShapes(recursive: true)
               
                self.arTut4View.scene.anchors.append(Tut4Anchor)
                
                self.Tut4 = Tut4Anchor
               
            case .failure(let error):
                print(error)
                return
            }
        }
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
        arTut4View?.session.pause()
        arTut4View?.removeFromSuperview()
        arTut4View = nil
    }
    
    /**
       Function called when the audio button is pressed to play specified audio track for page or pause audio track.
           Function also updates the graphic of the audio button to represent the current audio state.
    */
    @IBAction func playVoiceOver(sender:UIBarButtonItem){
        let audioFile = "Tutorial4.mp3"
       
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
