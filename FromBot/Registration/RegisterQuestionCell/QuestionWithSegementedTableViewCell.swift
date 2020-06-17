//
//  QuestionWithSegementedTableViewCell.swift
//  jawaz
//
//  Created by Marwan Aziz on 02/08/2018.
//  Copyright © 2018 Marwan Aziz. All rights reserved.
//

import UIKit

class QuestionWithSegementedTableViewCell: QuestionTableViewCell {

//    @IBOutlet weak var segement:CustomSegmentControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
//        self.segement?.loadTheView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
