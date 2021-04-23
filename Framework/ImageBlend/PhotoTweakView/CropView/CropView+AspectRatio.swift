import UIKit

extension CropView {
    
    public func resetAspectRect() {
        self.aspectRatioWidth = self.frame.size.width
        self.aspectRatioHeight = self.frame.size.height
    }
    
    public func setCropAspectRect(aspect: String, maxSize: CGSize) {
        let elements = aspect.components(separatedBy: ":")
        
        let width = CGFloat(Float(elements.first!)!)
        let height = CGFloat(Float(elements.last!)!)
        
        self.aspectRatioWidth = max(width, height)
        self.aspectRatioHeight = min(width, height)
        
        var size = maxSize
        let mW = size.width / self.aspectRatioWidth
        let mH = size.height / self.aspectRatioHeight
        
        if (mH < mW) {
            size.width = size.height / self.aspectRatioHeight * self.aspectRatioWidth
        }
        else if(mW < mH) {
            size.height = size.width / self.aspectRatioWidth * self.aspectRatioHeight
        }
        
        let x = (self.frame.size.width - size.width).half
        let y = (self.frame.size.height - size.height).half
        
        self.frame = CGRect(x:x, y:y, width: size.width, height: size.height)
    }
    
    public func lockAspectRatio(_ lock: Bool) {
        resetAspectRect()
        self.isAspectRatioLocked = lock
    }
}
