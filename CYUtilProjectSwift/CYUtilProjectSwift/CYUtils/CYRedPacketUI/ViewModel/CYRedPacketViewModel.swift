//
//  CYRedPacket.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 21/05/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

class CYRedPacketViewModel: NSObject {

    // 红包id
    var redPacketId: String?
    // 红包祝福语
    var blessing: String?

    // 发送者id
    var senderId: String?
    // 发送者昵称
    var senderNickname: String?
    // 发送者头像url
    var senderHeadImageUrl: String?

    // 总金额
    var amount: Int = 0
    // 红包数量
    var count: Int = 0
    // 已被领取的数量
    var openedCount: Int = 0

    // 红包类型
    var type: Int = 0
}
