//
//  PhotoCropImageViewController.swift
//  PhotoCrop
//
//  Created by beequri on 10.04.20.
//  Copyright © 2020 beequri. All rights reserved.
//

import UIKit

class PhotoCropImageViewController: ImageBlendViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open func customCanvasInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: UIDevice.current.orientation.isLandscape ? 40.0 : 100.0,
                            left: 0,
                            bottom: 0,
                            right: 0)
    }
}
