//
//  File.swift
//  Pick Your Pitch
//
//  Created by Mohamed Ibrahem on 4/13/19.
//  Copyright © 2019 Mahmoud Saeed. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundController: UIViewController, AVAudioPlayerDelegate {
    
    let SliderValueKey = "Slider Value key"
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    
    
    let playButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "play")
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let stopButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "stop")
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let slideBar: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        Actions()
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
        }catch{
            audioPlayer = nil
        }
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        
        do{
            audioFile = try AVAudioFile(forReading: getFileUrl())
        }catch{
            audioFile = nil
        }
        
        setUserInterfaceToPlayMode(false)
    }
    
    func setUserInterfaceToPlayMode(_ isPlayMode: Bool){
        playButton.isHidden = isPlayMode
        stopButton.isHidden = !isPlayMode
        slideBar.isEnabled = !isPlayMode
    }
    
    func setupViews(){
        self.title = "Play Screen"
        view.backgroundColor = .white
        view.addSubview(playButton)
        view.addSubview(slideBar)
        view.addSubview(stopButton)
    }
    
    func setupConstraints(){
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stopButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        slideBar.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 20).isActive = true
        slideBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        slideBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
    
    func Actions(){
        playButton.addTarget(self, action: #selector(playAction), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopAction), for: .touchUpInside)
        slideBar.addTarget(self, action: #selector(sliderAction), for: .touchUpInside)
    }
    
    @objc func playAction(sender: UIButton){
        
        
        let pitch = slideBar.value
        
        playAudioWithVariablePitch(pitch)
        
        setUserInterfaceToPlayMode(true)
        
    }
    
    
    
    @objc func stopAction(sender: UIButton){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
    }
    
    @objc func sliderAction(sender: UISlider){
        print("Slider vaue: \(slideBar.value)")
    }
    func playAudioWithVariablePitch(_ pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let changeAudioEffect = AVAudioUnitTimePitch()
        changeAudioEffect.pitch = pitch
        audioEngine.attach(changeAudioEffect)
        
        audioEngine.connect(audioPlayerNode, to: changeAudioEffect, format: nil)
        audioEngine.connect(changeAudioEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil){
            DispatchQueue.main.sync {
                self.setUserInterfaceToPlayMode(false)
            }
        }
        
        do{
            try audioEngine.start()
        }catch{
            
        }
        audioPlayerNode.play()
    }
    
}
