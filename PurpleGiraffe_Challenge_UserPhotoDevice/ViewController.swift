//
//  ViewController.swift
//  PurpleGiraffe_UseTheDeviceCamera_Swift
//
//  Created by Jean-Michel ZARAGOZA on 10/04/2021.
//

import UIKit

class ViewController: UIViewController {
    
    private let imagePickerController = UIImagePickerController()
    
    private var swipeGesture : UISwipeGestureRecognizer?
    

    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var mySelectButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        guard let swipeGesture = swipeGesture else { return }
        myImageView.addGestureRecognizer(swipeGesture)
        swipeGesture.direction = .up
        
        myImageView.isMultipleTouchEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        myImageView.addGestureRecognizer(tapGesture)
        
    } // override func viewDidLoad()
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.myImageView.layer.cornerRadius = 10
        
        self.mySelectButton.layer.cornerRadius = 8
        
        //myImageView.bounds.width/2
            self.myImageView.layer.borderWidth = 1
            self.myImageView.layer.borderColor = UIColor.lightGray.cgColor

        
    } // end of : override func viewDidLayoutSubviews
    
    @objc func tapGesture() {
        openGallary()
    }

    @objc private func swipeAction() {
        if swipeGesture?.direction == .up {
            UIView.animate(withDuration: 0.5, animations: {
                self.myImageView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
            }, completion: { _ in
                self.share()
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.myImageView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            }, completion: { _ in
                self.share()
            })
        }
    } // end of : @objc private func swipeAction
    
    private func share() {
        let activityViewController = UIActivityViewController(activityItems: [myImageView.image!], applicationActivities: nil)
        present(activityViewController, animated: true)
        activityViewController.completionWithItemsHandler = { _, _, _, _ in
            UIView.animate(withDuration: 0.5) {
                self.myImageView.transform = .identity
            }
        }
    } // end of :private func share
    
    @IBAction func clickMySelectButton(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    } // @IBAction func clickSelectButton(_ sender: Any)
    
    //MARK: - Open the camera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePickerController.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    } // func openCamera()
    
    func openGallary(){
        print("tapGesture on Image View")
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    } // func openGallary(){
    
} // class ViewController: UIViewController



extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    /// This function implements 2 protocols
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        myImageView.image = selectedImage
        dismiss(animated: true)
    }
} // end of : extension ViewController
