import UIKit

public class HorizontalDial: BaseCroppingDial {
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        for index in 0...markCount {
            var relativePosition = (CGFloat((frame.width) / CGFloat(markCount)) * CGFloat(index) + CGFloat(slidePosition) - frame.width/2).truncatingRemainder(dividingBy: frame.width)
            if relativePosition < 0 {
                relativePosition += frame.width
            }
            
            let screenWidth = self.bounds.width / 2.0
            let alpha = 1.0 - (abs(relativePosition-screenWidth) / screenWidth)
            ctx.setFillColor(self.markColor.withAlphaComponent(alpha).cgColor)
            
            let x = relativePosition - markWidth/2
            let width = markWidth
            var y: CGFloat = 0
            var height: CGFloat = 0
            
            if verticalAlign.contains("top") {
                y = 0
                height = frame.height - CGFloat(padding*2)
            } else if verticalAlign.contains("bottom") {
                y += CGFloat(padding*2)
                height = frame.height - y
            } else {
                y = CGFloat(padding)
                height = frame.height - CGFloat(padding*2)
            }
            let rect = CGRect(x: x, y: y, width: width, height: height)
            
            let path = UIBezierPath(roundedRect: rect, cornerRadius: markRadius)
            ctx.addPath(path.cgPath)
            ctx.fillPath()
        }
        
        var centerMarkPositionY: CGFloat = 0
        let centerMarkHeight: CGFloat = frame.height*centerMarkHeightRatio
        if verticalAlign.contains("top") {
            centerMarkPositionY = 0
        } else if verticalAlign.contains("bottom") {
            centerMarkPositionY = frame.height - centerMarkHeight
        } else {
            centerMarkPositionY = frame.height/2-centerMarkHeight/2
        }
        let path = UIBezierPath(roundedRect:
            CGRect(x: frame.width/2 - centerMarkWidth/2, y: centerMarkPositionY, width: centerMarkWidth, height: centerMarkHeight), cornerRadius: centerMarkRadius)
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
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = deltaLocation / (Double(frame.width) / Double(markCount)) * tick
        
        previousLocation = location
        
        self.value -= deltaValue
        
        return true
    }
}
