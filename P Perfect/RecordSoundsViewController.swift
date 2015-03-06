//
//  RecordSoundsViewController.swift
//  P Perfect
//
//  Created by josue rodriguez on 3/4/15.
//  Copyright (c) 2015 josue rodriguez. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        // hide the stop button
        stopButton.hidden    = true
        recordButton.enabled = true
        recordingInProgress.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func recordAudio(sender: UIButton) {
        // when the press the microphone show the text
        recordingInProgress.hidden = false
        stopButton.hidden          = false
        recordButton.enabled       = false
        // TODO: Record the user voices
        let dirPath     = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDate = NSDate()
        let formatter   = NSDateFormatter()
        
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        // recording name
        let recordingName = formatter.stringFromDate(currentDate) + ".wav"
        let pathArray     = [dirPath, recordingName]
        let filePath      = NSURL.fileURLWithPathComponents(pathArray)
        // print the path
        println(filePath)
        
        // setup audio seassion
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // set the audio recorder variable to use
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate        = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
 
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if(flag){
            // after record audio is finish
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title       = recorder.url.lastPathComponent
            // move to the next scene
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        }else{
            println("The audio did not record")
            recordButton.enabled = true
            stopButton.hidden    = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundViewController = segue.destinationViewController as PlaySoundViewController
            let data = sender as RecordedAudio
            // past the data to PlaySoundViewController class
            playSoundsVC.receivedAudio = data
        }
        
       
    }
  
    @IBAction func stopRecordingAudio(sender: UIButton) {
        // stop recording
        audioRecorder.stop()
        
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error:nil)
    }
}

