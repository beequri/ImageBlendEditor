//
//  ImageBlendModel.swift
//  ImageBlendEditor
//
//  Created by beequri on 05.03.21.
//  Copyright © 2021 beequri. All rights reserved.
//

import UIKit

@objc public enum Filter:Int {
    case none
    case chrome
    case fade
    case instant
    case mono
    case noir
    case process
    case tonal
    case transfer
    case curve
    case linear
}

@objc public class ImageBlendModel:NSObject {
    
    public let layers: [UIImage] // Top layer is represented by first image
    public var workingLayers: [UIImage]? // Working copy of layers
    public var thumb: UIImage
    public var name: String
    
    public var workingImage: UIImage?
    public var readyImage: UIImage?
    
    // Default values
    @objc public var blends: [ImageBlend] = []
    @objc public var origin: CGPoint = .zero
    @objc public var size: CGSize = .zero
    
    lazy fileprivate var operations:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Filter queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    @objc public init(layers: [UIImage], thumb: UIImage, name:String) {
        self.layers = layers
        self.thumb = thumb
        self.name = name
    }
    
    @objc public func prepare(select: @escaping ([UIImage])->(UIImage), completion: @escaping ([UIImage])->()) {
        guard layers.count > 1, let overlay = layers.first else {
            print("No layers provided. At least 2 images needs to be provided to create blend action")
            return
        }
        
        if size == .zero {
            size = overlay.size
        }
        
        if let workingLayers = workingLayers {
            completion(workingLayers)
            return
        }
        
        var indexOfLayer:Int?
        
        for blend in blends {
            
            if workingImage == nil {
                workingImage = select(layers)
                indexOfLayer = layers.firstIndex(of: workingImage!)
            }
            
            let blendOperation = ImageBlendOperation(blend: blend, model: self)
            operations.addOperation(blendOperation)
            
            blendOperation.completionBlock = {
                if blendOperation.isCancelled {
                    completion(self.layers)
                    return
                }
                if self.operations.operationCount == 0 {
                    guard let img = self.workingImage, let index = indexOfLayer else {
                        assertionFailure("There was an error during filter operation")
                        return
                    }
                    self.readyImage = img
                    self.workingLayers = self.layers.map {$0}
                    
                    // replace updated image at selected index
                    self.workingLayers![index] = img
                    completion(self.workingLayers!)
                }
            }
        }
    }
    
    public func suspend() {
        operations.isSuspended = true
    }
}
