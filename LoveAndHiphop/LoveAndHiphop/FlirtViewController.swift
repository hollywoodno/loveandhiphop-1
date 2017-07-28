//
//  FlirtViewController.swift
//  LoveAndHiphop
//
//  Created by hollywoodno on 7/26/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

class FlirtViewController: UIViewController, DraggableImageViewDelegate {
  
  // MARK: - Properties
  @IBOutlet weak var profilePicImageView: DraggableImageView!
  @IBOutlet weak var profilePicImageViewCenterXConstant: NSLayoutConstraint!
  @IBOutlet weak var profilePicImageViewCenterYConstant: NSLayoutConstraint!
  var profilePicCenter: CGPoint!
  
  // MARK: - Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    profilePicCenter = profilePicImageView.center
    profilePicImageView.image = UIImage(named: "ryan")
    profilePicImageView.delegate = self
  }
  
  // Delegates
  func dragOffScreen(draggableImageView: DraggableImageView, direction: Direction) {
    UIView.animate(withDuration: 2.0, animations: {
      if direction == .left {
        self.profilePicImageViewCenterYConstant.constant = -400
      } else {
        self.profilePicImageViewCenterYConstant.constant = 400
      }
    }, completion: { (success: Bool) in
      print("Flew Off Screen")
    })
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
