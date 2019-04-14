//
//  ViewController.swift
//  Pick Your Pitch
//
//  Created by Mohamed Ibrahem on 4/11/19.
//  Copyright © 2019 Mahmoud Saeed. All rights reserved.
//

import UIKit
import AVFoundation

func getFileUrl() -> URL{
    let fileName = "track.wav"
    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let pathArray = [dirPath, fileName]
    let fileUrl = URL(string: pathArray.joined(separator: "/"))
    return fileUrl!
}

class RecordSoundController: UIViewController, AVAudioRecorderDelegate {
    func piano(){
    let pianoSound = URL(fileURLWithPath: Bundle.main.path(forResource: "the_fox_say", ofType: "m4a")!)
    var audioPlayer = AVAudioPlayer()
        do{
        audioPlayer = try AVAudioPlayer(contentsOf: pianoSound)
        }catch{
        }
        audioPlayer.play()
    }
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    let recordButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "microphone")
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let pauseButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "stop")
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let playButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "play")
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupViews()
        setupConstraints()
        Actions()
    }
    
    func setupConstraints(){
        recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pauseButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        playButton.topAnchor.constraint(equalTo: recordButton.bottomAnchor, constant: 20).isActive = true
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupViews(){
        self.title = "Record Screen"
        view.backgroundColor = .white
        pauseButton.isHidden = true
        playButton.isHidden = true
        view.addSubview(recordButton)
        view.addSubview(pauseButton)
        view.addSubview(playButton)
    }
    
    func Actions(){
        recordButton.addTarget(self, action: #selector(recordAction), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseAction), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playAction), for: .touchUpInside)
    }
    
    
    
    @objc func recordAction(sender: UIButton){
        recordButton.isHidden = true
        pauseButton.isHidden = false
        playButton.isHidden = true
//        piano()
        
        let session = AVAudioSession.sharedInstance()
        do{
        try session.setCategory(.playAndRecord, mode: .default)
        }catch {
            
            }
        
        
        do{
            audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: [String : Any]())
        }catch{
            
        }
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        
        audioRecorder.record()
    }
    
    @objc func pauseAction(sender: UIButton){
        pauseButton.isHidden = true
        recordButton.isHidden = false
        playButton.isHidden = false
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do{
            try audioSession.setActive(false)
        }catch{
            
        }
    }
    
    @objc func playAction(sender: UIButton){
        let vc = PlaySoundController() as PlaySoundController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            recordedAudio = RecordedAudio(filePathUrl: recorder.url)
        }
    }


}

