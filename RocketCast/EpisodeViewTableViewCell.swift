//
//  EpisodeViewTableViewCell.swift
//  RocketCast
//
//  Created by Admin on 2016-09-24.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit

protocol EpisodeViewTableViewCellDelegate{
}

class EpisodeViewTableViewCell: UITableViewCell {
    @IBOutlet weak var episodeHeader: UILabel!
    var delegate: EpisodeViewTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setEpisodeHeaderText(setHeader: NSMutableString) {
        episodeHeader.text = setHeader as String
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        if !selected {
            episodeHeader.textColor = UIColor.blackColor()
        } else {
            episodeHeader.textColor = UIColor.redColor()
        }
        
    }
}

