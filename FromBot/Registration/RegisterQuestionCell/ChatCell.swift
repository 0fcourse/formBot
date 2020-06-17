//
//  ChatCell.swift
//  jawaz
//
//  Created by Marwan Aziz on 29/07/2018.
//  Copyright © 2018 Marwan Aziz. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class ChatCell: UITableViewCell {

    @IBOutlet private weak var bubbleView:UIView!
    @IBOutlet private weak var verticalLayer:UIView!
    @IBOutlet private weak var horizontalLayer:UIView!
    @IBOutlet private weak var lblMessage:UILabel!
    @IBOutlet private weak var lblTime:UILabel!
    @IBOutlet private weak var cellImage: UIImageView?
    fileprivate var showingImage = false
    fileprivate var loaded = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setText(_ text: String?, imageName: String? = nil) {
        if imageName == nil {
            showingImage = false
            cellImage?.isHidden = true
            lblMessage.text = text
        } else {
            cellImage?.isHidden = false
            showingImage = true
            cellImage?.loadGif(asset: imageName!)
            lblMessage.text = text
        }
    }

    func setBubbleColour(colour: UIColor) {
        self.bubbleView.backgroundColor = colour
        self.verticalLayer.backgroundColor = colour
        self.horizontalLayer.backgroundColor = colour
    }

    func setMessageColour(colour: UIColor) {
        self.lblMessage.textColor = colour
    }

    func setTimeColour(colour: UIColor) {
        self.lblTime.textColor = colour
    }

    func setAsRead(read: Bool) {}

    override func layoutSubviews() {
        super.layoutSubviews()
        self.bubbleView.layer.cornerRadius = 15
        self.verticalLayer.layer.cornerRadius = 25
        self.horizontalLayer.layer.cornerRadius = 17
        self.bubbleView.layer.shadowColor = UIColor.black.cgColor
        self.bubbleView.layer.shadowRadius = 1
        if self.reuseIdentifier == "ReceiveChatCell" {
            self.bubbleView.layer.shadowOffset = CGSize(width: 3, height: -3)
        } else {
            self.bubbleView.layer.shadowOffset = CGSize(width: -3, height: -3)
        }

        self.bubbleView.layer.shadowOpacity = 0.1

        cellImage?.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
