//
//  Tutorial1ViewController.swift
//  ScienceForSeniors
//
//  View Controller for presenting the first tutorial scenario.
//  This tutorial scenario presents some objects that each do an animation on loop.
//
//  Created by Jasmine Jans on 4/14/20.
//  Copyright © 2020 EduTech. All rights reserved.
//

import Foundation
import UIKit
import RealityKit
import AVFoundation

class Tutorial1ViewController: UIViewController {
    
    @IBOutlet var arTut1View: ARView!
    @IBOutlet var audioButton: UIBarButtonItem!
    @IBOutlet var exitButton: UIBarButtonItem!
    @IBOutlet var nextButton: UIButton!
    
    var playing = false
    var VoiceOver: AVPlayerItem!
    var VoiceOverPlayer: AVPlayer!
    
    var tut1Anchor:Tutorial1.Scene!
    
    /**
       Sets up the view with all necessary AR objects, buttons and views.
        This loads the tutorial scenario 1 objects from reality composer project file.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true);

        let tut1Anchor = try! Tutorial1.loadScene()
        tut1Anchor.generateCollisionShapes(recursive: true)
        
        arTut1View.scene.anchors.append(tut1Anchor)
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
        arTut1View?.session.pause()
        arTut1View?.removeFromSuperview()
        arTut1View = nil
    }
    
    /**
        Overrides the viewDidAppear function
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /**
       Function called when the audio button is pressed to play specified audio track for page or pause audio track.
           Function also updates the graphic of the audio button to represent the current audio state.
    */
    @IBAction func playVoiceOver(sender:UIBarButtonItem){
        let audioFile = "Tutorial1.mp3"
        
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
