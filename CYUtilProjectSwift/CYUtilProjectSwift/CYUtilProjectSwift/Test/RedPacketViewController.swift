//
//  RedPacketViewController.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 22/05/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

class RedPacketViewController: UIViewController, CYRedPacketOpenViewDelegate {

    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()

        let open = UIButton(type: .custom)
        open.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        open.backgroundColor = UIColor.red
        open.setTitle("Open", for: .normal)
        open.addTarget(self, action: #selector(openPacket), for: .touchUpInside)
        self.view.addSubview(open)

        let send = UIButton(type: .custom)
        send.frame = CGRect(x: 100, y: 200, width: 100, height: 50)
        send.backgroundColor = UIColor.red
        send.setTitle("Send", for: .normal)
        send.addTarget(self, action: #selector(sendPacket), for: .touchUpInside)
        self.view.addSubview(send)
    }

    func openPacket(sender: Any) {
        let view = CYRedPacketOpenView(frame: CGRect(x: 100, y: 100, width: 200, height: 350))
//        view.backgroundColor = UIColor.green
//        view.backgroundView.backgroundColor = UIColor.cyan
//        view.closeButton.backgroundColor = UIColor.red
//        view.headImageButton.backgroundColor = UIColor.red
//        view.nicknameButton.backgroundColor = UIColor.black
        view.nicknameButton.setTitle("发大幅度", for: .normal)
//        view.openButton.backgroundColor = UIColor.blue
//        view.detailButton.backgroundColor = UIColor.brown
        view.detailButton.setTitle("发大幅度fdd", for: .normal)
//        view.blessingLabel.backgroundColor = UIColor.white
        view.blessingLabel.text = "发发发范德萨范德萨"
//        view.receiveTipsLabel.backgroundColor = UIColor.red
        view.receiveTipsLabel.text = "发发发范德萨范德萨"
        view.delegate = self

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.addSubview(view)
        window?.show_cyRedPacket()
    }

    func sendPacket(sender: Any) {

        self.navigationController?.pushViewController(SendRedPacketViewController(), animated: true)
    }

    func redPacketOpenViewShouldDismiss(redPacketView: CYRedPacketOpenView) {

        window?.dismiss_cyRedPacket()
        window = nil
    }


    func redPacketOpenViewOpenPacket(redPacketView: CYRedPacketOpenView) {

    }

}
