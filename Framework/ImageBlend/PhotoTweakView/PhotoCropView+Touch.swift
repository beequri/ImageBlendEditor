import UIKit

extension PhotoCropView {
    
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.cropView.frame.insetBy(dx: -kCropViewHotArea,
                                       dy: -kCropViewHotArea).contains(point) &&
            !self.cropView.frame.insetBy(dx: kCropViewHotArea,
                                         dy: kCropViewHotArea).contains(point) {
            
            return self.cropView
        }
        
        return self.scrollView
    }
}
