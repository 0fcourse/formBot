//
//  ChatInput.swift
//  jawaz
//
//  Created by Marwan Aziz on 29/07/2018.
//  Copyright © 2018 Marwan Aziz. All rights reserved.
//

import UIKit
protocol ChatInputDelegate: class {

    func chatInputSend(text:String)
    func chatInputHeightDidChange(height:CGFloat)
}

class ChatInput: UIView ,UITextViewDelegate {
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var ConstraintContainerHeight:NSLayoutConstraint!
    @IBOutlet weak var constraintsTextCounterWidth:NSLayoutConstraint!
    @IBOutlet weak var ConstraintContainerBottom:NSLayoutConstraint!
    weak var delegate: ChatInputDelegate?
    var textMaxLimit:Int = 0
    private let textCounterWidth:CGFloat = 44

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.txtMessage.delegate = self
        self.lblCounter.text = "1000"
        self.txtMessage.text = ""
        self.txtMessage.layer.cornerRadius = 5
        if textMaxLimit == 0 {
            hideTextCounter(hide: true)
        } else {
            self.lblCounter.text = "\(textMaxLimit)"
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func hideTextCounter(hide :Bool) {
        if hide {
            self.lblCounter.text = ""
            self.constraintsTextCounterWidth.constant = 0
        } else {
            self.constraintsTextCounterWidth.constant = textCounterWidth
        }
        self.layoutIfNeeded()
    }

    @IBAction func sendPressed(sender: Any) {
        let text = self.txtMessage.text
        if text?.isEmpty ?? true {
            return
        }
        if self.delegate != nil {
            self.delegate?.chatInputSend(text: text!)
        }
        self.txtMessage.text = ""
        if textMaxLimit == 0 {
            hideTextCounter(hide: true)
        } else {
            self.lblCounter.text = "\(textMaxLimit)"
        }
        self.ConstraintContainerHeight.constant = 45
        self.layoutIfNeeded()
    }

    func textViewDidChange(_ textView: UITextView) {
        let components = textView.text.components(separatedBy: "\n")
        if components.count < 6 {
            let height =  components.count == 1 ? 45 :CGFloat(45 + components.count * 10)
            self.ConstraintContainerHeight.constant = height
            self.superview?.layoutIfNeeded()
            if self.delegate != nil {
                self.delegate?.chatInputHeightDidChange(height: height)
            }
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textMaxLimit > 0 {
            if textView.text.count >= textMaxLimit && text != "" {
                return false
            } else {
                var textCount = textView.text.count
                if textCount > 0 && text  == "" {
                    textCount -= 1
                } else {
                    textCount += text.count
                }
                let numberOfCharactersLeft = textMaxLimit - textCount
                UIView.animate(withDuration: 0.2) {[weak self] in
                    self?.lblCounter.text = "\(numberOfCharactersLeft)"
                }
            }
        }
        return true
    }
}

extension UITextView {
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
