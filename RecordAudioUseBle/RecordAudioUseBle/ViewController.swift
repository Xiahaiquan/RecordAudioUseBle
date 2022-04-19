//
//  ViewController.swift
//  RecordAudioUseBle
//
//  Created by harman on 2022/4/19.
//

import UIKit

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var soundPlayer : AVAudioPlayer!
    
    var soundRecorder : AVAudioRecorder!
    
    var file_path = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let session = AVAudioSession.sharedInstance()
        //设置session类型
        do {
            try session.setCategory(.playAndRecord,options: [ .allowBluetooth])
        } catch let err{
            print("设置类型失败:\(err.localizedDescription)")
        }
        //设置session动作
        do {
            try session.setActive(true)
        } catch let err {
            print("初始化动作失败:\(err.localizedDescription)")
        }
        
        
        file_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/record.wav") ?? ""
        
        let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 16000),//采样率
                                              AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),//音频格式
                                     AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数
                                      AVNumberOfChannelsKey: NSNumber(value: 1),//通道数
                                   AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.max.rawValue)//录音质量
        ];
        
        do {
            let audioFilename = URL(fileURLWithPath: file_path)
            soundRecorder = try AVAudioRecorder(url: audioFilename, settings: recordSetting )
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        } catch {
            print(error)
        }
        
    }
    
    
    @IBAction func Start(_ sender: Any) {
        
        //开始录音
        soundRecorder.record()
    }
    @IBAction func Stop(_ sender: Any) {
        
        //停止录音
        soundRecorder.stop()
    }
    @IBAction func Play(_ sender: Any) {
        let audioFilename = URL(fileURLWithPath: file_path)
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
            
            soundPlayer.play()
        } catch {
            print(error)
        }
    }
}

extension ViewController: AVAudioRecorderDelegate {
    /* audioRecorderDidFinishRecording:successfully: is called when a recording has been finished or stopped. This method is NOT called if the recorder is stopped due to an interruption. */
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("audioRecorderDidFinishRecording", flag)
    }
    
    /* if an error occurs while encoding it will be reported to the delegate. */
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("audioRecorderEncodeErrorDidOccur", error.debugDescription)
    }
    
    /* AVAudioRecorder INTERRUPTION NOTIFICATIONS ARE DEPRECATED - Use AVAudioSession instead. */
    
    /* audioRecorderBeginInterruption: is called when the audio session has been interrupted while the recorder was recording. The recorded file will be closed. */
    func audioRecorderBeginInterruption(_ recorder: AVAudioRecorder) {
        
    }
    
    /* audioRecorderEndInterruption:withOptions: is called when the audio session interruption has ended and this recorder had been interrupted while recording. */
    /* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
    func audioRecorderEndInterruption(_ recorder: AVAudioRecorder, withOptions flags: Int) {
        
    }
}
extension ViewController: AVAudioPlayerDelegate {
    /* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("audioPlayerDidFinishPlaying", flag)
    }
    
    
    /* if an error occurs while decoding it will be reported to the delegate. */
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?){
        print("audioPlayerDecodeErrorDidOccur", error.debugDescription)
    }
    
    
    /* AVAudioPlayer INTERRUPTION NOTIFICATIONS ARE DEPRECATED - Use AVAudioSession instead. */
    
    /* audioPlayerBeginInterruption: is called when the audio session has been interrupted while the player was playing. The player will have been paused. */
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer){
        
    }
    
    /* audioPlayerEndInterruption:withOptions: is called when the audio session interruption has ended and this player had been interrupted while playing. */
    /* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int){
        
    }
}

