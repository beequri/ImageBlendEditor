import UIKit
import ImageBlendEditor

class ViewController: UIViewController {

    @IBOutlet weak fileprivate var imageView: UIImageView?
    
    fileprivate var image: UIImage!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        let editItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                       target: self,
                                       action: #selector(openEdit))
        
        let libraryItem = UIBarButtonItem(barButtonSystemItem: .camera,
                                          target: self,
                                          action: #selector(openLibrary))
        
        self.navigationItem.leftBarButtonItem = libraryItem
        self.navigationItem.rightBarButtonItem = editItem
        
        if (self.image == nil) {
            openLibrary()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Funcs
    
    @objc func openLibrary() {
        let pickerView = UIImagePickerController.init()
        pickerView.delegate = self
        pickerView.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(pickerView, animated: true, completion: nil)
    }
    
    @objc func openEdit() {
        self.edit(image: self.image)
    }
    
    func edit(image: UIImage) {
        let models = BlendManager.models(image: image)
        let editorViewController = EditorViewController.instance(models: models, delegate: self)
        addChild(editorViewController)
        view.addSubview(editorViewController.view)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        self.image = image
        
        picker.dismiss(animated: true) {
            self.edit(image: image)
        }
    }
}

extension ViewController: EditorViewControllerDelegate {
    func photoCropController(_ controller: EditorViewController, didFinishWithCroppedImage croppedImage: UIImage) {
        self.imageView?.image = croppedImage
        guard let editorViewController = children.first as? EditorViewController else {
            fatalError("Unable to load EditorViewController from xib")
        }
        editorViewController.view.removeFromSuperview()
        editorViewController.removeFromParent()
    }
    
    func photoCropControllerDidCancel(_ controller: EditorViewController) {
        guard let editorViewController = children.first as? EditorViewController else {
            fatalError("Unable to load EditorViewController from xib")
        }
        editorViewController.view.removeFromSuperview()
        editorViewController.removeFromParent()
    }
}
