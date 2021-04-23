import UIKit

extension PhotoCropView {
    
    internal func setupMasks()
    {
        topMask = CropMaskView()
        addSubview(self.topMask)
        
        leftMask = CropMaskView()
        addSubview(self.leftMask)
        
        rightMask = CropMaskView()
        addSubview(self.rightMask)
        
        bottomMask = CropMaskView()
        addSubview(self.bottomMask)
        
        setupMaskLayoutConstraints()
    }
    
    internal func updateMasks() {
        self.layoutIfNeeded()
    }
    
    internal func highlightMask(_ highlight:Bool, animate: Bool) {
        if (self.isHighlightMask()) {
            let newAlphaValue: CGFloat = highlight ? self.highlightMaskAlphaValue() : 1.0
            
            let animationBlock: (() -> Void)? = {
                self.topMask.alpha = newAlphaValue
                self.leftMask.alpha = newAlphaValue
                self.bottomMask.alpha = newAlphaValue
                self.rightMask.alpha = newAlphaValue
            }
            
            if animate {
                UIView.animate(withDuration: kAnimationDuration, animations: animationBlock!)
            }
            else {
                animationBlock!()
            }
        }
    }
}
