//
//  UIView+Extensions.swift
//  Tekton_GoogleMaps
//
//  Created by Miguel on 20/05/22.
//

import UIKit

extension UIView {
    func hide()  {
        self.alpha = 0
        self.isHidden = true
    }
    func show()  {
        self.alpha = 1
        self.isHidden = false
    }
    
  func lock() {
    if let _ = viewWithTag(10) {
      //View is already locked
    }
    else {
      let lockView = UIView(frame: bounds)
      lockView.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
      lockView.tag = 10
      lockView.alpha = 0.0
      let activity = UIActivityIndicatorView(style: .medium)
      activity.color = .white
      activity.hidesWhenStopped = true
      activity.center = lockView.center
      lockView.addSubview(activity)
      activity.startAnimating()
      addSubview(lockView)
      
      UIView.animate(withDuration: 0.2) {
        lockView.alpha = 1.0
      }
    }
  }
  
  func unlock() {
    if let lockView = viewWithTag(10) {
      UIView.animate(withDuration: 0.2, animations: {
        lockView.alpha = 0.0
      }, completion: { finished in
        lockView.removeFromSuperview()
      })
    }
  }
  
  func fadeOut(_ duration: TimeInterval) {
    UIView.animate(withDuration: duration) {
      self.alpha = 0.0
    }
  }
  
  func fadeIn(_ duration: TimeInterval) {
    UIView.animate(withDuration: duration) {
      self.alpha = 1.0
    }
  }
  
  class func viewFromNibName(_ name: String) -> UIView? {
    let views = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
    return views?.first as? UIView
  }
    // MARK: - Inspectables
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat, shadow: Bool = false) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.015) {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
            
            if shadow {
                let shadowView: UIView = UIView()
                shadowView.backgroundColor = self.backgroundColor
                shadowView.layer.cornerRadius = radius
                shadowView.layer.shadowColor = UIColor.black.cgColor
                shadowView.layer.shadowOffset = CGSize(width: 0, height: 3.0)
                shadowView.layer.shadowOpacity = 0.5
                shadowView.layer.shadowRadius = 5
                self.superview?.insertSubview(shadowView, belowSubview: self)
                shadowView.frame = self.frame
            }
        }
    }
}

func setFont(of type: FontTypes, and size: CGFloat) -> UIFont {
    var fontName = "Metropolis-"
    switch type {
    case .black:
        fontName += "Black"
    case .bold:
        fontName += "Bold"
    case .extraBold:
        fontName += "ExtraBold"
    case .semiBoldItalic:
        fontName += "SemiBoldItalic"
    case .extraLight:
        fontName += "ExtraLigh"
    case .light:
        fontName += "Light"
    case .medium:
        fontName += "Medium"
    case .regular:
        fontName += "Regular"
    case .semibold:
        fontName += "Semibold"
    case .thin:
        fontName += "Thin"
    case .icon:
        fontName = "Font Awesome 5 Free"
    }
    
    let font = UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    return font
}

// MARK: - Fonts
enum FontTypes {
    case black
    case bold
    case semiBoldItalic
    case extraBold
    case extraLight
    case light
    case medium
    case regular
    case semibold
    case thin
    case icon
}

func getIntRandom() -> Int {
    return Int.random(in: 100..<999)
}
func getId() -> String {
    return "\(getIntRandom())-\(getIntRandom())-\(getIntRandom())"
}

extension Double {
    
    func toString(decimal: Int) -> String {
        let value = decimal < 0 ? 0 : decimal
        var string = String(format: "%.\(value)f", self)

        while string.last == "0" || string.last == "." {
            if string.last == "." { string = String(string.dropLast()); break}
            string = String(string.dropLast())
        }
        return string
    }
}
