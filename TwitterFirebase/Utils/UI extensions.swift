//
//  UIColor + UIView.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 20/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit


extension UIColor{
    //static keyword allows to call the method on the class itself
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func textBlue() -> UIColor{
        return UIColor.rgb(red: 17, green: 154, blue: 237)
    }
    
    static func mainBlue() -> UIColor{
        return UIColor.rgb(red: 50, green: 171, blue: 223)
    }
    
    static func lightBlue() -> UIColor {
        return UIColor.rgb(red: 98, green: 239, blue: 247)
    }
    
    static func bgColor() -> UIColor{
        return UIColor.rgb(red: 232, green: 236, blue: 241)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension UIView {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

//extension UINavigationBar {
//
//    func transparentNavigationBar() {
//        self.setBackgroundImage(UIImage(), for: .default)
//        self.shadowImage = UIImage()
//        self.isTranslucent = true
//    }
//}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,  paddingLeft: CGFloat = 0, paddingBot: CGFloat = 0, paddingRight: CGFloat = 0,
                width: CGFloat = 0, height: CGFloat = 0
        ){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBot).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

//Extending struct UIButton
//Adding Properties: shake

extension UIButton {
    
    func shake() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}



