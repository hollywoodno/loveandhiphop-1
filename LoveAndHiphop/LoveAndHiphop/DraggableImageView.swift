//
//  DraggableImageView.swift
//  LoveAndHiphop
//
//  Created by hollywoodno on 7/26/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

enum Direction {
  case left, right
}

protocol DraggableImageViewDelegate {
  func dragOffScreen(draggableImageView: DraggableImageView, direction: Direction)
  
}

class DraggableImageView: UIView {
  
  // MARK - Properties
  @IBOutlet weak var picImageView: UIImageView!
  @IBOutlet var panGesture: UIPanGestureRecognizer!
  @IBOutlet var contentView: UIView!
  var picImageCenter: CGPoint!
  var delegate: DraggableImageViewDelegate?
  var image: UIImage? {
    get {return picImageView.image}
    set {picImageView.image = newValue}
  }
  
  // MARK: - Methods
  @IBAction func onProfilePan(_ sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: self)
    let velocity = sender.velocity(in: self)
    
    if sender.state == .began {
      picImageCenter = picImageView.center
    } else if sender.state == .changed {
      // Move in direction of user input and rotate it
      picImageView.center = CGPoint(x: picImageCenter.x + translation.x, y: picImageCenter.y)
      if velocity.x < 1 {
        // Going Left
        picImageView.transform = CGAffineTransform(rotationAngle: CGFloat(-15.degreesToRadians))
        // if user dislikes
      } else {
        // Going right
        picImageView.transform = CGAffineTransform(rotationAngle: CGFloat(15.degreesToRadians))
      }
    } else {
      // Check if direction is passed threshold points
      if translation.x < -100 || translation.x > 100 {
        if translation.x < -100 {
          delegate?.dragOffScreen(draggableImageView: self, direction: .left)
        } else {
          delegate?.dragOffScreen(draggableImageView: self, direction: .right)
        }
      } else {
        // Reset image to default position
        picImageView.center = picImageCenter
        picImageView.transform = CGAffineTransform.identity
      }
    }
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
    let nib = UINib(nibName: "DraggableImageView", bundle: nil)
    nib.instantiate(withOwner: self, options: nil)
    contentView.frame = bounds
    picImageCenter = picImageView.center
    picImageView.addGestureRecognizer(panGesture)
    addSubview(contentView)
  }
  
}

extension Int {
  var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
extension FloatingPoint {
  var degreesToRadians: Self { return self * .pi / 180 }
  var radiansToDegrees: Self { return self * 180 / .pi }
}
