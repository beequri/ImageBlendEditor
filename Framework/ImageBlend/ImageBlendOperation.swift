//
//  ImageBlendOperation.swift
//  ImageBlendEditor
//
//  Created by beequri on 10.03.21.
//  Copyright © 2021 beequri. All rights reserved.
//

import UIKit

class ImageBlendOperation: Operation {
    
    let blend:ImageBlend
    
    init(blend:ImageBlend, model:ImageBlendModel) {
        self.blend = blend
        self.blend.model = model
        super.init()
    }

    override func main () {
        if isCancelled {
            return
        }
        blend.apply()
        
    }
    
}
