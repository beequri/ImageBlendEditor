import CoreGraphics

open class RadianAngle : NSObject {
    
    static public func toRadians(_ degrees: CGFloat) -> CGFloat {
        return (degrees * CGFloat.pi / 180.0)
    }
    
    static public func toDegrees(_ radians: CGFloat) -> CGFloat {
        return (radians * 180.0 / CGFloat.pi)
    }
}
