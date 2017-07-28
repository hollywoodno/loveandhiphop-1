//
//  CaptionableImageView.swift
//  LoveAndHiphop
//
//  Created by hollywoodno on 7/26/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

class CaptionableImageView: UIView {
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet var contentView: UIView!


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
  
  // Provide outlets for users of custom class to 
  // supply an image to the image view
  var image: UIImage? {
    get {return profileImageView.image}
    set {profileImageView.image = newValue}
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    initSubviews()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initSubviews()
  }
  
  func initSubviews() {
    // standard initialization logic
    let nib = UINib(nibName: "CaptionableImageView", bundle: nil)
    nib.instantiate(withOwner: self, options: nil)
    contentView.frame = bounds
    addSubview(contentView)
      
      // custom initialization logic
  }

}
