//
//  CYAudioRecorderUtils.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 6/1/16.
//  Copyright © 2016 Jasper. All rights reserved.
//

import UIKit
import AVFoundation

typealias CYAudioRecordUtilsCompletion = (URL?, NSError?, Bool) -> Void

class CYAudioRecordUtils: NSObject, AVAudioRecorderDelegate {

    fileprivate var url: URL?
    fileprivate var audioRecorder: AVAudioRecorder?
    fileprivate var completion: CYAudioRecordUtilsCompletion?
    fileprivate var paused: Bool = false

    static var recording: Bool {

        if let audioRecorder = sharedInstance.audioRecorder {

            return audioRecorder.isRecording
        }
        return false
    }

    static var paused: Bool {

        return sharedInstance.paused
    }

    override fileprivate init() {

        super.init()
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(audioRecordInterruption),
                                                         name: NSNotification.Name.AVAudioSessionInterruption,
                                                         object: nil)
    }

    @objc fileprivate func audioRecordInterruption(_ notification: Notification) {

        let typeNumber = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? NSNumber

        var type: AVAudioSessionInterruptionType?
        if let typeNumberO = typeNumber {

            type = AVAudioSessionInterruptionType(rawValue: typeNumberO.uintValue)
        }

        if let typeValue = type {

            if let audioRecorder = self.audioRecorder {

                switch typeValue {

                case .began:
                    if audioRecorder.isRecording {

                        audioRecorder.pause()
                        self.paused = true
                    }


                case .ended:
                    if self.paused {

                        audioRecorder.record()
                        self.paused = false
                    }
                }
            }
        }
    }

    // AVAudioRecorderDelegate
    @objc func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {

        if let completion = self.completion {

            completion(self.url, nil, flag)
            self.audioRecorder = nil
        }
    }

    @objc func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {

        if let completion = self.completion {

            completion(self.url, error as NSError?, false)
            self.audioRecorder = nil
        }
    }

    // Only one record at a time, 
    // if next coming with previous recording, 
    // continue previous recording, 
    // ignore the coming recording request, and this will return false
    // this method record audio at sampleRate: 44100.0, quality: .Max, format: kAudioFormatLinearPCM
    class func record(URL url:URL, completion: CYAudioRecordUtilsCompletion?) -> Bool {

        return self.record(URL: url,
                           sampleRate: 44100.0,
                           quality: .max,
                           format: kAudioFormatLinearPCM,
                           completion: completion)
    }

    // Only one record at a time,
    // if next coming with previous recording,
    // continue previous recording,
    // ignore the coming recording request, and this will return false
    class func record(URL url:URL,
                          sampleRate: Double,
                          quality: AVAudioQuality,
                          format: AudioFormatID,
                          completion: CYAudioRecordUtilsCompletion?) -> Bool {

        if recording {

            return false
        }

        sharedInstance.paused = false
        do {

            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)

            let audioParams = [ AVSampleRateKey: NSNumber(value: sampleRate as Double),
                                AVFormatIDKey: NSNumber(value: format as UInt32),
                                AVNumberOfChannelsKey: NSNumber(value: 1 as Int32),
                                AVEncoderAudioQualityKey: NSNumber(value: quality.rawValue as Int),
                                AVLinearPCMBitDepthKey: NSNumber(value: 16 as Int32),
                                AVLinearPCMIsBigEndianKey: NSNumber(value: false as Bool),
                                AVLinearPCMIsFloatKey: NSNumber(value: true as Bool)]
            let audioRecorder = try AVAudioRecorder(url: url, settings: audioParams)
            audioRecorder.delegate = sharedInstance
            var result = audioRecorder.prepareToRecord()
            result = result && audioRecorder.record()

            if (result) {

                sharedInstance.completion = completion
                sharedInstance.audioRecorder = audioRecorder
                return true
            } else {

                return false
            }
        } catch {

            print("create AVAudioRecorder failed")
        }
        return false
    }

    class func pause() {

        if self.recording {

            sharedInstance.audioRecorder?.pause()
            sharedInstance.paused = true
        }
    }

    class func resume() {

        if self.paused {

            sharedInstance.audioRecorder?.record()
        }
    }

    class func stop() {

        sharedInstance.audioRecorder?.stop()
    }

    // shared instance
    fileprivate static let sharedInstance = CYAudioRecordUtils()
}
