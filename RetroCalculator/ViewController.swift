//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Ahmed Yacoub on 11/24/17.
//  Copyright © 2017 Ahmed Yacoub. All rights reserved.
//

import UIKit
import AVFoundation // A framework for working with time based audiovisual media.

class ViewController: UIViewController {
    
    // Button sound
    var btnSound: AVAudioPlayer!
    
    // Label output 
    @IBOutlet weak var laOutput: UILabel!
    
    // A flag to hold which number is pressed
    var runningNumber = ""
    
    // Operations
    enum Operations: String {
        case Add = "+"
        case Subtract = "-"
        case Multiply = "*"
        case Divide = "/"
        case Empty = "Empty"
    }
    
    // Current operation
    var currentOperation = Operations.Empty
    
    // Left & Rigth hand sides
    var leftHandSide = ""
    var rightHandSide = ""
    var result = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get btn.wav path
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        
        // Get Path URL
        let soundURL = URL(fileURLWithPath: path!)
        
        
        // Try to pass btn.wav to AvAudioPlayer and prepare to play
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound?.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    // Link all buttons to play sound
    // @Param: sender [UIButton]
    @IBAction func numberPressed(sender: UIButton) {
        // call playSound method
        playSound()
        
        // append numbers pressed to get the actuall number that user wants to operate, ex: 4, 3, 7 = 437
        runningNumber += "\(sender.tag)"
        
        // set label text to the current number
        laOutput.text = runningNumber
    }
    
    // Perform addition calculation
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(operation: .Add)
    }
    
    // Perform subtraction calculation
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(operation: .Subtract)
    }
    // Perform multipliction calculation
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(operation: .Multiply)
    }
    // Perform division calculation
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(operation: .Divide)
    }
    // Get result
    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(operation: currentOperation)
    }
    
    // Clear screen
    @IBAction func onClearPressed(_ sender: Any) {
        playSound()                             // play beeb sound on press
        
        laOutput.text = ""                      // clear screen
        runningNumber = ""                      // resets current number
        currentOperation = Operations.Empty     // resets current operation to empty
    }
    
    // Play button sound
    func playSound() {
        // check if sound is already playing
        if (btnSound?.isPlaying)! {
            btnSound?.stop()
        }
        
        btnSound?.play()
    }
    
    // Process math operations
    // @Param: operation [enum:Operations]
    func processOperation(operation: Operations) {
        
        // play sound
        playSound()
        
        // checks if user didn't entered an operation
        if currentOperation != Operations.Empty {
            
            // checks if user didn't entered more than 1 operation
            if runningNumber != "" {
                rightHandSide = runningNumber
                runningNumber = ""
                
                // switch over which operation to operate
                if currentOperation ==  Operations.Add {
                    result = "\(Double(leftHandSide)! + Double(rightHandSide)!)"
                }else if currentOperation == Operations.Subtract {
                    result = "\(Double(leftHandSide)! - Double(rightHandSide)!)"
                } else if currentOperation == Operations.Multiply {
                    result = "\(Double(leftHandSide)! * Double(rightHandSide)!)"
                } else if currentOperation == Operations.Divide {
                    result = "\(Double(leftHandSide)! / Double(rightHandSide)!)"
                }
            
                // Accumelate numbers
                leftHandSide = result
                laOutput.text = result
            }
            
            // reset operation to the new operation
            currentOperation = operation
        }
        // get left hand side
        else {
            leftHandSide = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }

}

