//
//  PlaylistTableViewCell.swift
//  MusicGenie2
//
//  Created by Josemaría Macedo Carrillo on 3/6/24.
//

/*
 Resources:
 - Code from Assignment 3 "GitHub Issues" from iOS Application Development course by Josemaria Macedo.
 */

import UIKit

class PlaylistTableViewCell: UITableViewCell {
    
    @IBOutlet var playlistName: UILabel!
    @IBOutlet var playlistImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        playlistName.textColor = UIColor.blue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
