//
//  BlendManager.swift
//  Example
//
//  Created by beequri on 12.03.21.
//  Copyright © 2021 IGR Software. All rights reserved.
//

import UIKit
import ImageBlendEditor

class BlendManager {
    
    let image:UIImage
    
    init(image:UIImage) {
        self.image = image
    }
    
    class func models(image:UIImage) -> [ImageBlendModel] {
        
        let manager = BlendManager(image: image)
        let model1 = manager.basicOverlay()
        let model2 = manager.retroOverlay()
        
        guard let m1 = model1, let m2 = model2 else {
            return []
        }
        
        return [m1, m2]
    }
    
    private func basicOverlay() -> ImageBlendModel? {
        guard let overlayImage = UIImage(named: "filter_2"), let thumb = UIImage(named: "paper_thumb_2") else {
            return nil
        }
        let layers = [overlayImage, image]
        let model = ImageBlendModel(layers: layers, thumb: thumb, name: "basic overlay")
        
        let blend1 = ImageBlend(action: .filter)
        blend1.filter = .chrome
        
        let blend2 = ImageBlend(action: .contrast)
        blend2.contrast = 2.0
        
        let blend3 = ImageBlend(action: .brightness)
        blend3.brightness = 0
        
        model.blends = [blend1, blend2, blend3]
        
        return model
    }
    
    private func retroOverlay() -> ImageBlendModel? {
        guard let overlayImage = UIImage(named: "filter_1"), let thumb = UIImage(named: "paper_thumb_2") else {
            return nil
        }
        let layers = [overlayImage, image]
        let model = ImageBlendModel(layers: layers, thumb: thumb, name: "retro overlay")
        
        let blend1 = ImageBlend(action: .filter)
        blend1.filter = .chrome
        
        let blend2 = ImageBlend(action: .contrast)
        blend2.contrast = 1.0
        
        model.blends = [blend1, blend2]
        
        return model
    }
    
}
