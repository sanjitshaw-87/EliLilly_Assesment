//
//  CustomActivityIndicator.swift
//  CustomActivityIndicator
//
//  Created by Sanjit Shaw on 24/08/18.
//  Copyright © 2018 Sanjit Shaw. All rights reserved.
//

import UIKit

enum ActivityIndicatorType : Int
{
    case eCustomLarge
    case eCustomSmall
    case eNativeWhite
    case eNativeGray
    case eNativeWhiteLarge
    case eImageIndicator
}

enum ActivityAlignment
{
    case eTopAlign
    case eCenterAlign
    case eBottomAlign
}


private class CustomActivity : UIView
{
    var gradientColorSet : [CGColor]? = nil
    var indicatorType : ActivityIndicatorType = .eCustomSmall
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let circle = CAShapeLayer()
        var circleRadius : CGFloat = 0.0
        var lineWidth : CGFloat = 0.0
        switch indicatorType {
        case .eCustomSmall:
            circleRadius = rect.size.width/2.0 - 3.0
            lineWidth = 3.0
        default:
            circleRadius = rect.size.width/2.0 - 4.0
            lineWidth = 5.0
        }
        
        let circularLine = UIBezierPath(arcCenter: CGPoint(x: rect.size.width/2.0, y: rect.size.height/2.0), radius: circleRadius, startAngle: 0, endAngle: CGFloat(Double.pi * 2.0), clockwise: true)
        circle.path = circularLine.cgPath
        circle.strokeColor = UIColor.red.cgColor
        circle.fillColor = UIColor.clear.cgColor
        circle.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        circle.lineWidth = lineWidth
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = rect
        gradientLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.colors = gradientColorSet
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        self.layer.addSublayer(gradientLayer)
        gradientLayer.mask = circle
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = 1.0
        animation.repeatCount = kCFNumberPositiveInfinity as! Float
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2.0
        //animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        gradientLayer.add(animation, forKey: "rotationAnim")
        
    }
}



class ActivityLoader {
    
    private var indicatorType : ActivityIndicatorType = .eNativeWhite
    var gradientColorSet : [CGColor] = [UIColor.darkGray.cgColor, UIColor.lightGray.cgColor, UIColor.white.cgColor]// default color
    private var loaderDisplayMessage : NSAttributedString = NSAttributedString(string: "")
    var imageName : String? = nil
    
    private var messageLabelAlignMent : ActivityAlignment = .eCenterAlign
    var indicatorAlignment : ActivityAlignment = .eCenterAlign
    {
        didSet
        {
            if indicatorAlignment == .eTopAlign
            {
                messageLabelAlignMent = .eBottomAlign
            }
            else if indicatorAlignment == .eBottomAlign
            {
                messageLabelAlignMent = .eTopAlign
            }
            else
            {
                messageLabelAlignMent = .eCenterAlign
            }
        }
    }
    
    
    
    var image : UIImage? = nil
    var imageSize : CGSize = CGSize.zero
    
    private let overLayView : UIView = UIView()

    required init(typeOfIndicator : ActivityIndicatorType)
    {
        indicatorType = typeOfIndicator
    }
    
    convenience init(typeOfIndicator : ActivityIndicatorType, displayMessage: String) {
        self.init(typeOfIndicator: typeOfIndicator)
        loaderDisplayMessage = NSAttributedString(string: displayMessage, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16.0), NSAttributedString.Key.foregroundColor : UIColor.white])
        indicatorAlignment = .eTopAlign
    }
    
    func showLoader(displayMessage : NSAttributedString? = nil, overView : UIView?)
    {
        if displayMessage != nil
        {
            loaderDisplayMessage = displayMessage!
        }
        
        if overView == nil
        {
            let screenBounds = UIScreen.main.bounds
            overLayView.frame = screenBounds
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate
              else {
                return
              }
            if let currentWindow = sceneDelegate.window
            {
                currentWindow.addSubview(overLayView)
            }
        }
        else
        {
            overLayView.frame = CGRect(x: 0.0, y: 0.0, width: (overView?.frame.size.width)!, height: (overView?.frame.size.height)!)
            overView?.addSubview(overLayView)
        }
        
        overLayView.backgroundColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 0.3)
        //overLayView.alpha = 0.3
        
        designActivity(over: overLayView)
    }
    
    private func designActivity(over : UIView)
    {
        var activity : UIActivityIndicatorView? = nil
        
        switch indicatorType
        {
        case .eCustomLarge:
            let customActivity = CustomActivity()
            customActivity.gradientColorSet = gradientColorSet
            customActivity.indicatorType = .eCustomLarge
            customActivity.backgroundColor = UIColor.clear
            let bgView = designIndicatorBackGround(onTopofView: over)
            bgView.addSubview(customActivity)
            setConstarints(for: bgView, superView: over, size: CGSize(width: 270.0, height: 140.0))
            over.layoutSubviews()
            setConstarints(for: customActivity, superView: bgView, size: CGSize(width: 40.0, height: 40.0), activityAlignment: indicatorAlignment)
            addMessageLabel(overView: bgView, referneceView: customActivity, alignment: messageLabelAlignMent)
            
        case .eCustomSmall:
            let customActivity = CustomActivity()
            customActivity.gradientColorSet = gradientColorSet
            customActivity.indicatorType = .eCustomSmall
            over.addSubview(customActivity)
            setConstarints(for: customActivity, superView: over, size: CGSize(width: 20.0, height: 20.0))
            customActivity.center = over.center
            customActivity.backgroundColor = UIColor.clear
            
        case .eNativeWhiteLarge:
            activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
             activity?.startAnimating()
             let bgView = designIndicatorBackGround(onTopofView: over)
             setConstarints(for: bgView, superView: over, size: CGSize(width: 270.0, height: 140.0))
             bgView.backgroundColor = UIColor.gray
             bgView.addSubview(activity!)
             over.layoutSubviews()
             //activity?.center = bgView.center
             var activityFrame = activity?.frame
             activityFrame?.origin.x = bgView.frame.size.width/2.0 - (activity?.frame.size.width)!/2.0
             activityFrame?.origin.y = 20.0
             activity?.frame = activityFrame!
             addMessageLabel(overView: bgView, referneceView: activity!, alignment: messageLabelAlignMent)
            
        case .eNativeWhite:
            activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
            over.addSubview(activity!)
            activity?.center = over.center
            activity?.startAnimating()
            
        case .eNativeGray:
            activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
            over.addSubview(activity!)
            activity?.center = over.center
            activity?.startAnimating()
            
        case .eImageIndicator:
            let imgView : UIImageView = UIImageView()
            if let nameForImage = imageName
            {
                imgView.image = UIImage(named: nameForImage)
            }
            let bgView = designIndicatorBackGround(onTopofView: over)
            bgView.addSubview(imgView)
            setConstarints(for: bgView, superView: over, size: CGSize(width: 270.0, height: 140.0))
            over.layoutSubviews()
            setConstarints(for: imgView, superView: bgView, size: CGSize(width: 40.0, height: 40.0), activityAlignment: indicatorAlignment)
            addMessageLabel(overView: bgView, referneceView: imgView, alignment: messageLabelAlignMent)
        }
    }
    
    func setConstarints(for view: UIView, superView : UIView, size:CGSize, activityAlignment : ActivityAlignment = .eCenterAlign)
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: size.width))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: size.height))
        superView.addConstraint(NSLayoutConstraint(item: superView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        var centerAlignpoint : CGFloat = 0.0
        if activityAlignment == .eCenterAlign
        {
            centerAlignpoint = 0.0
        }
        else if (activityAlignment == .eBottomAlign)
        {
            centerAlignpoint = 0.0 - superView.frame.size.height / 4.0
        }
        else
        {
            centerAlignpoint = superView.frame.size.height / 4.0
        }
        
        superView.addConstraint(NSLayoutConstraint(item: superView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: centerAlignpoint))
    }
    
    
    private func designIndicatorBackGround(onTopofView : UIView) -> UIView
    {
        let bgView : UIView = UIView()
        bgView.backgroundColor = UIColor.white
        onTopofView.addSubview(bgView)
        //bgView.center = onTopofView.center
        bgView.layer.cornerRadius = 6.0
        
        return bgView
    }
    
    private func addMessageLabel(overView : UIView, referneceView : UIView, alignment: ActivityAlignment = .eBottomAlign)
    {
        let messageLabel : UILabel = UILabel(/*frame: CGRect(x: 0.0, y: 0.0, width: overView.frame.size.width, height: 40.0)*/)
        overView.addSubview(messageLabel)
        messageLabel.attributedText = loaderDisplayMessage
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.textColor = UIColor.darkGray
        setMessageLabelConstraints(label: messageLabel, referneceView: referneceView, superView: overView, alignment: alignment)
    }
    
    func setMessageLabelConstraints(label : UILabel, referneceView : UIView, superView : UIView, alignment: ActivityAlignment)
    {
        label.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraint(NSLayoutConstraint(item: superView, attribute: .left, relatedBy: .equal, toItem: label, attribute: .left, multiplier: 1.0, constant: 0.0))
        superView.addConstraint(NSLayoutConstraint(item: superView, attribute: .right, relatedBy: .equal, toItem: label, attribute: .right, multiplier: 1.0, constant: 0.0))
        
        
        if alignment == .eCenterAlign
        {
            superView.addConstraint(NSLayoutConstraint(item: superView, attribute: .centerX, relatedBy: .equal, toItem: label, attribute: .centerX, multiplier: 1.0, constant: 0.0))
            superView.addConstraint(NSLayoutConstraint(item: superView, attribute: .centerY, relatedBy: .equal, toItem: label, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        }
        else if (alignment == .eBottomAlign)
        {
            superView.addConstraint(NSLayoutConstraint(item: referneceView, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .top, multiplier: 1.0, constant: 0.0))
            superView.addConstraint(NSLayoutConstraint(item: superView, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        }
        else
        {
            superView.addConstraint(NSLayoutConstraint(item: superView, attribute: .top, relatedBy: .equal, toItem: label, attribute: .top, multiplier: 1.0, constant: 0.0))
            superView.addConstraint(NSLayoutConstraint(item: referneceView, attribute: .top, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        }
    }
    
    
    func removeIndicator()
    {
        overLayView.subviews.forEach({$0.removeFromSuperview()})
        overLayView.removeFromSuperview()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
