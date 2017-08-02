//
//  CYRedPacketDetailViewController.swift
//  CYUtilProjectSwift
//
//  Created by Conner on 21/05/2017.
//  Copyright © 2017 Conner. All rights reserved.
//

import UIKit

class CYRedPacketDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    static let detailRedPacketCellIdentifier = "detailRedPacketCellIdentifier"

    var tableView: UITableView?
    var detailHeaderView: CYRedPacketDetailHeaderView?

    // 红包
    var redPacket: CYRedPacketViewModel?
    // 红包领取详情
    var redPacketDrawDetails: [CYRedPacketDrawViewModel]?
    // 当前登录用户领取详情
    var myDrawDetail: CYRedPacketDrawViewModel?

    override func loadView() {
        super.loadView()

        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView?.dataSource = self
        tableView?.delegate = self
        self.view.addSubview(tableView!)

        detailHeaderView = CYRedPacketDetailHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 150))
        refreshHeader()
        tableView?.tableHeaderView = detailHeaderView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = NSLocalizedString("Red Packet", comment: "")

        tableView?.register(CYRedPacketDetailCell.self,
                            forCellReuseIdentifier: CYRedPacketDetailViewController.detailRedPacketCellIdentifier)
    }

    private func refreshHeader() {

        // TODO set headimage using url
//        detailHeaderView?.headImageButton.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControlState#>)
        let fromliteral = NSLocalizedString("From", comment: "")
        let senderNickname = redPacket?.senderNickname ?? ""
        detailHeaderView?.fromButton.setTitle(fromliteral + senderNickname, for: .normal)
        detailHeaderView?.blessingLabel.text = redPacket?.blessing
        if let myDraw = myDrawDetail {
            detailHeaderView?.amountLabel.isHidden = false
            detailHeaderView?.amountLabel.text = "\(myDraw.amount)"

            detailHeaderView?.unitLabel.isHidden = false

            detailHeaderView?.transferLabel.isHidden = false
            detailHeaderView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200)
        } else {

            detailHeaderView?.amountLabel.isHidden = true

            detailHeaderView?.unitLabel.isHidden = true

            detailHeaderView?.transferLabel.isHidden = true
            detailHeaderView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 150)
        }
    }

    // UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return redPacketDrawDetails?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let cell = tableView.dequeueReusableCell(withIdentifier: CYRedPacketDetailViewController.detailRedPacketCellIdentifier) as! CYRedPacketDetailCell

        guard let drawDetail = redPacketDrawDetails?[indexPath.row] else {

            return cell
        }
        // TODO set headimage using url
//        cell.headImageButton.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControlState#>)
        cell.nicknameLabel.text = drawDetail.drawUserNickname
        cell.timeLabel.text = drawDetail.time
        cell.amountLabel.text = "￥ \(drawDetail.amount)"
        cell.luckiestButton.isHidden = !drawDetail.isLuckiestDraw
        return cell
    }

}
