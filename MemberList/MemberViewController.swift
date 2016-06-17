//
//  MemberViewController.swift
//  DLRG
//
//  Created by flo on 24.05.16.
//  Copyright © 2016 flo. All rights reserved.
//
import Foundation
import UIKit
import MobileCoreServices
import CoreData

class MemberViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate ,UIAlertViewDelegate,UIPopoverControllerDelegate{
    
    var member: Member?
    //var memberNSManagedObject : NSManagedObject?
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(member != nil){
            firstnameTextField.text = member!.firstname
            surnameTextField.text = member!.surname
            if (member!.image != nil){
                imageView.image = UIImage(data: member!.image!)
                //member!.image = UIImagePNGRepresentation(image!)
            }
        }

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Image
    var image: UIImage? = nil
    var picker = UIImagePickerController()
    var popover:UIPopoverController? = nil
    
    
    @IBAction func openGalerie(sender: AnyObject) {
        
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(picker, animated: true, completion: nil)
        }
        else
        {
            //presentViewController(picker, animated: true, completion: nil)
            popover = UIPopoverController(contentViewController: picker)
            popover!.presentPopoverFromRect(sender.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
        
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func takePhoto(sender: AnyObject)
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.mediaTypes = [kUTTypeImage as String]
            picker.delegate = self
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
            
            
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
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
        
    }
    
   
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
       // picker.dismissViewControllerAnimated(true, completion: nil)
        image = info[UIImagePickerControllerEditedImage] as? UIImage
        imageView.contentMode = .ScaleAspectFit
        imageView.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
        print("imagePickerController.didFinishPickingMediaWithInfo.")
        
        /* ç= info[UIImagePickerControllerOriginalImage] as! UIImage
         imageView.image = image
         imageViewContainer.addSubview(imageView)
         //makeRoomForImage
         saveImage()
         */
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("picker cancel.")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Text Fields
    
    
    @IBOutlet weak var firstnameTextField: UITextField!{
        didSet{
            firstnameTextField.delegate = self
            //member!.firstname = firstnameTextField.text
        }
    }
    @IBOutlet weak var surnameTextField: UITextField!{
        didSet{
            firstnameTextField.delegate = self
            //member!.surname = surnameTextField.text
        }
    }
    
    func textFieldShouldReturn(textField: UITextField)->Bool{
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func saveBtn(sender: AnyObject) {
        if(member != nil){
            editMember()
        }else{
            createMember()
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    func createMember(){
        let entityDescription = NSEntityDescription.entityForName(Constants.EntityMember, inManagedObjectContext: managedObjectContext)
        member = Member(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        member!.firstname = firstnameTextField.text
        member!.surname = surnameTextField.text
        do {
            try managedObjectContext.save()
            print("createMember(), saved finished")
            print("saved Member: \(member)")
            //5
            //members.append(member)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func editMember(){
        print("editMember()")
        member!.firstname = firstnameTextField.text
        member!.surname = surnameTextField.text
        if(image != nil){
             member!.image = UIImagePNGRepresentation(image!)
        }
       
        do {
            try managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not edit Member \(error), \(error.userInfo)")
        }
    }
    
}

extension UIImage{
    var aspectRatio: CGFloat{
        return size.height != 0 ? size.width/size.height: 0
    }
}
