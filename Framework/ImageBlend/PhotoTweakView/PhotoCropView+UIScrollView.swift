import UIKit

extension PhotoCropView {
    
    internal func setupScrollView() {
        self.scrollView.updateDelegate = self
        self.photoContentView.image = image
        self.scrollView.photoContentView = self.photoContentView
    }
}

extension PhotoCropView : UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoContentView
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.cropView.updateCropLines(animate: true)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.manualZoomed = true
        self.cropView.dismissCropLines()
    }
}

extension PhotoCropView : PhotoScrollViewDelegate {
    public func scrollViewDidStartUpdateScrollContentOffset(_ scrollView: PhotoScrollView) {
        self.highlightMask(true, animate: true)
    }
    
    public func scrollViewDidStopScrollUpdateContentOffset(_ scrollView: PhotoScrollView) {
        self.updateMasks()
        self.highlightMask(false, animate: true)
    }
}
