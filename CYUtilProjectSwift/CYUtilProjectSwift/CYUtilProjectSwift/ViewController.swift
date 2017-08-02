//
//  ViewController.swift
//  CYUtilProjectSwift
//
//  Created by Conner on 5/5/16.
//  Copyright © 2016 Conner. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    @IBOutlet weak var recordPauseButton: UIButton!
    @IBOutlet weak var recordStopButton: UIButton!

    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var playStopButton: UIButton!

    var progressView: CYBaseProgressBar?

    var audioPlayUtil: CYAudioPlayUtils?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let progress = CYLineProgressBar(frame: CGRect(x: 10, y: 150, width: 100, height: 30))
//        let progress = CYCycleProgressBar(startAngle: M_PI * 3 / 2,
//                                          cycleRadius: Double(48.5),
//                                          cycleCenter: CGPoint(x: 50, y: 50),
//                                          barWidth: 3,
//                                          frame: CGRect(x: 10, y: 150, width: 100, height: 100))
//        progress.color = UIColor.clear
        progress.completionColor = UIColor.red
        progress.lineCap = kCALineCapButt
//        let progress = CYCycleProgressBar(startAngle: M_PI, cycleRadius: 48, cycleCenter: CGPoint(x: 50, y: 50), frame: CGRect(x: 10, y: 150, width: 100, height: 100))
//        let progress = CYArcProgressBar(frame: CGRect(x: 10, y: 150, width: 100, height: 100))
//        let progress = CYArcProgressBar(startAngle: 2.8, calculateStartAngle: 3.5, endAngle: 6.8, arcRadius: 48, arcCenter: CGPoint(x: 50, y: 50), frame: CGRect(x: 10, y: 150, width: 100, height: 100))
//        let progress = CYArcProgressBar(startAngle: 2.8,
//                                        calculateStartAngle: 3.5,
//                                        endAngle: 6.8,
//                                        arcRadius: 48,
//                                        arcCenter: CGPoint(x: 50, y: 50),
//                                        frame: CGRect(x: 10, y: 150, width: 100, height: 100))
        progress.backgroundColor = UIColor.green
        let progressHeader = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
        progressHeader.backgroundColor = UIColor.red
        progressHeader.layer.cornerRadius = 4
        progress.progressHeaderView = progressHeader
        self.view.addSubview(progress)
        progress.setProgress(progress: 0.3, animated: true)
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

    // UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 0 {
            if indexPath.row == 0 {
//                self.present(ProgressWebTestViewController(), animated: true, completion: nil)
                self.navigationController?.pushViewController(CYProgressWebViewController(rootUrl: URL(string: "https://m.baidu.com")!), animated: true)
            } else if indexPath.row == 1 {

                self.navigationController?.pushViewController(CycleBannerTestViewController(), animated: true)
            } else if indexPath.row == 2 {
                self.navigationController?.pushViewController(RedPacketViewController(), animated: true)
            } else if indexPath.row == 3 {

                navigationController?.pushViewController(HerizontalTableViewTestViewController(), animated: true)
            } else if indexPath.row == 4 {
                navigationController?.pushViewController(FloatingViewTestViewController(), animated: true)
            }
        }
    }
}

