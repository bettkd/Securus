//
//  TimelineTableViewCell.swift
//  Securus
//
//  Created by Dominic Bett on 12/1/15.
//  Copyright © 2015 DominicBett. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameText: UILabel! = UILabel()
    @IBOutlet weak var dateTimeText: UILabel! = UILabel()
    @IBOutlet weak var descriptionText: UITextView! = UITextView()
    @IBOutlet weak var voteCountText: UILabel! = UILabel()
    @IBOutlet weak var voteUp: UIButton!
    @IBOutlet weak var voteDown: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
