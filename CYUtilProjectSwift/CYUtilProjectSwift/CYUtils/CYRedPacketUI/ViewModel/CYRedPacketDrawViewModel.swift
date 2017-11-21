//
//  CYRedPacketDrawViewModel.swift
//  CYUtilProjectSwift
//
//  Created by Conner on 21/05/2017.
//  Copyright © 2017 Conner. All rights reserved.
//

import UIKit

class CYRedPacketDrawViewModel: NSObject {

    // 红包id
    var redPacketId: String?
    // 领取者id
    var drawUserId: String?
    // 领取者昵称
    var drawUserNickname: String?
    // 领取者头像
    var drawUserHeadImageUrl: String?

    // 领取时间
    var time: String?
    // 领取金额
    var amount: Double = 0

    // 是否手气最佳
    var isLuckiestDraw: Bool = false

}
