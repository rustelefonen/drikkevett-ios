//
//  WelcomeUserSectionViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 08.04.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import UIKit
import CoreData

class WelcomeUserSectionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let setAppColors = AppColors()
    
    // Talk with core data
    let moc = DataController().managedObjectContext
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    @IBOutlet weak var motivationPhrases: UITextView!
    @IBOutlet weak var helloUserNicknameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var greetingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visuals()
        changeWelcomeNickName()
        
        self.profileImageView.layer.cornerRadius = 60 //self.profileImageView.frame.size.height / 2
        self.profileImageView.clipsToBounds = true
        //self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.borderWidth = 1.0
        self.profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.greetingLabel.text = randomGreeting()
        self.motivationPhrases.text = randomQuote()
        
        imagePicker.delegate = self
        
        readData()
        
        setConstraints()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        changeWelcomeNickName()
        setConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func visuals(){
        self.view.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.6)
        //self.view.layer.cornerRadius = 10
        //self.view.layer.shadowRadius = 10.0
        
        motivationPhrases.textColor = setAppColors.textUnderHeadlinesColors()
        motivationPhrases.font = setAppColors.setTextQuoteFont(11)
        helloUserNicknameLabel.textColor = setAppColors.textUnderHeadlinesColors()
        helloUserNicknameLabel.font = setAppColors.textUnderHeadlinesFonts(30)
    }
    
    func changeWelcomeNickName(){
        let nickname = fetchNickname()
        self.helloUserNicknameLabel.text = "\(nickname)"
    }
    
    func fetchNickname() -> String{
        var userData = [UserData]()
        var tempNickName = ""
        let timeStampFetch = NSFetchRequest(entityName: "UserData")
        do {
            userData = try moc.executeFetchRequest(timeStampFetch) as! [UserData]
            for item in userData {
                tempNickName = item.height! as String
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return tempNickName
    }
    
    // CHANGE HELLO/WELCOME LABEL OG QUOTES
    func randomGreeting() -> String{
        let quoteArray =
            [
                "Hei", "Halla", "Hallo", "Whats up?", "Hallois", "Skjer a?", "Skjer?", "God dag", "Ha en fin dag", "Hallo", "Que pasa?", "Morn", "Åssen går det?", "Står til?", "Läget?"
        ]
        let randomIndex = Int(arc4random_uniform(UInt32(quoteArray.count)))
        let finalString = quoteArray[randomIndex]
        return finalString
    }
    
    func randomQuote() -> String{
        let quoteArray = [
            "Visste du at du forbrenner ca. 0,15 promille per time",
            "Visste du at shotting og rask drikking gjør at kroppen ikke rekker å registere alkoholen før du tilsetter den mer? Da er risikoen for å miste kontroll stor!",
            "Nyt alkohol med måte, det vil både gjøre din kveld bedre og andres kveld mer hyggelig",
            "Det er ok å ta en shot med venner, men pass på at du ikke tar en for mye",
            "Ca 90 % av alkoholen forbrennes i leveren, resten utskilles i utåndingsluften, urinen og svetten",
            "Evnen til innlæring synker drastisk etter 0.4 i promille",
            "Alkohol gjør at hjernen blir selektiv slik at du lettere irriterer deg over småting",
            "Med promille fra 1.4 og oppover kan du få blackout",
            "Drikker du fort, er risikoen for blackout større",
            "Drikker du sprit, risikerer du å få for høy promille for fort",
            "Det beste rådet mot fyllesyke er å ha drikkevett dagen før",
            "Slutter du å drikke i god tid før du legger deg, minsker sjansen for å bli fyllesyk",
            "Er promillen høy, kan det være farlig å legge seg på stigende promille",
            "Er du ofte på fylla, øker risikoen for overvekt og ernæringsmangler.",
            "Alkohol inneholder mye kalorier og karbohydrater ",
            "Alkohol kan gi dårligere treningseffekt både på kort og lang sikt.",
            "Alkohol gir dårligere prestasjonsevne",
            "Planlegger du på forhånd hvor lite du skal drikke, er det lettere å holde seg til målet",
            "Spiser du et godt måltid før du begynner å drikke, blir promillen jevnere og litt lettere å kontrollere",
            "Alkohol er dehydrerende; drikk vann mellom hvert glass alkohol",
            "Det er ingen skam å tåle minst",
            "Er du syk, stresset, sover dårlig, eller bruker medisiner e.l. tåler du mindre alkohol, enn når du er frisk og uthvilt",
            "Alkohol gjør at du fortere mistforstår andre mennesker og situasjoner"
        ]
        let randomIndex = Int(arc4random_uniform(UInt32(quoteArray.count)))
        let finalString = quoteArray[randomIndex]
        return finalString
    }
    
    @IBAction func changeProfilePicButton(sender: UIButton) {
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Sett Profilbilde", message: "Velg fra kamerarull eller ta bilde selv", preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Avbryt", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Ta Bilde", style: .Default) { action -> Void in
            self.takepic()
        }
        actionSheetController.addAction(takePictureAction)
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Velg fra kamerarull", style: .Default) { action -> Void in
            self.selectPicture()
        }
        actionSheetController.addAction(choosePictureAction)
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    // TESTING PROFILE PIC
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Got an image")
        if let pickedImage:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage {
            let selectorToCall = Selector("imageWasSavedSuccessfully:didFinishSavingWithError:context:")
            UIImageWriteToSavedPhotosAlbum(pickedImage, self, selectorToCall, nil)
        }
        imagePicker.dismissViewControllerAnimated(true, completion: {
            // anything you want to happen when the user saves an image
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("User cancelled image")
        dismissViewControllerAnimated(true, completion: {
            // anything you want to happen when the user selects cancel
        })
    }
    
    func imageWasSavedSuccessfully(image: UIImage, didFinishSavingWithError error: NSError!, context: UnsafeMutablePointer<()>){
        print("image saved")
        if let theError = error {
            print("An error happond while saving the image = \(theError)")
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.profileImageView.image = image
                //self.buttonOutlet.setImage(image, forState: UIControlState.Normal)
                
                // TESTING SAVING PIC IN USER DATA
                
                let imageData = UIImageJPEGRepresentation(image, 1)
                let relativePath = "image_\(NSDate.timeIntervalSinceReferenceDate()).jpg"
                let path = self.documentsPathForFileName(relativePath)
                imageData!.writeToFile(path, atomically: true)
                NSUserDefaults.standardUserDefaults().setObject(relativePath, forKey: "path")
                NSUserDefaults.standardUserDefaults().synchronize()
            })
        }
    }
    
    // TESTING SAVING PIC IN USER DATA
    func documentsPathForFileName(name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true);
        let path = paths[0] as String;
        //let fullPath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(name)
        
        let writePath = NSTemporaryDirectory().stringByAppendingPathComponent(name)
        
        return writePath
    }
    
    func readData(){
        let possibleOldImagePath = NSUserDefaults.standardUserDefaults().objectForKey("path") as! String?
        if let oldImagePath = possibleOldImagePath {
            let oldFullPath = self.documentsPathForFileName(oldImagePath)
            let oldImageData = NSData(contentsOfFile: oldFullPath)
            // here is your saved image:
            let oldImage = UIImage(data: oldImageData!)
            self.profileImageView.image = oldImage
        }
    }
    
    // PICK FROM CAMERA ROLE
    func selectPicture() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func takepic(){
        if(UIImagePickerController.isSourceTypeAvailable(.Camera)){
            if(UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil){
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .Camera
                imagePicker.cameraCaptureMode = .Photo
                presentViewController(imagePicker, animated: true, completion: {})
            } else {
                //postAlert("Rear Camera does not exist", message: "Application cannot access the camera.")
            }
            
            
        } else {
            //postAlert("Camera inaccesible", message: "Application cannot access the camera.")
        }
    }
    
    func setConstraints(){
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            self.helloUserNicknameLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 12.0)
            //self.motivationPhrases.transform = CGAffineTransformTranslate(self.view.transform, -20.0, 0.0)
            self.greetingLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 18.0)
            
            // FONT
            self.helloUserNicknameLabel.font = setAppColors.textHeadlinesFonts(12)
            self.motivationPhrases.font = setAppColors.setTextQuoteFont(10)
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
            self.helloUserNicknameLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 12.0)
            //self.motivationPhrases.transform = CGAffineTransformTranslate(self.view.transform, -20.0, 0.0)
            self.greetingLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 21.0)
            
            // FONT
            self.helloUserNicknameLabel.font = setAppColors.textHeadlinesFonts(12.5)
            self.motivationPhrases.font = setAppColors.setTextQuoteFont(10)
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            self.helloUserNicknameLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 11.0)
            //self.motivationPhrases.transform = CGAffineTransformTranslate(self.view.transform, -20.0, 0.0)
            self.greetingLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 18.0)
            
            // FONT
            self.greetingLabel.font = setAppColors.textHeadlinesFonts(20)
        
            if(fetchNickname().length >= 0 && fetchNickname().length < 10){
                self.helloUserNicknameLabel.font = setAppColors.textHeadlinesFonts(23.0)
            }
            if(fetchNickname().length >= 10 && fetchNickname().length < 13){
                self.helloUserNicknameLabel.font = setAppColors.textHeadlinesFonts(17.0)
            }
            if(fetchNickname().length >= 13){
                self.helloUserNicknameLabel.font = setAppColors.textHeadlinesFonts(13.0)
            }
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
            self.helloUserNicknameLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 12.0)
            //self.motivationPhrases.transform = CGAffineTransformTranslate(self.view.transform, -20.0, 0.0)
            self.greetingLabel.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 25.0)
        }
    }
}

extension String {
    
    var length: Int {
        return characters.count
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathComponent(path)
    }
}
