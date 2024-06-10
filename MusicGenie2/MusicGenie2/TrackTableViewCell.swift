//
//  TrackTableViewCell.swift
//  MusicGenie2
//
//  Created by Josemaría Macedo Carrillo on 3/6/24.
//

/*
 Resources:
 - Code from Assignment 3 "GitHub Issues" from iOS Application Development course by Josemaria Macedo.
 */

import UIKit

class TrackTableViewCell: UITableViewCell {
    
    @IBOutlet var song: UILabel!
    @IBOutlet var artist: UILabel!
    @IBOutlet var checkmark: UIImageView!
    
    @IBOutlet var song2: UILabel!
    @IBOutlet var artist2: UILabel!
    @IBOutlet var checkmark2: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
