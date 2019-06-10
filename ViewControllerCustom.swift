//
//  ViewControllerCustom.swift
//  nano1
//
//  Created by Daniele Gargiulo on 08/11/2018.
//  Copyright © 2018 Daniele Gargiulo. All rights reserved.
//

import UIKit

extension String {
    var characterArray: [Character]{
        var characterArray = [Character]()
        for character in self {
            characterArray.append(character)
        }
        return characterArray
    }
}

@IBDesignable

class ViewControllerCustom: UIViewController {

    @IBOutlet var textViewMain: UITextView!
    @IBOutlet var nextButton:UIButton?
    @IBOutlet var waveImage: UIImageView!
    
    @IBInspectable var frase1: String = ""
    @IBInspectable var frase2: String = ""
    @IBInspectable var frase3: String = ""
    @IBInspectable var frase4: String = ""
    @IBInspectable var typeSpeed: Double = 0.2
    
    @IBInspectable var topColor: UIColor = UIColor.white
    @IBInspectable var bottomColor: UIColor = UIColor.black
    
    var index=0
    var done:Bool=true  //true if typing has finished, false if typing is running
    var timerType:Timer?
    var frasi:[String]=[""]
    
    override func viewDidLoad() {
        frasi.remove(at: 0)
        if frase1 != ""
        {frasi.append(frase1)}
        if frase2 != ""
        {frasi.append(frase2)}
        if frase3 != ""
        {frasi.append(frase3)}
        if frase4 != ""
        {frasi.append(frase4)}
        
        createGradient()
        
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut, animations: {
            
        }, completion: nil)
        
        
    }
    
    func createGradient()
    {
        var BGgradient:CAGradientLayer!
        BGgradient=CAGradientLayer()
        BGgradient.frame=self.view.bounds
        BGgradient.colors=[topColor.cgColor,bottomColor.cgColor]
        BGgradient.locations=[0,1]
        self.view.layer.insertSublayer(BGgradient, at: 0)
    }
    
    func typeOn(string: String)  {
        let characterArray = string.characterArray
        var characterIndex = 0
        
        timerType = Timer.scheduledTimer(withTimeInterval: typeSpeed, repeats: true) {
            (timer) in self.textViewMain.text.append(characterArray[characterIndex])
            characterIndex += 1
            self.vibrate()
            if characterIndex == characterArray.count {
                self.done=true
                self.timerType!.invalidate()
            }
            else
            {self.done=false}
        }
    }

    @IBAction func nextButtonPress(_ sender: UIButton) {
        if done {
            textViewMain.text=""
            typeOn(string: frasi[index])
            index+=1
            if index >= frasi.count {index=0
                self.navigationController?.popViewController(animated: true)
            }
        }
        else
        {
            if index==0 {index=frasi.count-1}
            else {index-=1}
            timerType?.invalidate()
            textViewMain.text=frasi[index]
            index+=1
            if index >= frasi.count {index=0}
            done=true
        }
    }
    
    func vibrate()
    {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
}
