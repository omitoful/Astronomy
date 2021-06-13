//
//  AddPicTableViewController.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/13.
//

import UIKit
import CoreData

class AddPicTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var copyrightTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var picture: PictureMO!
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let photoRequestCintroller = UIAlertController(title: "", message: "Choose your source", preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            let photolibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    
                    imagePicker.delegate = self
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            photoRequestCintroller.addAction(cameraAction)
            photoRequestCintroller.addAction(photolibraryAction)
            
            
            // pad
            if let popovercontroller = photoRequestCintroller.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popovercontroller.sourceView = cell
                    popovercontroller.sourceRect = cell.bounds
                }
            }
            
            present(photoRequestCintroller, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        // add new constraint:
        let leading = NSLayoutConstraint(item: photoImageView!, attribute: .leading, relatedBy: .equal, toItem: photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        leading.isActive = true
        
        let trailing = NSLayoutConstraint(item: photoImageView!, attribute: .trailing, relatedBy: .equal, toItem: photoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailing.isActive = true
        
        let top = NSLayoutConstraint(item: photoImageView!, attribute: .top, relatedBy: .equal, toItem: photoImageView.superview, attribute: .top, multiplier: 1, constant: 0)
        top.isActive = true
        
        let bottom = NSLayoutConstraint(item: photoImageView!, attribute: .bottom, relatedBy: .equal, toItem: photoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottom.isActive = true
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none

        titleTextField.tag = 1
        titleTextField.becomeFirstResponder()
        titleTextField.delegate = self
        
        dateTextField.tag = 2
        dateTextField.delegate = self
        
        urlTextField.tag = 3
        urlTextField.delegate = self
        
        copyrightTextField.tag = 4
        copyrightTextField.delegate = self
        
        descriptionTextView.tag = 5
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.layer.masksToBounds = true
        
        // nav
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60)]
        
    }
    @IBAction func saveInfo(_ sender: Any) {
        if titleTextField.text != "", dateTextField.text != "", urlTextField.text != "", copyrightTextField.text != "", descriptionTextView.text != "" {
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                picture = PictureMO(context: appDelegate.persistentContainer.viewContext)
                picture.title = titleTextField.text
                picture.date = dateTextField.text
                picture.url = urlTextField.text
                picture.copyright = copyrightTextField.text
                picture.picDescription = descriptionTextView.text
                
                if let picImage = photoImageView.image {
                    picture.image = picImage.pngData()
                }
                
                print("saving data to context...")
                appDelegate.saveContext()
            }
            performSegue(withIdentifier: "unwindToHome", sender: self)
        } else {
            let alert = UIAlertController(title: "oops!", message: "you need to fill all the blanks.", preferredStyle: .alert)
            let alertAct = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(alertAct)
            present(alert, animated: true, completion: nil)
        }
    }
}
