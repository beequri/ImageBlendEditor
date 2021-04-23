//
//  PhotoCropView.swift
//  PhotoCrops
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

public class PhotoCropView: UIView {
    
    //MARK: - Public VARs
    
    public weak var customizationDelegate: PhotoCropViewCustomizationDelegate?
    
    private(set) lazy var cropView: CropView! = { [unowned self] by in
        
        let cropView = CropView(frame: self.scrollView.frame,
                                   cornerBorderWidth:self.cornerBorderWidth(),
                                   cornerBorderLength:self.cornerBorderLength(),
                                   cropLinesCount:self.cropLinesCount(),
                                   gridLinesCount:self.gridLinesCount())
        cropView.center = self.scrollView.center
        cropView.layer.borderColor = self.borderColor().cgColor
        cropView.layer.borderWidth = self.borderWidth()
        self.addSubview(cropView)
        
        return cropView
        }(())
    
    private var fillBounds: CGRect {
        // scale the image
        let canvasSize = maxBounds().size

        let scaleX: CGFloat = self.image.size.width / canvasSize.width
        let scaleY: CGFloat = self.image.size.height / canvasSize.height
        let scale: CGFloat = min(scaleX, scaleY)
        
        let bounds = CGRect(x: CGFloat.zero,
                            y: CGFloat.zero,
                            width: (self.image.size.width / scale),
                            height: (self.image.size.height / scale))
            
        return bounds
    }
    
    public private(set) lazy var photoContentView: PhotoContentView! = { [unowned self] by in
        
        let photoContentView = PhotoContentView(frame: fillBounds)
        photoContentView.isUserInteractionEnabled = true
        self.scrollView.addSubview(photoContentView)
        
        return photoContentView
        }(())
    
    public var photoTranslation: CGPoint {
        get {
            let rect: CGRect = self.photoContentView.convert(self.photoContentView.bounds,
                                                             to: self)
            let point = CGPoint(x: (rect.origin.x + rect.size.width.half),
                                y: (rect.origin.y + rect.size.height.half))
            let zeroPoint = self.centerPoint
            
            return CGPoint(x: (point.x - zeroPoint.x), y: (point.y - zeroPoint.y))
        }
    }
    
    public var maximumZoomScale: CGFloat {
        set {
            self.scrollView.maximumZoomScale = newValue
        }
        get {
            return self.scrollView.maximumZoomScale
        }
    }
    
    public var minimumZoomScale: CGFloat {
        set {
            self.scrollView.minimumZoomScale = newValue
        }
        get {
            return self.scrollView.minimumZoomScale
        }
    }
    
    //MARK: - Private VARs
    
    internal var radians: CGFloat       = CGFloat.zero
    fileprivate var photoContentOffset  = CGPoint.zero
    
    internal lazy var scrollView: PhotoScrollView! = { [unowned self] by in
        
        let maxBounds = self.maxBounds()
        self.originalSize = maxBounds.size
        
        let scrollView = PhotoScrollView(frame: maxBounds, contentSize: fillBounds.size)
        scrollView.center = self.centerPoint
        scrollView.delegate = self
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(scrollView)
        
        return scrollView
    }(())
    
    internal lazy var overlayImageView: UIImageView! = { [unowned self] by in
        
        let maxBounds = self.maxBounds()
        self.originalSize = maxBounds.size
        
        let imageView = UIImageView(frame: maxBounds)
        imageView.center = self.centerPoint
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(imageView)
        
        return imageView
    }(())
    
    internal weak var image: UIImage!
    internal weak var overlayImage: UIImage!
    internal var originalSize = CGSize.zero
    
    internal var manualZoomed = false
    internal var manualMove   = false
    
    // masks
    internal var topMask:    CropMaskView!
    internal var leftMask:   CropMaskView!
    internal var bottomMask: CropMaskView!
    internal var rightMask:  CropMaskView!
    
    // constants
    fileprivate var maximumCanvasSize: CGSize!
    fileprivate var originalPoint: CGPoint!
    internal var centerPoint: CGPoint = .zero
    
    // MARK: - Life Cicle
    
    init(frame: CGRect,
         image: UIImage,
         overlayImage: UIImage,
         customizationDelegate: PhotoCropViewCustomizationDelegate!) {
        super.init(frame: frame)
        
        self.image = image
        self.overlayImage = overlayImage
        
        self.customizationDelegate = customizationDelegate
        
        setupScrollView()
        setupCropView()
        setupMasks()
        
        self.originalPoint = self.convert(self.scrollView.center, to: self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if !manualMove {
            originalSize = self.maxBounds().size
            scrollView.center = self.centerPoint
            overlayImageView.image = overlayImage
            
            cropView.center = self.scrollView.center
            scrollView.checkContentOffset()
        }
    }
    
    //MARK: - Public FUNCs
    
    public func resetView() {
        UIView.animate(withDuration: kAnimationDuration, animations: {() -> Void in
            self.radians = CGFloat.zero
            self.scrollView.transform = CGAffineTransform.identity
            self.scrollView.center = self.centerPoint
            self.scrollView.bounds = CGRect(x: CGFloat.zero,
                                            y: CGFloat.zero,
                                            width: self.originalSize.width,
                                            height: self.originalSize.height)
            self.scrollView.minimumZoomScale = 1.0
            self.scrollView.setZoomScale(1.0, animated: false)
            
            self.cropView.frame = self.scrollView.frame
            self.cropView.center = self.scrollView.center
        })
    }
    
    public func applyDeviceRotation() {
        self.resetView()
        
        self.scrollView.center = self.centerPoint
        self.scrollView.bounds = CGRect(x: CGFloat.zero,
                                        y: CGFloat.zero,
                                        width: self.originalSize.width,
                                        height: self.originalSize.height)
        
        self.cropView.frame = self.scrollView.frame
        self.cropView.center = self.scrollView.center
        
        // Update 'photoContent' frame and set the image.
        self.scrollView.photoContentView.frame = .init(x: .zero, y: .zero, width: self.cropView.frame.width, height: self.cropView.frame.height)
        self.scrollView.photoContentView.image = self.image
        
        updatePosition()
    }
    
    public func scale() -> CGFloat {
        let insets = canvasInsets()
        self.maximumCanvasSize = frame.inset(by: insets).size
        
        let cropSize = self.cropView.bounds.size
        var scale: CGFloat
        
        if cropSize.width > cropSize.height {
            let imgScale = self.image.size.height / self.image.size.width
            let canvScale = self.maximumCanvasSize.width / self.maximumCanvasSize.height
            if imgScale > canvScale {
                scale = self.image.size.width / self.image.size.height
            } else {
                scale = self.maximumCanvasSize.height / self.cropView.bounds.size.width
            }
        } else {
            let imgScale = self.image.size.width / self.image.size.height
            let canvScale = self.maximumCanvasSize.height / self.maximumCanvasSize.width
            if imgScale > canvScale {
                scale = self.image.size.height / self.image.size.width
            } else {
                scale = self.maximumCanvasSize.width / self.cropView.bounds.size.height
            }
        }
        
        return scale
        
    }
    
    //MARK: - Private FUNCs
    
    fileprivate func maxBounds() -> CGRect {
        // scale the image
        let insets = canvasInsets()
        self.maximumCanvasSize = frame.inset(by: insets).size
        self.centerPoint = CGPoint(x: maximumCanvasSize.width.half + (insets.left / 2), y: maximumCanvasSize.height.half + (insets.top / 2))

        let scaleX: CGFloat = self.overlayImage.size.width / self.maximumCanvasSize.width
        let scaleY: CGFloat = self.overlayImage.size.height / self.maximumCanvasSize.height
        let scale: CGFloat = max(scaleX, scaleY)
        
        let bounds = CGRect(x: CGFloat.zero,
                            y: CGFloat.zero,
                            width: (self.overlayImage.size.width / scale),
                            height: (self.overlayImage.size.height / scale))
        
        return bounds
    }
    
    internal func updatePosition() {
        return
        // position scroll view
//        let width: CGFloat = abs(cos(self.radians)) * self.cropView.frame.size.width + abs(sin(self.radians)) * self.cropView.frame.size.height
//        let height: CGFloat = abs(sin(self.radians)) * self.cropView.frame.size.width + abs(cos(self.radians)) * self.cropView.frame.size.height
//        let center: CGPoint = self.scrollView.center
//        let contentOffset: CGPoint = self.scrollView.contentOffset
//        let contentOffsetCenter = CGPoint(x: (contentOffset.x + self.scrollView.bounds.size.width.half),
//                                          y: (contentOffset.y + self.scrollView.bounds.size.height.half))
//        self.scrollView.bounds = CGRect(x: CGFloat.zero, y: CGFloat.zero, width: width, height: height)
//        let newContentOffset = CGPoint(x: (contentOffsetCenter.x - self.scrollView.bounds.size.width.half),
//                                       y: (contentOffsetCenter.y - self.scrollView.bounds.size.height.half))
//        self.scrollView.contentOffset = newContentOffset
//        self.scrollView.center = center
//
//        // scale scroll view
//        let shouldScale: Bool = self.scrollView.contentSize.width / self.scrollView.bounds.size.width <= 1.0 ||
//            self.scrollView.contentSize.height / self.scrollView.bounds.size.height <= 1.0
//        if !self.manualZoomed || shouldScale {
//            let zoom = self.scrollView.zoomScaleToBound()
//            self.scrollView.setZoomScale(zoom, animated: false)
//            self.scrollView.minimumZoomScale = zoom
//            self.manualZoomed = false
//        }
//
//        self.scrollView.checkContentOffset()
    }
}
