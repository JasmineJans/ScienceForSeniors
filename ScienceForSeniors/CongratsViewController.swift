//
//  CongratsViewController.swift
//  ScienceForSeniors
//
//  This is the view controller for the Congratulations screen at the end of the tutorial.
//  This handwritten class is for controlling the audio functionality, and the "Start Over" segue to begin the tutorial again.
//
//  Created by Jasmine Jans on 4/4/20.
//  Copyright © 2020 EduTech. All rights reserved.
//

import Foundation
import UIKit
import RealityKit
import AVFoundation

class CongratsViewController: UIViewController {
    
    @IBOutlet var audioButton: UIBarButtonItem!
    @IBOutlet var PathButton: UIButton!
    
    var playing = false
    var VoiceOver: AVPlayerItem!
    var VoiceOverPlayer: AVPlayer!
    
    /**
       Sets up the view with all necessary buttons and views
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
       Function called when the audio button is pressed to play specified audio track for page or pause audio track.
           Function also updates the graphic of the audio button to represent the current audio state.
    */
    @IBAction func playAudio(_ sender: UIBarButtonItem) {
        self.audioButton = sender
        let audioFile = "Congrats.mp3"
        
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
       This function additionally calls the unwind segue to navigate back to the choose a path or choose an experience page depending on which page was visited before starting the tutorial.
    */
    @IBAction func endAudio(_ sender: Any) {
        if(playing){
            VoiceOverPlayer.pause()
            audioButton.image = UIImage(systemName: "speaker.fill")
            playing = false
        }
        
        performSegue(withIdentifier: "unwindOutOfTut", sender: self)
    }
    
    /**
    Function to call the unwind segue to return back to the About the App page at the begining of the tutorial.
       This function is called by the "Start Over" barbutton item in the navigation bar.
    */
    @IBAction func backToTutorial(sender: UIBarButtonItem){
        performSegue(withIdentifier: "unwindToAboutApp", sender: self)
    }
}
