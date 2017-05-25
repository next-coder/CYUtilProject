//
//  SendRedPacketViewController.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 25/05/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

class SendRedPacketViewController: UIViewController, UITextFieldDelegate {

    var sendRedPacketView: SendRedPacketView!

    override func loadView() {
        super.loadView()

        sendRedPacketView = SendRedPacketView(frame: self.view.frame)
        self.view = sendRedPacketView

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "发红包"

        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = []

        sendRedPacketView.sendButton.addTarget(self,
                                               action: #selector(sendRedPacket),
                                               for: .touchUpInside)
        sendRedPacketView.bombWeiShuTextField.delegate = self
        sendRedPacketView.totalAmountTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "RedPacketAssets.bundle/button_red_normal")?.resizableImage(withCapInsets: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)), for: .default)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }

    // event
    func dismissKeyboard(_ sender: Any?) {

        self.view.endEditing(true)
    }

    func sendRedPacket(_ sender: Any?) {

        // send red packet
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == sendRedPacketView.bombWeiShuTextField {

            if let text = textField.text, text.characters.count > 0 {

                return false
            }
        } else if textField == sendRedPacketView.totalAmountTextField {

            if let text = (textField.text as NSString?) {

                if text.contains(".")
                    && string.contains(".") {
                    return false
                } else {

                    let replaceText = text.replacingCharacters(in: range, with: string)
                    if let dotIndex = replaceText.characters.index(of: ".") {

                        let suffix = replaceText[dotIndex..<replaceText.endIndex]
                        if suffix.characters.count > 3 {

                            return false
                        }
                    }
                }
            }
        }
        return true
    }
}
