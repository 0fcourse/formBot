//
//  QuestionTableViewCell.swift
//  jawaz
//
//  Created by Marwan Aziz on 02/08/2018.
//  Copyright © 2018 Marwan Aziz. All rights reserved.
//

import UIKit

class QuestionTableViewCell: ChatCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
