//
//  Toast.swift
//  Tekton_GoogleMaps
//
//  Created by Miguel on 22/05/22.
//

import Foundation
import UIKit

enum ToastDirection {
    case top
    case bottom
}

class UICustomLabel: UILabel {
    let UIEI = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10) // as desired

    override var intrinsicContentSize:CGSize {
        numberOfLines = 0       // don't forget!
        var s = super.intrinsicContentSize
        s.height = s.height + UIEI.top + UIEI.bottom
        s.width = s.width + UIEI.left + UIEI.right
        return s
    }

    override func drawText(in rect:CGRect) {
        let r = rect.inset(by: UIEI)
        super.drawText(in: r)
    }

    override func textRect(forBounds bounds:CGRect,
                               limitedToNumberOfLines n:Int) -> CGRect {
        let b = bounds
        let tr = b.inset(by: UIEI)
        let ctr = super.textRect(forBounds: tr, limitedToNumberOfLines: 0)
        // that line of code MUST be LAST in this function, NOT first
        return ctr
    }
}

class Toast {
    
    static var keyboardHeight: CGFloat = 0.0
    
    @discardableResult
    init(duration: Double = 0,text: String, container: UINavigationController? = nil, viewController: UIViewController? = nil, backgroundColor: UIColor = Colors.lightGreen, direction: ToastDirection = .bottom, completion: @escaping (() -> Void)) {
        let screenSize = UIScreen.main.bounds
        let labelHeight: CGFloat = 66
        let rect = CGRect(
            x: 12,
            y: direction == .top ? -labelHeight : UIScreen.main.bounds.height + labelHeight - Toast.keyboardHeight,
            width: screenSize.width - 24,
            height: labelHeight
        )
        
        let label = UICustomLabel(frame: rect)
        label.text = text
        label.alpha = 0
        label.textColor = .white
        label.backgroundColor = backgroundColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        label.font = setFont(of: .regular, and: 14.0)
        label.textAlignment = .center
        label.roundCorners([.allCorners], radius: 3)
        
        label.frame.inset(by: UIEdgeInsets(top: 3, left: 5, bottom: 5, right: 3))
        
        var timeToShow: Double = Double(text.count) / 20
        timeToShow = timeToShow < 1.5 ? 1.5 : timeToShow
        timeToShow = duration == 0 ? timeToShow : duration
        let tabBarHeight: CGFloat = ((container?.navigationBar.frame.height ?? 0.0) + 20 + 12)
        
        container?.view.addSubview(label)
        viewController?.view.addSubview(label)
        
        UIView.animate(withDuration: 0.35, animations: {
            label.alpha = 1
            if direction == .top {
                label.frame.origin.y += labelHeight + tabBarHeight + 8
            } else {
                label.frame.origin.y -= (labelHeight + tabBarHeight + 84)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + timeToShow, execute: {
                UIView.animate(withDuration: 0.5, animations: {
                    if direction == .top {
                        label.frame.origin.y -= (labelHeight + tabBarHeight)
                    } else {
                        label.frame.origin.y += (labelHeight + tabBarHeight)
                    }
                    
                    label.alpha = 0
                }, completion: { _ in
                    label.removeFromSuperview()
                    completion()
                })
            })
        })
    }
    
}
