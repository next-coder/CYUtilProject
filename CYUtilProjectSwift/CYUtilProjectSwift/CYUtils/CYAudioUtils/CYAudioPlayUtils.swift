//
//  CYAudioUtils.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 6/1/16.
//  Copyright © 2016 Jasper. All rights reserved.
//

import UIKit
import AVFoundation

typealias CYAudioPlayCompletion = (URL?, NSError?, Bool) -> Void;

class CYAudioPlayUtils: NSObject, AVAudioPlayerDelegate {

    var audioURL: URL
    var audioPlayer: AVAudioPlayer?
    var audioPlayCompletion: CYAudioPlayCompletion?

    // state
    var playing: Bool {

        if let audioPlayer = self.audioPlayer {

            return audioPlayer.isPlaying
        }
        return false
    }

    var paused: Bool = false

    init(contentsOfURL audioURL: URL, audioCompletion: CYAudioPlayCompletion?) {

        self.audioURL = audioURL
        self.audioPlayCompletion = audioCompletion
        super.init()

        do {

            self.audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            self.audioPlayer?.delegate = self
        } catch {

            print("create audio player failed")
        }

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

            switch typeValue {
            case .began:
                if self.playing {

                    self.audioPlayer?.pause()
                }

            case .ended:
                if self.paused {

                    self.audioPlayer?.play()
                }
            }
        }
    }

    func play() -> Bool {

        if let audioPlayer = self.audioPlayer {

            do {

                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            } catch {

                print("set AVAudioSessionCategoryPlayback failed")
            }
            self.paused = false
            return audioPlayer.prepareToPlay()
                    && audioPlayer.play()
        }
        return false
    }

    func pause() {

        if let audioPlayer = self.audioPlayer {

            audioPlayer.pause()
            self.paused = true
        }
    }

    func stop() {

        if let audioPlayer = self.audioPlayer {

            audioPlayer.stop()
            self.paused = false
        }
    }

    // AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {

        if let completion = self.audioPlayCompletion {

            completion(self.audioURL, nil, flag)
        }
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {

        if let completion = self.audioPlayCompletion {

            completion(self.audioURL, error as NSError?, false)
        }
    }
}
