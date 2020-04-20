//
//  DiscoverViewController.swift
//  ScienceForSeniors
//
//  View Controller for presenting the first experience Discover path AR for the first discovery.
//  This screen presents a video in the ARView that the user can control.
//  The video is only presented after the user scans the image provided on the Experience handout.
//  The video is a short clip from youtube about hair graying.
//  Credit: https://www.youtube.com/watch?v=oCtdFSAgKCY
//
//  Created by Jasmine Jans on 4/4/20.
//  Copyright © 2020 EduTech. All rights reserved.
//

import UIKit
import RealityKit
import ARKit
import AVKit

class DiscoverScene1ViewController: UIViewController, ARSCNViewDelegate{
    
    @IBOutlet var MainView: UIView!
    @IBOutlet var DiscoverSceneView: ARSCNView!
    @IBOutlet var InfoLabel: UILabel!
    @IBOutlet var PlayButton: UIButton!
    @IBOutlet var RestartButton: UIButton!
    
    var player : AVPlayer!
    var updateLabel = false
    var isPlaying = false
    
    /**
       Creates an AVPlayer with the video for the 3rd tutorial scenario.
       Then, it creates an AR object plane and gives it the material of the video player and positions it in the view.
       Lastly, it enables the play button so the user can control the video playback.
    */
    func addARVideo(){
        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "GrayHairVideo1", ofType: "mp4")!)
        player = AVPlayer(url:fileURL)
        
        let videoGeo = SCNPlane(width: 1.6, height: 0.9)
        videoGeo.firstMaterial?.diffuse.contents = player
        videoGeo.firstMaterial?.isDoubleSided = true
        
        let videoNode = SCNNode(geometry: videoGeo)
        videoNode.position.z = -2
        videoNode.position.y = 0
        
        DiscoverSceneView.scene.rootNode.addChildNode(videoNode)
        
        DispatchQueue.main.async {
            self.InfoLabel.text = "You did it! Now sit back, relax, press play and discover."
            self.PlayButton.isEnabled = true
        }
    }
    
    /**
       Sets up the view with all necessary buttons and viewa
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        PlayButton.isEnabled = false
        RestartButton.isEnabled = false
        DiscoverSceneView.delegate = self
    }
    
    /**
        Function sets up the AR tracking image to trigger the discovery video.
        Additionally it will restrict the rotation of the screen.
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARImageTrackingConfiguration()
        guard let arImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources - Grandma", bundle: nil) else { return }
        configuration.trackingImages = arImages
        print(arImages)
        
        DiscoverSceneView.session.run(configuration)
        
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
    }
    
    /**
       Renders the AR scene and calls the function to add the AR video player in the AR view
    */
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARImageAnchor else {return}
        addARVideo()
        
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
        DiscoverSceneView.session.pause()
        DiscoverSceneView.removeFromSuperview()
        DiscoverSceneView = nil
    }
    
    /**
       This function controls the play/pause button. If the video isn't currently playing, it will play it and update the button to be "pause".
       If the video is currently playing, it will pause it and update the button to be a "play".
    */
    @IBAction func PressPlay(_ sender: Any) {
        if(isPlaying == false){
            player.play()
            PlayButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: UIControl.State.normal)
            isPlaying = true
            RestartButton.isEnabled = true
        }else{
            player.pause()
            PlayButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
            isPlaying = false
            RestartButton.isEnabled = true
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
}
