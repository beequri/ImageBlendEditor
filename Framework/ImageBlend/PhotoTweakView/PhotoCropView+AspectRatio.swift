import UIKit

extension PhotoCropView {
    public func resetAspectRect() {
        self.cropView.frame = CGRect(x: CGFloat.zero,
                                     y: CGFloat.zero,
                                     width: self.originalSize.width,
                                     height: self.originalSize.height)
        self.cropView.center = self.scrollView.center
        self.cropView.resetAspectRect()
        
        self.cropViewDidStopCrop(self.cropView)
    }
    
    public func setCropAspectRect(aspect: String) {
        self.cropView.setCropAspectRect(aspect: aspect, maxSize:self.originalSize)
        self.cropView.center = self.scrollView.center
        
        self.cropViewDidStopCrop(self.cropView)
    }
    
    public func lockAspectRatio(_ lock: Bool) {
        self.cropView.lockAspectRatio(lock)
    }
}
