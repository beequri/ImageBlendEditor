//
//  ImageBlend.swift
//  ImageBlendEditor
//
//  Created by beequri on 10.03.21.
//  Copyright © 2021 beequri. All rights reserved.
//

import UIKit

@objc public class ImageBlend: NSObject {
    
    @objc public enum Action:Int {
        case filter
        case contrast
        case brightness
    }
    
    private var availableFilters: [String] = [
        "No Filter",
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectMono",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CILinearToSRGBToneCurve",
        "CISRGBToneCurveToLinear"
    ]
    
    private var action: Action
    
    @objc public var filter: Filter = .process
    @objc public var brightness: CGFloat = 0
    @objc public var contrast: CGFloat = 0
    @objc public var imageAlpha = 1.0
    @objc public var overlayImageAlpha = 1.0
    
    public weak var model:ImageBlendModel?
    
    @objc public init(action: Action) {
        self.action = action
    }
    
    public func apply() {
        switch action {
        case .filter:
            let img = model?.workingImage?.createFilteredImage(filterName: availableFilters[filter.rawValue])
            model?.workingImage = img
            return 
        case .contrast:
            let img = model?.workingImage?.imageContrast(value: contrast)
            model?.workingImage = img
            return
        case .brightness:
            let img = model?.workingImage?.imageBrightness(value: brightness)
            model?.workingImage = img
            return
        }
    }
}

extension UIImage {
    func createFilteredImage(filterName: String) -> UIImage {
        let sourceImage = CIImage(image: self)
        let filter = CIFilter(name: filterName)
        let context = CIContext(options: nil)
        
        filter?.setDefaults()
        filter?.setValue(sourceImage, forKey: kCIInputImageKey)

        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let outputCGImage = context.createCGImage(filteredImageData, from: filteredImageData.extent)

        let originalOrientation = self.imageOrientation
        let originalScale = self.scale
        let filteredImage = UIImage.init(cgImage: outputCGImage!, scale: originalScale, orientation: originalOrientation)

        return filteredImage
    }
    
    func imageContrast(value : CGFloat) -> UIImage? {
        let aUIImage = self
        let aCGImage = aUIImage.cgImage
        
        let aCIImage = CIImage(cgImage: aCGImage!)
        let context = CIContext(options: nil)
        guard let contrastFilter = CIFilter(name: "CIColorControls") else {
            print("unable to obtain contrastFilter")
            return nil
        }
        contrastFilter.setValue(aCIImage, forKey: "inputImage")
        contrastFilter.setValue(value, forKey: "inputContrast")
        let outputImage = contrastFilter.outputImage!
        let cgimg = context.createCGImage(outputImage, from: outputImage.extent)
        return UIImage(cgImage: cgimg!)
        
    }
    
    func imageBrightness(value : CGFloat) -> UIImage? {
        let aUIImage = self
        let aCGImage = aUIImage.cgImage
        
        let aCIImage = CIImage(cgImage: aCGImage!)
        let context = CIContext(options: nil)
        guard let brightnessFilter = CIFilter(name: "CIColorControls") else {
            print("unable to obtain brightnessFilter")
            return nil
        }
        brightnessFilter.setValue(aCIImage, forKey: "inputImage")
        brightnessFilter.setValue(value, forKey: "inputBrightness")
        let outputImage = brightnessFilter.outputImage!
        let cgimg = context.createCGImage(outputImage, from: outputImage.extent)
        return UIImage(cgImage: cgimg!)
        
    }
}
