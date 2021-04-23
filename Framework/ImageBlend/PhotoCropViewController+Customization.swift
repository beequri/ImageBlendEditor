import UIKit

//MARK: - Delegats funcs

extension ImageBlendViewController : PhotoCropViewCustomizationDelegate {
    public func borderColor() -> UIColor {
        return self.customBorderColor()
    }
    
    public func borderWidth() -> CGFloat {
        return self.customBorderWidth()
    }
    
    public func cornerBorderWidth() -> CGFloat {
        return self.customCornerBorderWidth()
    }
    
    public func cornerBorderLength() -> CGFloat {
        return self.customCornerBorderLength()
    }
    
    public func cropLinesCount() -> Int {
        return self.customCropLinesCount()
    }
    
    public func gridLinesCount() -> Int {
        return self.customGridLinesCount()
    }
    
    public func isHighlightMask() -> Bool {
        return self.customIsHighlightMask()
    }
    
    public func highlightMaskAlphaValue() -> CGFloat {
        return self.customHighlightMaskAlphaValue()
    }
    
    public func canvasInsets() -> UIEdgeInsets {
        return self.customCanvasInsets()
    }
}
