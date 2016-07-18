//
//  ViewController.swift
//  ZenGarden
//
//  Created by Flatiron School on 6/30/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var rake: UIImageView!
    @IBOutlet weak var rock: UIImageView!
    @IBOutlet weak var shrub: UIImageView!
    @IBOutlet weak var sword: UIImageView!
    @IBOutlet weak var bottomLeftCorner: UIView!
    @IBOutlet weak var topRightCorner: UIView!
    @IBOutlet weak var topLeftCorner: UIView!
    @IBOutlet weak var bottomRightCorner: UIView!
    
    var rakeXConstraint: NSLayoutConstraint?
    var rakeYConstraint: NSLayoutConstraint?
    var shrubXConstraint: NSLayoutConstraint?
    var shrubYConstraint: NSLayoutConstraint?
    var rockXConstraint: NSLayoutConstraint?
    var rockYConstraint: NSLayoutConstraint?
    var swordXConstraint: NSLayoutConstraint?
    var swordYConstraint: NSLayoutConstraint?
    
    var previousRakeCoordinates: CGPoint?
    var previousShrubCoordinates: CGPoint?
    var previousRockCoordinates: CGPoint?
    var previousSwordCoordinates: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.removeConstraints(self.view.constraints)
        
        setImageHeightWidth(rake)
        setImageHeightWidth(rock)
        setImageHeightWidth(shrub)
        setImageHeightWidth(sword)
        setImageXYConstraints()
        
        setCornerViewHeightWidth(topLeftCorner)
        setCornerViewHeightWidth(topRightCorner)
        setCornerViewHeightWidth(bottomLeftCorner)
        setCornerViewHeightWidth(bottomRightCorner)
        setCornerViewConstraints()
        
        createDragRecognizers()
    }
    
    func setCornerViewHeightWidth(corner: UIView) {
        corner.translatesAutoresizingMaskIntoConstraints = false
        corner.removeConstraints(corner.constraints)
        corner.heightAnchor.constraintEqualToAnchor(view.heightAnchor, multiplier: 0.2).active = true
        corner.widthAnchor.constraintEqualToAnchor(view.widthAnchor, multiplier: 0.2).active = true
    }
    
    func setCornerViewConstraints() {
        topLeftCorner.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        topLeftCorner.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        
        topRightCorner.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        topRightCorner.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        
        bottomLeftCorner.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        bottomLeftCorner.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        
        bottomRightCorner.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        bottomRightCorner.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
    }
    
    func setImageHeightWidth(image: UIImageView) {
        image.translatesAutoresizingMaskIntoConstraints = false
        image.removeConstraints(image.constraints)
        image.contentMode = .ScaleAspectFit
        image.heightAnchor.constraintEqualToAnchor(view.heightAnchor, multiplier: 0.2).active = true
        image.widthAnchor.constraintEqualToAnchor(view.widthAnchor, multiplier: 0.2).active = true
    }
    
    func setImageXYConstraints() {
        rakeXConstraint = rake.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: -100)
        rakeXConstraint?.active = true
        rakeYConstraint = rake.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -100)
        rakeYConstraint?.active = true
        
        rockXConstraint = rock.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: 100)
        rockXConstraint?.active = true
        rockYConstraint = rock.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -100)
        rockYConstraint?.active = true
        
        shrubXConstraint = shrub.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: -100)
        shrubXConstraint?.active = true
        shrubYConstraint = shrub.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: 100)
        shrubYConstraint?.active = true
        
        swordXConstraint = sword.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: 100)
        swordXConstraint?.active = true
        swordYConstraint = sword.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: 100)
        swordYConstraint?.active = true
    }
    
    func createDragRecognizers() {
        let rakeRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(draggingRake))
        rake.addGestureRecognizer(rakeRecognizer)
        
        let shrubRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(draggingShrub))
        shrub.addGestureRecognizer(shrubRecognizer)
        
        let rockRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(draggingRock))
        rock.addGestureRecognizer(rockRecognizer)
        
        let swordRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(draggingSword))
        sword.addGestureRecognizer(swordRecognizer)
    }
    
    /*
     Win conditions:
     1. King Arthur's sword located in the top left or bottom left.
     2. Shrub and rake should be near each other (choose what your definition of near is).
     3. Rock needs to be on a different North/South half of the screen as King Arthur's Sword. So if the sword is on the top, the other stone should be on the bottom.
     */
    
    func winConditionsMet() -> Bool {

        // .convertRect function transforms the rects to the superview coordinate space in order to compare them:
        let rakeLocation = rake.convertRect(rake.bounds, toView: view)
        let rockLocation = rock.convertRect(rock.bounds, toView: view)
        let shrubLocation = shrub.convertRect(shrub.bounds, toView: view)
        let swordLocation = sword.convertRect(sword.bounds, toView: view)
        print("Rake: \(rakeLocation)\nRock: \(rockLocation)\nShrub: \(shrubLocation)\nSword: \(swordLocation)")
        
        let topLeftRect = topLeftCorner.convertRect(topLeftCorner.bounds, toView: view)
        let topRightRect = topRightCorner.convertRect(topRightCorner.bounds, toView: view)
        let bottomLeftRect = bottomLeftCorner.convertRect(bottomLeftCorner.bounds, toView: view)
        let bottomRightRect = bottomRightCorner.convertRect(bottomRightCorner.bounds, toView: view)
        print("Top left: \(topLeftRect)\nTop Right: \(topRightRect)\nBottom Left: \(bottomLeftRect)\nBottom Right: \(bottomRightRect)")
        
        if CGRectIntersectsRect(rakeLocation, shrubLocation) &&
            (CGRectIntersectsRect(topLeftRect, swordLocation) && (CGRectIntersectsRect(bottomLeftRect, rockLocation) || CGRectIntersectsRect(bottomRightRect, rockLocation))) ||
            (CGRectIntersectsRect(bottomLeftRect, swordLocation) && (CGRectIntersectsRect(topLeftRect, rockLocation) || CGRectIntersectsRect(topRightRect, rockLocation))) {
            print("You won")
            return true
        }
        print("Not zen yet")
        return false
    }
    
    func winAlert() {
        if winConditionsMet() {
            let winAlert = UIAlertController(title: "Default Style", message: "You won!", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Play Again", style: .Cancel) { (action) in
                self.rakeXConstraint?.active = false
                self.rakeYConstraint?.active = false
                self.rockXConstraint?.active = false
                self.rockYConstraint?.active = false
                self.shrubXConstraint?.active = false
                self.shrubYConstraint?.active = false
                self.swordXConstraint?.active = false
                self.swordYConstraint?.active = false
                self.setImageXYConstraints()
            }
            winAlert.addAction(cancelAction)
            
            self.presentViewController(winAlert, animated: true) {
                
            }
        }
    }
    
    func draggingRake(recognizer: UIPanGestureRecognizer) {
        // Declare a constant to capture the x,y coordinates of the image based on the dragging movement in the superview. This gets reset to the current position everytime draggingImage is called.
        let currentCoordinates = recognizer.translationInView(rake)
        
        // If you begin a new dragging movement, reset previousCoordinates variable to (0,0).
        if recognizer.state == .Began {
            previousRakeCoordinates = CGPointMake(0, 0)
        
        // Otherwise, determine the difference between the current coordinates and previousCoordinates. Move the image by this difference, by adding the difference to the image's x,y constraint constants. Then reset previousCoordinates, so that it will capture the delta between new coordinates when the method is called again
        } else {
            if let previousCoorindates = self.previousRakeCoordinates {
                let deltaY = currentCoordinates.y - previousCoorindates.y
                let deltaX = currentCoordinates.x - previousCoorindates.x
            
                rakeYConstraint?.constant += deltaY
                rakeXConstraint?.constant += deltaX
                previousRakeCoordinates = currentCoordinates
                winConditionsMet()
                winAlert()
            }
        }
    }
    
    func draggingShrub(recognizer: UIPanGestureRecognizer) {
        let currentCoordinates = recognizer.translationInView(shrub)
        
        if recognizer.state == .Began {
            previousShrubCoordinates = CGPointMake(0, 0)
            
        } else {
            if let previousCoorindates = self.previousShrubCoordinates {
                let deltaY = currentCoordinates.y - previousCoorindates.y
                let deltaX = currentCoordinates.x - previousCoorindates.x
                
                shrubYConstraint?.constant += deltaY
                shrubXConstraint?.constant += deltaX
                previousShrubCoordinates = currentCoordinates
                winConditionsMet()
                winAlert()
            }
        }
    }
    
    func draggingRock(recognizer: UIPanGestureRecognizer) {
        let currentCoordinates = recognizer.translationInView(rock)
        
        if recognizer.state == .Began {
            previousRockCoordinates = CGPointMake(0, 0)
            
        } else {
            if let previousCoorindates = self.previousRockCoordinates {
                let deltaY = currentCoordinates.y - previousCoorindates.y
                let deltaX = currentCoordinates.x - previousCoorindates.x
                
                rockYConstraint?.constant += deltaY
                rockXConstraint?.constant += deltaX
                previousRockCoordinates = currentCoordinates
                winConditionsMet()
                winAlert()
            }
        }
    }
    
    func draggingSword(recognizer: UIPanGestureRecognizer) {
        let currentCoordinates = recognizer.translationInView(sword)
        
        if recognizer.state == .Began {
            previousSwordCoordinates = CGPointMake(0, 0)
            
        } else {
            if let previousCoorindates = self.previousSwordCoordinates {
                let deltaY = currentCoordinates.y - previousCoorindates.y
                let deltaX = currentCoordinates.x - previousCoorindates.x
                
                swordYConstraint?.constant += deltaY
                swordXConstraint?.constant += deltaX
                previousSwordCoordinates = currentCoordinates
                winConditionsMet()
                winAlert()
            }
        }
    }
}

