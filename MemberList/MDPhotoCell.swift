//
//  MDPhotoCell.swift
//  MemberList
//
//  Created by flo on 06.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit
import MobileCoreServices

class MDPhotoCell: UITableViewCell , Reusable, UIAlertViewDelegate, UIPopoverControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    


    @IBOutlet weak var photo: UIImageView!
    weak var delegate: ShowPickerProtocol?
    
    //MARK: Image
    var imageIsNew = false
    var my_image: UIImage? = nil
    var picker = UIImagePickerController()
    var popover:UIPopoverController? = nil
    
    @IBAction func btn_takePhoto(sender: AnyObject)
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.mediaTypes = [kUTTypeImage as String]
            picker.delegate = self
            picker.allowsEditing = true
            delegate?.loadNewScreen(picker);
            //self.presentViewController(picker, animated: true, completion: nil)
        }
        else
        {
            print("no Camera ")
            //Create the AlertController
            let actionSheetController: UIAlertController = UIAlertController(title: "Warning", message: "no Camera on this device", preferredStyle: .Alert)
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                //Do some stuff
            }
            actionSheetController.addAction(cancelAction)
            //Create and an option action
            let nextAction: UIAlertAction = UIAlertAction(title: "Next", style: .Default) { action -> Void in
                //Do some other stuff
            }
            actionSheetController.addAction(nextAction)
            //Add a text field
            actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
                //TextField configuration
                textField.textColor = UIColor.blueColor()
            }
            
            //Present the AlertController
            delegate?.loadNewScreen(actionSheetController)
           // self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func btn_openGallery(sender: AnyObject) {

        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            //self.presentViewController(picker, animated: true, completion: nil)
            delegate?.loadNewScreen(picker)
        }
        else
        {
            popover = UIPopoverController(contentViewController: picker)
            popover!.presentPopoverFromRect(sender.frame, inView: self.contentView, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        my_image = info[UIImagePickerControllerEditedImage] as? UIImage
        photo!.contentMode = .ScaleAspectFit
        photo!.image = my_image
        imageIsNew = true
        picker.dismissViewControllerAnimated(true, completion: nil)
        print("imagePickerController.didFinishPickingMediaWithInfo.")
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        delegate?.dismissNewScreen()
    }
    

}
