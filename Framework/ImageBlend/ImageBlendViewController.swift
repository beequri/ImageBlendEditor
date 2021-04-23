import UIKit


public protocol ImageBlendViewControllerDelegate : class {
    
    /**
     Called on image cropped.
     */
    func photoTweaksController(_ controller: ImageBlendViewController, didFinishWithCroppedImage croppedImage: UIImage)
    /**
     Called on cropping image canceled
     */
    
    func photoTweaksControllerDidCancel(_ controller: ImageBlendViewController)
}

open class ImageBlendViewController: UIViewController {
    
    //MARK: - Public VARs
    
    /*
     Image to process.
     */
    public var image: UIImage!
    
    /*
     Overlay image needed to define cropping bounds.
     */
    public var overlayImage: UIImage!
    
    /*
     The optional photo tweaks controller delegate.
     */
    public weak var delegate: ImageBlendViewControllerDelegate?
    
    //MARK: - Protected VARs
    
    /*
     Flag indicating whether the image cropped will be saved to photo library automatically. Defaults to YES.
     */
    internal var isAutoSaveToLibray: Bool = false
    
    //MARK: - Private VARs
    
    public lazy var photoView: PhotoCropView! = { [unowned self] by in
        
        let photoView = PhotoCropView(frame: self.view.bounds,
                                      image: self.image,
                                      overlayImage: self.overlayImage,
                                      customizationDelegate: self)
        photoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(photoView)
        
        return photoView
        }(())
    
    // MARK: - Life Cicle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        view.clipsToBounds = true
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupThemes()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.photoView.applyDeviceRotation()
        })
    }
    
    func setupSubviews() {
        self.view.sendSubviewToBack(photoView)
    }
    
    open func setupThemes() {
        PhotoCropView.appearance().backgroundColor      = UIColor.photoTweakCanvasBackground()
        PhotoContentView.appearance().backgroundColor   = UIColor.clear
        CropView.appearance().backgroundColor           = UIColor.clear
        CropGridLine.appearance().backgroundColor       = UIColor.gridLine()
        CropLine.appearance().backgroundColor           = UIColor.cropLine()
        CropCornerView.appearance().backgroundColor     = UIColor.clear
        CropCornerLine.appearance().backgroundColor     = UIColor.cropLine()
        CropMaskView.appearance().backgroundColor       = UIColor.mask()
    }
    
    // MARK: - Public
    
    public func recreate(image: UIImage, overlayImage: UIImage) {
        self.photoView.removeFromSuperview()
        self.image = image
        self.overlayImage = overlayImage
        let photoView = PhotoCropView(frame: self.view.bounds,
                                      image: self.image,
                                      overlayImage: self.overlayImage,
                                      customizationDelegate: self)
        photoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(photoView)
        self.photoView = photoView
    }
    
    public func resetView() {
        self.photoView.resetView()
        self.stopChangeAngle()
    }
    
    public func dismissAction() {
        self.delegate?.photoTweaksControllerDidCancel(self)
    }
    
    public func cropAction() {
        var transform = CGAffineTransform.identity
        // translate
        let translation: CGPoint = self.photoView.photoTranslation
        transform = transform.translatedBy(x: translation.x, y: translation.y)
        // rotate
        transform = transform.rotated(by: self.photoView.radians)
        // scale
        
        let t: CGAffineTransform = self.photoView.photoContentView.transform
        let xScale: CGFloat = sqrt(t.a * t.a + t.c * t.c)
        let yScale: CGFloat = sqrt(t.b * t.b + t.d * t.d)
        transform = transform.scaledBy(x: xScale, y: yScale)
        
        if let fixedImage = self.image.cgImageWithFixedOrientation() {
            let imageRef = fixedImage.transformedImage(transform,
                                                       zoomScale: self.photoView.scrollView.zoomScale,
                                                       sourceSize: self.image.size,
                                                       cropSize: self.photoView.cropView.frame.size,
                                                       imageViewSize: self.photoView.photoContentView.bounds.size)
            
            let image = UIImage(cgImage: imageRef)
            
            self.delegate?.photoTweaksController(self, didFinishWithCroppedImage: image)
        }
    }
    
    //MARK: - Customization
    
    open func customBorderColor() -> UIColor {
        return UIColor.white
    }
    
    open func customBorderWidth() -> CGFloat {
        return 1
    }
    
    open func customCornerBorderWidth() -> CGFloat {
        return kCropViewCornerWidth
    }
    
    open func customCornerBorderLength() -> CGFloat {
        return kCropViewCornerLength
    }
    
    open func customCropLinesCount() -> Int {
        return kCropLinesCount
    }
    
    open func customGridLinesCount() -> Int {
        return kGridLinesCount
    }
    
    open func customIsHighlightMask() -> Bool {
        return false
    }
    
    open func customHighlightMaskAlphaValue() -> CGFloat {
        return 1
    }
    
    open func customCanvasInsets() -> UIEdgeInsets {
        
        let hInset = view.bounds.width * 0.05
        let vInset = view.bounds.height * 0.05
        
        return UIEdgeInsets(top: vInset, left: hInset, bottom: 0, right: 0)
    }
}
