//
//  ViewController.swift
//  CYUtilProjectSwift
//
//  Created by HuangQiSheng on 5/5/16.
//  Copyright © 2016 Jasper. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recordPauseButton: UIButton!
    @IBOutlet weak var recordStopButton: UIButton!

    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var playStopButton: UIButton!

    var progressView: CYBaseProgressBar?

    var audioPlayUtil: CYAudioPlayUtils?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        let progress = CYLineProgressBar(frame: CGRect(x: 10, y: 150, width: 100, height: 30))
//        let progress = CYCycleProgressBar(frame: CGRect(x: 10, y: 150, width: 100, height: 100))
//        let progress = CYCycleProgressBar(startAngle: M_PI, cycleRadius: 48, cycleCenter: CGPoint(x: 50, y: 50), frame: CGRect(x: 10, y: 150, width: 100, height: 100))
//        let progress = CYArcProgressBar(frame: CGRect(x: 10, y: 150, width: 100, height: 100))
        let progress = CYArcProgressBar(startAngle: 2.8, endAngle: 6.8, arcRadius: 48, arcCenter: CGPoint(x: 50, y: 50), frame: CGRect(x: 10, y: 150, width: 100, height: 100))
        progress.backgroundColor = UIColor.green
        let progressHeader = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
        progressHeader.backgroundColor = UIColor.red
        progressHeader.layer.cornerRadius = 4
        progress.progressHeaderView = progressHeader
        self.view.addSubview(progress)
        progress.setProgress(progress: 0.75, animated: true)
        progressView = progress
    }

    @IBAction func recordOrPause(_ sender: AnyObject) {

        progressView?.setProgress(progress: 0.3, animated: true)

        if !CYAudioRecordUtils.recording {

            if !CYAudioRecordUtils.paused {

                let documentsList = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let fileUrl = documentsList[0] + "/record.caf"
                let result = CYAudioRecordUtils.record(URL: URL(fileURLWithPath: fileUrl)) { (url, error, success) in

                    if success {

                        print("success")
                    } else {

                        print(error ?? "录制出错")
                    }
                }	

                if result {
                    
                    self.recordPauseButton?.setTitle("Pause", for: UIControlState())
                }
            } else {

                CYAudioRecordUtils.resume()
                self.recordPauseButton?.setTitle("Pause", for: UIControlState())
            }
        } else {

            CYAudioRecordUtils.pause()
            self.recordPauseButton?.setTitle("Record", for: UIControlState())
        }
    }

    @IBAction func stopRecord(_ sender: AnyObject) {

        CYAudioRecordUtils.stop()
        self.recordPauseButton?.setTitle("Record", for: UIControlState())
    }

    @IBAction func playOrPause(_ sender: AnyObject) {

        if let audioPlayUtil = self.audioPlayUtil {

            if audioPlayUtil.playing {

                audioPlayUtil.pause()
                return
            } else if audioPlayUtil.paused {

                _ = audioPlayUtil.play()
                return
            }
        }

        let documentsList = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let fileUrl = documentsList[0] + "/record.caf"
        self.audioPlayUtil = CYAudioPlayUtils(contentsOfURL: URL(fileURLWithPath: fileUrl)) { (url, error, success) in

            self.playPauseButton.setTitle("Play", for: UIControlState())
            if success {

                print("success")
            } else {

                print(error ?? "播放出错")
            }
        }

        if self.audioPlayUtil!.play() {

            self.playPauseButton.setTitle("Pause", for: UIControlState())
        }
    }

    @IBAction func stopPlay(_ sender: AnyObject) {

        if let audioPlayUtil = self.audioPlayUtil {

            audioPlayUtil.stop()
            self.playPauseButton.setTitle("Play", for: UIControlState())
            self.audioPlayUtil = nil
        }
    }
}

