//
//  FirstViewController.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 4/25/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import Parse
import AFNetworking

class MatchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MatchCellDelegate {
  
  // MARK: Properties
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var cancelImageView: MatchCell!
  @IBOutlet weak var likeUnlikeImageView: MatchCell!
  
  // Potential matches for current user
  var matches: [PFUser] = []
  var userLikedMatches: [String: Bool] = [:]
  var matchesWhoLikedUser: [String: Bool] = [:]
  var cancelledMatches: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 200
    
    // MARK: Load matches
    let currentUser = PFUser.current()
    if currentUser != nil {
      if currentUser?["cancelledMatches"] != nil {
        cancelledMatches.append(contentsOf: currentUser?["cancelledMatches"] as! [String])
      }
      loadMatches(for: currentUser!)
    }
  }
  
  // MARK: Methods
  
  /**
   * Method Name: loadMatchesForCurrentUser()
   *
   * The matching algorithm will find all matches for the current user basd on:
   * 1. Users who are not the current user
   * 2. Users who match the Current User's interested gender
   * TBD - Improving the algorithm once sign up flow is complete
   **/
  func loadMatches(for user: PFUser) {
    
    // First get matches who are not current user and are the preferred gender,
    let query: PFQuery = PFUser.query()!
    query.whereKey("objectId", notEqualTo: user.objectId!)
    query.whereKey("gender", equalTo: (user["genderPreference"] as? String)!)
    query.findObjectsInBackground{ (matches: [PFObject]?, error: Error?) in
      
      if error != nil {
        print("Error retrieving matches: error: \(error?.localizedDescription)")
      }
      
      if matches != nil {
        let matches = matches as! [PFUser]
        
        // Further filter the matches on cancelled matches by the user.
        let cancelledMatches = user["cancelledMatches"] as? [String]
        for match in matches {
          if cancelledMatches != nil {
            if (!cancelledMatches!.contains(match.objectId!)) {
              self.matches.append(match)
            }
          } else {
            self.matches = matches
          }
        }
        
        // Get the users who liked current users
        // and vice versa.
        self.getMatchesWhoLike(user: user)
        self.getMatchesWhoUserLike(user)
        self.tableView.reloadData()
        
      }
    }
  }
  
  func getMatchesWhoLike(user: PFUser) {
    
    // Go through list of potential matches for current user
    for potentialMatch in matches {
      let potentialMatchObjectId: String = potentialMatch.objectId!
      
      // Get the users who have liked this potential match
      let query = PFQuery(className: "Like")
      query.whereKey("user", equalTo: potentialMatch) // Is match user
      query.whereKey("likedUser", equalTo: user)
      query.getFirstObjectInBackground(block: { (potentialMatchUserLike: PFObject?, error: Error?) in
        if error != nil {
          print("Error retrieving users who liked current user, error: \(error?.localizedDescription)")
        }
        
        // Update matchLikedBy to include who liked this match
        if potentialMatchUserLike != nil {
          print("Current match HAS LIKED CURRENT USER match: \(potentialMatch["firstName"])!")
          self.matchesWhoLikedUser[potentialMatchObjectId] = true
        }
      })
    }
  }
  
  func getMatchesWhoUserLike(_ user: PFUser) {
    // Go through list of potential matches for current user
    // Get the users who have liked this potential match
    let query = PFQuery(className: "Like")
    query.whereKey("user", equalTo: user)
    query.findObjectsInBackground(block: { (userLikes: [PFObject]?, error: Error?) in
      if error != nil {
        print("Error retrieving users who liked current user, error: \(error?.localizedDescription)")
      }
      
      if userLikes != nil {
        print("HERE ARE USER LIKES, \(userLikes)")
        for userLike in userLikes! {
          print("Here is the liked user, likedUser: \(userLike["likedUser"])")
          let likedUser = userLike["likedUser"] as! PFUser
          self.userLikedMatches[likedUser.objectId!] = true
        }
      }
    })
  }
  
  
  // MARK: Delegate Methods
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //TODO: eventually return the count of the matches from the findMyMatches() method
    return matches.count
    
  }
  
  // TODO: Not displaying onload when users have already liked someone.
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let matchCell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath) as! MatchCell
    
    let userObject = UserObject(pfObject: matches[indexPath.row])
    matchCell.userObject = userObject
    matchCell.delegate = self
    
    // Check if "you liked" label should be displayed
    if (!userLikedMatches.isEmpty) {
      print(userLikedMatches)
      if userLikedMatches[userObject.userObjectId!] != nil {
        matchCell.likedByCurrentUser = userLikedMatches[userObject.userObjectId!]!
      }
    }
    return matchCell
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("i got selected")
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  @objc internal func MatchCell(matchCell: MatchCell, didLikeUser value: Bool) {
    let indexPath = tableView.indexPath(for: matchCell)
    let likedUser = matches[(indexPath?.row)!]
    
    let like = PFObject(className: "Like", dictionary: ["user": PFUser.current()!, "likedUser": likedUser])
    matchCell.youLikedLabel.isHidden = false
    like.saveInBackground { (success: Bool, error: Error?) in
      if error != nil {
        // Will have to adjust UI to display error
        print("Error updating like status, error: \(error?.localizedDescription)")
      } else {
        self.userLikedMatches[likedUser.objectId!] = true
      }
    }
  }
  
  @objc internal func MatchCellCancelled(matchCell: MatchCell, didCancelUser value: Bool) {
    
    let indexPath = tableView.indexPath(for: matchCell)
    let cancelledUser = matches[(indexPath?.row)!]
    
    matches.remove(at: (indexPath?.row)!)
    
    // Update cancelled matches data source
    cancelledMatches.append(cancelledUser.objectId!)
    
    
    PFUser.current()?.addUniqueObjects(from: cancelledMatches, forKey: "cancelledMatches")
    PFUser.current()?.saveInBackground(block: { (success: Bool, error: Error?) in
      if error != nil {
        print("Error adding user to cancelled matches, error: \(error?.localizedDescription)")
      }
      
      if success {
        print("User was cancelled")
      }
    })
    
    // Remove row from UI
    tableView.deleteRows(at: [indexPath!], with: .fade)
  }
  
  
  
  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    print(" Yea me too")
    let detailViewController = segue.destination as! DetailViewController
    let indexPath = self.tableView.indexPath(for: sender as! MatchCell)
    let user = matches[(indexPath?.row)!]
    //    let userObjectId: String = (user.userObjectId)!
    //    detailViewController.likedByUsers = self.matchLikedBy[userObjectId]
    let userObject = UserObject(pfObject: user)
    detailViewController.userObject = userObject
  }
  
}
