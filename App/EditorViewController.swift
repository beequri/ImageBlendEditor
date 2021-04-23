//
//  EditorViewController.swift
//  Example
//
//  Created by beequri on 25.04.20.
//  Copyright © 2020 IGR Software. All rights reserved.
//

import UIKit
import ImageBlendEditor

protocol EditorViewControllerDelegate : class {
    
    /**
     Called on image cropped.
     */
    func photoCropController(_ controller: EditorViewController, didFinishWithCroppedImage croppedImage: UIImage)
    /**
     Called on cropping image canceled
     */
    
    func photoCropControllerDidCancel(_ controller: EditorViewController)
}

class EditorViewController: UIViewController {

    public var models: [ImageBlendModel] = []
    public weak var delegate:EditorViewControllerDelegate?
    
    @IBOutlet weak var photoCropEditorView: UIView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    lazy var imageBlendEditorViewController: ImageBlendEditorViewController = {
        let imageBlendEditorViewController = ImageBlendEditorViewController.instance(delegate: self, models:models)
        imageBlendEditorViewController.delegate = self
        return imageBlendEditorViewController
    }()
    
    class public func instance(models:[ImageBlendModel], delegate: EditorViewControllerDelegate?) -> EditorViewController {
        
        let storyboard = UIStoryboard(name: "Editor", bundle: nil)
        
        guard let editorViewController = storyboard.instantiateInitialViewController() as? EditorViewController else {
            fatalError("Unable to load ImageBlendEditorViewController xib")
        }
        editorViewController.delegate = delegate
        editorViewController.models = models
        
        return editorViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageBlendEditorViewController.view.translatesAutoresizingMaskIntoConstraints = false
        photoCropEditorView.addSubview(imageBlendEditorViewController.view)
        photoCropEditorView.inheritConstraints(subview:imageBlendEditorViewController.view)
        // Do any additional setup after loading the view.
    }
    
    // MARK: Action
    
    @IBAction func didPressAcceptButton(_ sender: Any) {
        imageBlendEditorViewController.cropAndBlend()
    }
    
    private func nextOrientation(image: UIImage) -> UIImage.Orientation {
        switch image.imageOrientation {
        case .right:
            return .down
        case .down:
            return .left
        case .left:
            return .up
        case .up:
            return .right
        default:
            return .up
        }
    }
    
    // MARK: Private
}

extension EditorViewController: ImageBlendEditorViewControllerDelegate {
    func imageBlendControllerDidChangeOrientation(_ controller: ImageBlendEditorViewController) {
        //
    }
    
    func imageBlendController(_ controller: ImageBlendEditorViewController, didFinishWithCroppedImage croppedImage: UIImage) {
        delegate?.photoCropController(self, didFinishWithCroppedImage: croppedImage)
    }
    
    func imageBlendControllerDidCancel(_ controller: ImageBlendEditorViewController) {
        delegate?.photoCropControllerDidCancel(self)
    }
}

extension UIView {
    
    func inheritConstraints(subview: UIView) {
        
        self.addConstraint(NSLayoutConstraint.init(item: subview, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))

        self.addConstraint(NSLayoutConstraint.init(item: subview, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint.init(item: subview, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint.init(item: subview, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        
    }
    
}
