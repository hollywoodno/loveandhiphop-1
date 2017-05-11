//
//  MatchCell.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 5/9/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import SwiftyGif

class MatchCell: UITableViewCell {
    

    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var lovemenotImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var hiphopIdentityLabel: UILabel!
    var userObject: UserObject! {
        didSet{
            profilePicImageView.setImageWith(userObject.profileImageUrl!)
            locationLabel.text = userObject.city
            occupationLabel.text = userObject.occupation
            hiphopIdentityLabel.text = userObject.hiphopIdentity
            nameLabel.text = userObject.fullName
           
          
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func onClickLikeButton(_ sender: UIButton) {
        print("somebody liked me")
    }

    @IBAction func onClickUnlikeButton(_ sender: UIButton) {
        print("somebody hates me")
    }
    
}
