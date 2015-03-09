//
//  PlaySoundViewController.swift
//  P Perfect
//
//  Created by josue rodriguez on 3/5/15.
//  Copyright (c) 2015 josue rodriguez. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    // global properties
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile   = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func stopAllSound(sender: UIButton) {
        // this will stop all sounds
        println("Stopping all sound")
        audioPlayer.stop()
    }

    @IBAction func playFastSound(sender: UIButton) {
        // play fast sound
        println("playing fast sound")
        // send the rate to playSoundMode to play
        playSoundMode(1.5)
    }
    @IBAction func playSlowSound(sender: UIButton) {
        // print something
        println("playing slow sound")
        // send the rate speed to playSoundMode to play
        playSoundMode(0.5)
        
    }
    
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        // send to the central method
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        // send to pitch method with -1000 so can sound like darth vader
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch:Float){
        // same as other funciont
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()


    }
    func playSoundMode(soundRate:Float){
        // this method will handler all sounds
        audioPlayer.stop()
        audioPlayer.rate = soundRate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
    }
}
