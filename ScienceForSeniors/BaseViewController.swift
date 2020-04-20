//
//  BaseViewController.swift
//  ScienceForSeniors
//
//  This is the view controller for all the base screens.
//  This handwritten class was set for defining the functionality of the Audio that reads aloud the page instructions.
//
//  Created by Jasmine Jans on 4/4/20.
//  Copyright © 2020 EduTech. All rights reserved.
//

import Foundation
import UIKit
import RealityKit
import AVFoundation

class BaseViewController: UIViewController {
    
    @IBOutlet var BaseView: UIView!
    @IBOutlet var currentButton:UIBarButtonItem!
    
    var playing = false
    var VoiceOver: AVPlayerItem!
    var VoiceOverPlayer: AVPlayer!
    
    /**
        Sets up the view. Removes the navigation back button from tutorial pages.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.title == "TriggerAR" || self.title == "FinalTut"){
            self.navigationItem.setHidesBackButton(true, animated: true)
        }
        
    }
    
    /**
        Restricts rotation of the screen except for the "rotate to learn" page which needs to rotate.
    */
    override func viewWillAppear(_ animated: Bool) {
        //print(self.title)
        if(self.title != "RotateLearn"){
            (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        }
        else{
            (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
        }
    }
    
    /**
       Function called when the audio button is pressed to play specified audio track for page or pause audio track.
           Function also updates the graphic of the audio button to represent the current audio state.
    */
    @IBAction func playVoiceOver(sender:UIBarButtonItem){
        self.currentButton = sender
        var audioFile = ""
        if(sender.title == "Exp1About"){
            audioFile = "AboutExp1.mp3"
        }
        else if(sender.title == "HowToExp"){
            audioFile = "HowToExp.mp3"
        }
        else if(sender.title == "Learn1"){
            audioFile = "Learn1.mp3"
        }
        else if(sender.title == "Discover1"){
            audioFile = "Discover1.mp3"
        }
        else if(sender.title == "ExpIng1"){
            audioFile = "ExpIng1.mp3"
        }
        else if(sender.title == "AboutApp"){
            audioFile = "AboutApp.mp3"
        }
        else if(sender.title == "AboutContent"){
            audioFile = "AboutContent.mp3"
        }
        else if(sender.title == "AboutAR"){
            audioFile = "AboutAR.mp3"
        }
        else if(sender.title == "TriggerAR"){
            audioFile = "TriggerAR.mp3"
        }
        else if(sender.title == "Congratulations"){
            audioFile = "Congrats.mp3"
        }
        
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
            self.currentButton.image = UIImage(systemName: "speaker.fill")
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
            currentButton.image = UIImage(systemName: "speaker.fill")
            playing = false
        }
    }
    
}
