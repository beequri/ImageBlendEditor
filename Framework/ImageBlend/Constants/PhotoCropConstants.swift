import UIKit

enum CropCornerType : Int {
    case upperLeft
    case upperRight
    case lowerRight
    case lowerLeft
}

let kCropLinesCount: Int = 0
let kGridLinesCount: Int = 0

let kCropViewHotArea: CGFloat           = 40.0

let kMaximumCanvasWidthRatio: CGFloat   = 0.9
let kMaximumCanvasHeightRatio: CGFloat  = 0.8
let kCanvasHeaderHeigth: CGFloat        = 100.0

let kCropViewLineWidth: CGFloat         = 2.0

let kCropViewCornerWidth: CGFloat       = 2
let kCropViewCornerLength: CGFloat      = 20

let kAnimationDuration: TimeInterval    = 0.25
