import UIKit

extension ImageBlendViewController {
    public func changeAngle(radians: CGFloat) {
        self.photoView.changeAngle(radians: radians)
    }
    
    public func stopChangeAngle() {
        self.photoView.stopChangeAngle()
    }
}
