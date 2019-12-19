//
//  ViewController.swift
//  TimerApp
//
//  Created by app.hanbat on 2017. 9. 12..
//  Copyright © 2017년 app.hanbat. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
        
    //don't lock
    
    @IBOutlet weak var preferLabel: UILabel!
    
    @IBOutlet weak var h1: UILabel!
    @IBOutlet weak var h2: UILabel!
    @IBOutlet weak var hmBorder: UILabel!
    @IBOutlet weak var m1: UILabel!
    @IBOutlet weak var m2: UILabel!
    @IBOutlet weak var msBorder: UILabel!
    @IBOutlet weak var s1: UILabel!
    @IBOutlet weak var s2: UILabel!
    
    @IBOutlet weak var mButton1: UIButton!
    @IBOutlet weak var mButton2: UIButton!
    @IBOutlet weak var mButton3: UIButton!

    @IBOutlet weak var mButton5: UIButton!
    @IBOutlet weak var mButton10: UIButton!
    @IBOutlet weak var mButton30: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var vibeSwitch: UISwitch!
    
    @IBOutlet weak var brightSlider: UISlider!
    @IBOutlet weak var brightness: UILabel!
    
    @IBOutlet weak var blackOut: UIButton!
    
    @IBOutlet weak var textT: UILabel!
    @IBOutlet weak var textV: UILabel!
    
    var whatM = 0
    var timer1 = Timer()
    var timer2 = Timer()
    var timer3 = Timer()
    var timer5 = Timer()
    var timer10 = Timer()
    var timer30 = Timer()
    
    var letMinute = 61
    
    var vibrator = 1
    
    let currentBrightness = UIScreen.main.brightness
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication .shared.isIdleTimerDisabled = true
        // Do any additional setup after loading the view, typically from a nib.
    
        // CountryCode
        // preferLabel.text = "Language: \(Locale.preferredLanguages[0]) Locale: \((Locale.current as NSLocale).object(forKey: .countryCode)!)"
        
        brightSlider.value = Float(currentBrightness)
        brightness.text = "Brightness : \(Int(brightSlider.value * 100))%"
        
        updateTime()
        
       _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true) // var timer	
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTime() {
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.hour, .minute, .second], from: date)
        let hour = components.hour! <= 24 ? components.hour : components.hour! - 24
        let minutes = components.minute
        let seconds = components.second
        let hours: Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "1 0", "1 1", "1 2", "1 3", "1 4", "1 5", "1 6", "1 7", "1 8", "1 9", "2 0", "2 1", "2 2", "2 3", "2 4"]
        let numbers: Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "1"]
        
        if hours[hour!].characters.count > 1 {
            h1.text = "\(hours[hour!].characters.first!)"
            h2.text = "\(hours[hour!].characters.last!)"
        } else {
            h1.text = "0"
            h2.text = hours[hour!]
        }
        
        hmBorder.text = ":"
        
        if minutes! < 10 {
            m1.text = "0"
            m2.text = "\(numbers[minutes!])"
        } else {
            if minutes! % 10 == 0 {
                m1.text = "\(numbers[minutes!/10])"
                m2.text = "0"
            }
            else {
                m1.text = "\(numbers[minutes!/10])"
                m2.text = "\(numbers[minutes!%10])"
            }
        }
        
        msBorder.text = ":"
        
        if seconds! < 10 {
            s1.text = "0"
            s2.text = "\(numbers[seconds!])"
        } else {
            if seconds! % 10 == 0 {
                s1.text = "\(numbers[seconds!/10])"
                s2.text = "0"
            }
            else {
                s1.text = "\(numbers[seconds!/10])"
                s2.text = "\(numbers[seconds!%10])"
            }
        }

    }
    
    func alarmTime(){
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.hour, .minute, .second], from: date)
        let hour = components.hour! <= 24 ? components.hour : components.hour! - 24
        let minutes = components.minute
        let seconds = components.second

        switch whatM {
        case 1 :
            if seconds! == 0 {
                alarmIt(h: hour!, m: minutes!, s: seconds!)
            }
        case 2 :
            if (letMinute % 2 == minutes! % 2) && seconds! == 0 {
                alarmIt(h: hour!, m:minutes!, s: seconds!)
            }
        case 3 :
            if (letMinute % 3 == minutes! % 3) && seconds! == 0 {
                alarmIt(h: hour!, m: minutes!, s: seconds!)
            }
        case 5 :
            if minutes! % 5 == 0 && seconds! == 0 {
                alarmIt(h: hour!, m: minutes!, s: seconds!)
            }
        case 10 :
            if minutes! % 10 == 0 && seconds! == 0 {
                alarmIt(h: hour!, m: minutes!, s: seconds!)
            }
        case 30 :
            if minutes! % 30 == 0 && seconds! == 0 {
                alarmIt(h: hour!, m: minutes!, s: seconds!)
            }
        default: // 0
            break
        }

    }
    func alarmIt(h: Int, m: Int, s:Int) {
        
        // Make it Louder
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        // TTS config
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "\(h)시 \(m)분 입니다.")
        utterance.voice = AVSpeechSynthesisVoice(language: "\(Locale.preferredLanguages[0])")
        utterance.rate = 0.4
        
        synthesizer.speak(utterance)    // TTS
        if vibrator > 0 {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)   // Vibration
        }
    }
    func stopAlarm() {
        timer1.invalidate()
        timer2.invalidate()
        timer3.invalidate()
        timer5.invalidate()
        timer10.invalidate()
        timer30.invalidate()
        
        mButton1.isSelected = false
        mButton2.isSelected = false
        mButton3.isSelected = false
        mButton5.isSelected = false
        mButton10.isSelected = false
        mButton30.isSelected = false
    }
    @IBAction func touch1Action(_ sender: UIButton) {
        stopAlarm()
        mButton1.isSelected = true
        whatM = 1
        timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(alarmTime), userInfo: nil, repeats: true)
    }
    @IBAction func touch2Action(_ sender: UIButton) {
        stopAlarm()
        mButton2.isSelected = true
        whatM = 2
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.hour, .minute, .second], from: date)
        letMinute = components.minute!
        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(alarmTime), userInfo: nil, repeats: true)
    }
    @IBAction func touch3Action(_ sender: UIButton) {
        stopAlarm()
        mButton3.isSelected = true
        whatM = 3
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.hour, .minute, .second], from: date)
        letMinute = components.minute!	
        timer3 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(alarmTime), userInfo: nil, repeats: true)
    }
    @IBAction func touch5Action(_ sender: UIButton) {
        stopAlarm()
        mButton5.isSelected = true
        whatM = 5
        timer5 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(alarmTime), userInfo: nil, repeats: true)
    }
    @IBAction func touch10Action(_ sender: UIButton) {
        stopAlarm()
        mButton10.isSelected = true
        whatM = 10
        timer10 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(alarmTime), userInfo: nil, repeats: true)
    }
    @IBAction func touch30Action(_ sender: UIButton) {
        stopAlarm()
        mButton30.isSelected = true
        whatM = 30
        timer30 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(alarmTime), userInfo: nil, repeats: true)
    }
    @IBAction func touchStop(_ sender: UIButton) {
        whatM = 0
        stopAlarm()
    }
    
    @IBAction func switchVibe(_ sender: UISwitch) {
        if vibeSwitch.isOn {
            vibrator = 0
            vibeSwitch.setOn(false, animated: false)
        }
        else {
            vibrator = 1
            vibeSwitch.setOn(true, animated: true)
        }
    }
    @IBAction func slideBright(_ sender: UISlider) {
        let value = brightSlider.value
        UIScreen.main.brightness = CGFloat(Float(value))
        brightness.text = "Brightness : \(Int(value * 100))%"
    }
    @IBAction func touchBlack(_ sender: UIButton) {
        if (self.view.backgroundColor?.isEqual(UIColor.white))! {
            self.view.backgroundColor = UIColor.black
            h1.textColor = UIColor.white
            h2.textColor = UIColor.white
            hmBorder.textColor = UIColor.white
            m1.textColor = UIColor.white
            m2.textColor = UIColor.white
            msBorder.textColor = UIColor.white
            s1.textColor = UIColor.white
            s2.textColor = UIColor.white
            textV.textColor = UIColor.white
            textT.textColor = UIColor.white
            brightness.textColor = UIColor.white
        }
        else {
            self.view.backgroundColor = UIColor.white
            h1.textColor = UIColor.black
            h2.textColor = UIColor.black
            hmBorder.textColor = UIColor.black
            m1.textColor = UIColor.black
            m2.textColor = UIColor.black
            msBorder.textColor = UIColor.black
            s1.textColor = UIColor.black
            s2.textColor = UIColor.black
            textV.textColor = UIColor.black
            textT.textColor = UIColor.black
            brightness.textColor = UIColor.black
        }
    }
}

