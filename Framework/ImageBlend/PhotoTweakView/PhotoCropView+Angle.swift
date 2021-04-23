import UIKit

extension PhotoCropView {
    public func changeAngle(radians: CGFloat) {
        // update masks
        self.highlightMask(true, animate: false)
        
        // update grids
        self.cropView.updateGridLines(animate: false)
        
        // rotate scroll view
        self.radians = radians
        self.scrollView.transform = CGAffineTransform(rotationAngle: self.radians)
        
        self.updatePosition()
    }
    
    public func stopChangeAngle() {
        self.cropView.dismissGridLines()
        self.highlightMask(false, animate: false)
    }
}
