//
//  TableViewCell.swift
//  Rooster
//
//  Created by Bas Broek on 08/02/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell
{
    @IBOutlet weak var fromTime: UILabel!
    @IBOutlet weak var toTime: UILabel!
    @IBOutlet weak var course: UILabel!
    @IBOutlet weak var room: UILabel!
    @IBOutlet weak var teacher: UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
