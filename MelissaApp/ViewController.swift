//
//  ViewController.swift
//  MelissaApp
//
//  Created by Noah Bragg on 9/3/15.
//  Copyright (c) 2015 NoahBragg. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //variables
    var isOnPicture = false
    var timer = NSTimer()
    var imageView: UIView!
    var melissaImage: UIImageView!
    var wordsImage: UIImageView!
    var timerCount = 0
    var startedTouch = false
    var videoIsPlaying = false
    var moviePlayer : MPMoviePlayerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        //create timer
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)

        
        //create the two different images
        wordsImage = UIImageView(image: UIImage(named: "AskOut"))
        melissaImage = UIImageView(image: UIImage(named: "MelissaLaunch"))
        
        
        let rect = CGRectMake(0, 0, melissaImage.frame.size.width, melissaImage.frame.size.height)
        imageView = UIView(frame: rect)
        imageView.addSubview(melissaImage)
        imageView.multipleTouchEnabled = true       //have to enable this
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        view.addSubview(imageView)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        startedTouch = true         //so we know if the screen is being tapped
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        isOnPicture = !isOnPicture      //change the boolean from what it was
        //change the picture
        if isOnPicture {
            UIView.transitionFromView(melissaImage, toView: wordsImage, duration: 0.6, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        } else {
            UIView.transitionFromView(wordsImage, toView: melissaImage, duration: 0.6, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
        }
        
        //makes the counter go back to 0
        timerCount = 0
        startedTouch = false
        
        //for adding the picture
        if touches.count > 1 {
            let picker = UIImagePickerController()
            picker.delegate = self;
            //picker.allowsEditing = true;
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func updateTimer() {
        
        if startedTouch {
            timerCount++
            if timerCount > 5 {
                print("we re greater than 5!")
                if !videoIsPlaying {
                    self.playVideo()
                } else {
                    videoIsPlaying = false
                    if let viewWithTag = self.view.viewWithTag(1) {
                        viewWithTag.removeFromSuperview()
                        moviePlayer?.stop()
                    }
                }
                timerCount = 0
                startedTouch = false
            }
        }
    }
    
    func playVideo() {
        if let
            path = NSBundle.mainBundle().pathForResource("MelissaVid", ofType:"mp4"),
            url = NSURL(fileURLWithPath: path),
            moviePlayer = MPMoviePlayerController(contentURL: url) {
                self.moviePlayer = moviePlayer
                moviePlayer.view.frame = self.view.bounds
                moviePlayer.prepareToPlay()
                moviePlayer.scalingMode = MPMovieScalingMode.AspectFit
                self.view.addSubview(moviePlayer.view)
                moviePlayer.view.tag = 1
                videoIsPlaying = true
        } else {
            debugPrint("Ops, something wrong when playing the video")
        }
    }
    
    //pick an image functions
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        var selectedImage = UIImagePickerControllerEditedImage
        melissaImage.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //so you can add colors from rgb colors
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    //get rid of the status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

