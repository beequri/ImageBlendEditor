import UIKit

public class VerticalDial: BaseCroppingDial {
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        for index in 0...markCount {
            var relativePosition = (CGFloat((frame.height) / CGFloat(markCount)) * CGFloat(index) + CGFloat(slidePosition) - frame.height/2).truncatingRemainder(dividingBy: frame.height)
            if relativePosition < 0 {
                relativePosition += frame.height
            }
            
            let screenWidth = self.bounds.height / 2.0
            let alpha = 1.0 - (abs(relativePosition-screenWidth) / screenWidth)
            ctx.setFillColor(self.markColor.withAlphaComponent(alpha).cgColor)
            
            let y = relativePosition - markWidth/2
            let height = markWidth
            var x: CGFloat = 0
            var width: CGFloat = 0
            
            if verticalAlign.contains("top") {
                x = 0
                width = frame.width - CGFloat(padding*2)
            } else if verticalAlign.contains("bottom") {
                x += CGFloat(padding*2)
                width = frame.width - y
            } else {
                x = CGFloat(padding)
                width = frame.width - CGFloat(padding*2)
            }
            let rect = CGRect(x: x, y: y, width: width, height: height)
            
            let path = UIBezierPath(roundedRect: rect, cornerRadius: markRadius)
            ctx.addPath(path.cgPath)
            ctx.fillPath()
        }
        
        var centerMarkPositionX: CGFloat = 0
        let centerMark: CGFloat = frame.width * centerMarkHeightRatio
        if verticalAlign.contains("top") {
            centerMarkPositionX = 0
        } else if verticalAlign.contains("bottom") {
            centerMarkPositionX = frame.width - centerMark
        } else {
            centerMarkPositionX = frame.width/2 - centerMark/2
        }
        let path = UIBezierPath(roundedRect:
            CGRect(x: centerMarkPositionX, y: frame.height/2 - centerMarkWidth/2, width: centerMark, height: centerMarkWidth), cornerRadius: centerMarkRadius)
        ctx.addPath(path.cgPath)
        
        ctx.setFillColor(centerMarkColor.cgColor)
        ctx.addPath(path.cgPath)
        ctx.fillPath()
    }
    
    override public func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard tick != 0 && lock != true else {
            return false
        }
        
        let location = touch.location(in: self)
        let deltaLocation = Double(location.y - previousLocation.y)
        let deltaValue = deltaLocation / (Double(frame.height) / Double(markCount)) * tick
        
        previousLocation = location
        
        self.value -= deltaValue
        
        return true
    }
}
