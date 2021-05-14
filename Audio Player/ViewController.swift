//
//  ViewController.swift
//  Audio Player
//
//  Created by Mohammad Kiani on 2021-01-17.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var btnPlay: UIBarButtonItem!
    @IBOutlet weak var sliderVolume: UISlider!
    @IBOutlet weak var sliderScrubber: UISlider!
    
    // 1.0 create an object of AVAudioPlayer for audio
    var player = AVAudioPlayer()
    
    // 1.1 give a path for a audio file
    var path = Bundle.main.path(forResource: "bach", ofType: "mp3")
    
    // 2.1 create an object of Timer
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 1.2 give a link between player and path
        do{
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            sliderScrubber.maximumValue = Float(player.duration)
        } catch{
            print(error)
        }
    }
    
    var isPlaying = false
    
    @IBAction func clickPlay(_ sender: UIBarButtonItem) {
        if(isPlaying){
            player.pause()
            isPlaying = false
            btnPlay.image = UIImage(systemName: "play.fill")
            timer.invalidate()
        } else{
            player.play()
            isPlaying = true
            // for system image, we can set image by below and not using setImage method
            btnPlay.image = UIImage(systemName: "pause.fill")
            // 2.2 do something after particular time interal
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateScrubber), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateScrubber(){
        sliderScrubber.value = Float(player.currentTime)
        
        // because once the audio is finished, we need to do below
        if(sliderScrubber.value == sliderScrubber.minimumValue){
            isPlaying = false
            btnPlay.image = UIImage(systemName: "play.fill")
        }
    }
    
    @IBAction func clickStop(_ sender: UIBarButtonItem) {
        player.stop()
        isPlaying = false
        btnPlay.image = UIImage(systemName: "play.fill")
        player.currentTime = 0
        sliderScrubber.value = 0
        timer.invalidate()
    }
    
    @IBAction func changedScrubber(_ sender: UISlider) {
        player.currentTime = TimeInterval(sliderScrubber.value)
       
        // if we do not put this condition, then player will be stopped( reason not found). so for player to play audio we need to put below condition
        if (isPlaying){
            player.play()
        }
    }
    
    @IBAction func changedVolume(_ sender: UISlider) {
        player.volume = sliderVolume.value
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEvent.EventSubtype.motionShake){
            let audioArray = ["bach","boing","explosion","hit","knife","shoot","swish","wah","warble"]
            let random = Int.random(in: 0..<audioArray.count)
            path = Bundle.main.path(forResource: audioArray[random], ofType: "mp3")
            print(audioArray[random])
            
            do{
                try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
                sliderScrubber.maximumValue = Float(player.duration)
            } catch{
                print(error)
            }
        }
    }
    


}

