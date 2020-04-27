//
//  Tutorial3ViewController.swift
//  ScienceForSeniors
//
//  View Controller for presenting the third tutorial scenario.
//  This tutorial scenario presents a video in the ARView that the user can control.
//  The video is only presented after the user scans the image provided on the tutorial handout.
//  The video is a short clip of the creator informing the user of their success and progress.
//
//  Created by Jasmine Jans on 4/14/20.
//  Copyright © 2020 EduTech. All rights reserved.
//

import Foundation
import UIKit
import RealityKit
import ARKit
import AVFoundation

class Tutorial3ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var arTut3View: ARSCNView!
    @IBOutlet var audioButton: UIBarButtonItem!
    @IBOutlet var nextButton: UIButton!
    
    @IBOutlet var PlayButton: UIButton!
    @IBOutlet var RestartButton: UIButton!
    
    var playing = false
    var VoiceOver: AVPlayerItem!
    var VoiceOverPlayer: AVPlayer!
    
    var player : AVPlayer!
    var updateLabel = false
    var isPlaying = false
    var playedOnce = false
    
    /**
        Creates an AVPlayer with the video for the 3rd tutorial scenario.
        Then, it creates an AR object plane and gives it the material of the video player and positions it in the view.
        Lastly, it enables the play button so the user can control the video playback.
     */
    func addARVideo(){
        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "TutorialMovie", ofType: "mov")!)
        player = AVPlayer(url:fileURL)
        
        let videoGeo = SCNPlane(width: 1.6, height: 0.9)
        videoGeo.firstMaterial?.diffuse.contents = player
        videoGeo.firstMaterial?.isDoubleSided = true
        
        let videoNode = SCNNode(geometry: videoGeo)
        videoNode.position.z = -2
        videoNode.position.y = 0
        
        arTut3View.scene.rootNode.addChildNode(videoNode)
        
        DispatchQueue.main.async {
            self.PlayButton.isEnabled = true
        }
    }
    
    /**
       Sets up the view with all necessary AR objects, buttons and views
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true);
        PlayButton.isEnabled = false
        RestartButton.isEnabled = false
        nextButton.isEnabled = false
        arTut3View.delegate = self
    }
    
    /**
        Renders the AR scene and calls the function to add the AR video player in the AR view
     */
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARImageAnchor else {return}
        addARVideo()
    }
    
    /**
        Function sets up the AR tracking image to trigger the discovery video.
        Additionally it will restrict the rotation of the screen.
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARImageTrackingConfiguration()
        guard let arImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources - Science", bundle: nil) else { return }
        configuration.trackingImages = arImages
        print(arImages)
        
        arTut3View.session.run(configuration)
        
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
    }
    
    /**
       Overrides the viewDidAppear function
    */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /**
        Ends the AR scene and removes it from the stack
    */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arTut3View?.session.pause()
        arTut3View?.removeFromSuperview()
        arTut3View = nil
    }
    
    /**
        This function controls the play/pause button. If the video isn't currently playing, it will play it and update the button to be "pause".
        If the video is currently playing, it will pause it and update the button to be a "play". If this is the first time playing, it will also enable to "Next Button"
            to move onto the next tutorial scenario.
     */
    @IBAction func PressPlay(_ sender: Any) {
        if(isPlaying == false){
            player.play()
            playedOnce = true
            PlayButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: UIControl.State.normal)
            isPlaying = true
            RestartButton.isEnabled = true
        }else{
            player.pause()
            PlayButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
            isPlaying = false
            RestartButton.isEnabled = true
        }
        
        if(playedOnce == true){
            nextButton.isEnabled = true
        }
    }
    
    /**
        This function controls the restart button. If the player is currently playing, it will start it over and keep it playing.
        If the player is not currently playing, it will start it over and keep it paused.
     */
    @IBAction func Restart(_ sender: Any) {
        if(isPlaying == true){
            player.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: 1), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
            player.play()
        }else{
            player.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: 1), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
    }
    
    /**
       Function called when the audio button is pressed to play specified audio track for page or pause audio track.
           Function also updates the graphic of the audio button to represent the current audio state.
    */
    @IBAction func playVoiceOver(sender:UIBarButtonItem){
        let audioFile = "Tutorial3.mp3"
       
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
            player.pause()
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
