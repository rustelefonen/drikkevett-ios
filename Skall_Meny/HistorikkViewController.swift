import UIKit
import CoreData

class HistorikkViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // TABLEVIEW OUTLET
    @IBOutlet weak var historikkTableView: UITableView!
    
    // OUTLET BUTTON SLETT HISTORIKK
    @IBOutlet weak var deleteHistoryOutlet: UIButton!
    
    // Hente managedObjectContext fra AppDelegate (DATABASE)
    let managedObjectContext = DataController().managedObjectContext
    let brainCoreData = CoreDataMethods()
    let brain = SkallMenyBrain()
    
    var testArray = [Historikk]()
    var sectionsInTable = [String]()
    
    // Set app Colors
    var setAppColors = AppColors()
    
    // Create the table view as soon as this class loads
    var logTableView = UITableView(frame: CGRectZero, style: .Plain)
    
    // Create an empty array of LogItem's
    var logItems = [Historikk]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Historikk view loaded...")
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        self.deleteHistoryOutlet.titleLabel?.font = setAppColors.buttonFonts(13)
        print("setting color on logTableView")
        //logTableView.backgroundColor = setAppColors.mainBackgroundColor()
        self.historikkTableView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.0)
 
        setConstraints()
        fetchLog()
    }
    
    // MARK: UITableViewDataSource
    
    // TESTING SECTIONS:
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return logItems.count
        print("Number of rows? \(getSectionItems(section).count)")
        if(sectionsInTable.isEmpty){
            print("return 1, bec sec is empty! number of rows in section")
            return self.getSectionItems(section).count + 1
        } else {
            print("return getsecitems(section).count")
            return self.getSectionItems(section).count
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(sectionsInTable.isEmpty){
            return 1
        } else {
            return sectionsInTable.count
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {       //Rar kode
        view.tintColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.3)
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor = UIColor.whiteColor()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.historikkTableView.dequeueReusableCellWithIdentifier("LogCell")! as! CustomHistorikkCellTableViewCell
        
        //let logItem = logItems[indexPath.row]
        
        // SETTING SECTIONS
        // get the items in this section
        let sectionItems = self.getSectionItems(indexPath.section)
        
        if sectionItems.isEmpty {
            
            print("Kan ikke være det her? ")
            cell.backgroundColor = UIColor.clearColor()
            
            // CELL BACKGROUNDCOLOR ( BRUK INDIVD FARGER VED METODE: .cellBackgroundColors)
            //cell.textLabel?.backgroundColor = setAppColors.mainBackgroundColor()
            cell.textLabel?.backgroundColor = UIColor.clearColor()
            
            // CELL SIDE-DCOLOR ( BRUK INDIVID FARGER VED METODE: .cellSidesColors()
            //cell.contentView.backgroundColor = setAppColors.mainBackgroundColor()
            cell.contentView.backgroundColor = UIColor.clearColor()
            cell.textLabel?.textColor = UIColor.redColor()
            cell.textLabel?.textColor = UIColor.greenColor()
            
            // CELL TEXT SIZE / FONT
            cell.textLabel?.font = setAppColors.cellTextFonts(12)
            
            // CELL TEXT COLOR WHEN HIGHLIGHTED
            cell.textLabel?.highlightedTextColor = setAppColors.cellTextColorsPressed()
            
            // CELL HIGLIGHTED VIEW
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
            cell.selectedBackgroundView = backgroundView
            
            // DATO TITLE CELL:
            cell.dateLabel?.text = "Dato"
            cell.dateLabel?.font = setAppColors.cellTextFonts(14)
            cell.dateLabel?.highlightedTextColor = setAppColors.cellTextColorsPressed()
            cell.dateLabel?.layer.cornerRadius = 0.5 * cell.dateLabel.bounds.size.width;
            cell.dateLabel?.layer.borderWidth = 1.0;
            cell.dateLabel?.textColor = UIColor.whiteColor()
            cell.dateLabel?.layer.borderColor = UIColor.whiteColor().CGColor
            
            let headTitleString = "Ingen kvelder lagt til"
            cell.undertitleLabel?.text = "\(headTitleString)"
            cell.undertitleLabel?.textColor = UIColor.whiteColor()
            cell.undertitleLabel?.font = setAppColors.cellTextFonts(15)
            cell.undertitleLabel?.highlightedTextColor = setAppColors.cellTextColorsPressed()
            
            // UNDER TITLE CELL:
            cell.headTitleLabel?.text = "Høyeste Promille"
            cell.headTitleLabel?.textColor = UIColor.whiteColor()
            cell.headTitleLabel?.font = setAppColors.cellTextFonts(18)
            cell.headTitleLabel?.highlightedTextColor = setAppColors.cellTextColorsPressed()
            
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.userInteractionEnabled = false
        } else {
            cell.userInteractionEnabled = true
            let highestPromilleTest = sectionItems[indexPath.row].hoyestePromille as! Double
            cell.backgroundColor = UIColor.clearColor()
            
            // CELL BACKGROUNDCOLOR ( BRUK INDIVD FARGER VED METODE: .cellBackgroundColors)
            //cell.textLabel?.backgroundColor = setAppColors.mainBackgroundColor()
            cell.textLabel?.backgroundColor = UIColor.clearColor()
            
            // CELL SIDE-DCOLOR ( BRUK INDIVID FARGER VED METODE: .cellSidesColors()
            //cell.contentView.backgroundColor = setAppColors.mainBackgroundColor()
            cell.contentView.backgroundColor = UIColor.clearColor()
            
            // CELL TEXT COLOR WHEN ENTERING VIEW ( NOT HIGHLIGHTED )
            if(highestPromilleTest > fetchGoal()){
                cell.textLabel?.textColor = UIColor.redColor()
            } else {
                cell.textLabel?.textColor = UIColor.greenColor()
            }
            
            // CELL TEXT SIZE / FONT
            cell.textLabel?.font = setAppColors.cellTextFonts(12)
            
            // CELL TEXT COLOR WHEN HIGHLIGHTED
            cell.textLabel?.highlightedTextColor = setAppColors.cellTextColorsPressed()
            
            // CELL HIGLIGHTED VIEW
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
            cell.selectedBackgroundView = backgroundView
            
            // DATO TITLE CELL:
            let dateTextItem = sectionItems[indexPath.row].dato
            print("Date Text Item: \(dateTextItem)")
            
            let getDate = brain.getDateOfMonth(dateTextItem)
            let stringDate = "\(getDate!)"
            print("StringDate: \(stringDate)")
            cell.dateLabel?.text = "\(stringDate)"
            
            if(highestPromilleTest > fetchGoal()){
                cell.dateLabel?.layer.borderColor = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0).CGColor
            } else {
                cell.dateLabel?.layer.borderColor = UIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.0).CGColor
            }
            cell.dateLabel?.font = setAppColors.cellTextFonts(18)
            cell.dateLabel?.highlightedTextColor = setAppColors.cellTextColorsPressed()
            cell.dateLabel?.layer.cornerRadius = 0.5 * cell.dateLabel.bounds.size.width;
            cell.dateLabel?.layer.borderWidth = 1.0;
            cell.dateLabel?.textColor = UIColor.whiteColor()
            
            //self.beerOutletButton.layer.cornerRadius = 0.5 * beerOutletButton.bounds.size.width;
            //self.beerOutletButton.layer.borderWidth = 0.5;
            //self.beerOutletButton.layer.borderColor = UIColor.whiteColor().CGColor
            
            // HEAD TITLE CELL:
            // get the item for the row in this section
            //dateTextItem = sectionItems[indexPath.row].dato
            //print("Date Text Item: \(dateTextItem)")
            
            //cell.textLabel!.text = dateTextItem.text
            let getCosts = sectionItems[indexPath.row].forbruk as! Int
            let getDay = brain.getDayOfWeekAsString(dateTextItem)
            //let getMonth = brain.getMonthOfYear(dateTextItem)
            let headTitleString = "\(getDay!) brukte du \(getCosts),-"
            print("HeadTitleString: \(headTitleString)")
            
            cell.undertitleLabel?.text = "\(headTitleString)"
            cell.undertitleLabel?.textColor = UIColor.whiteColor()
            cell.undertitleLabel?.font = setAppColors.cellTextFonts(15)
            cell.undertitleLabel?.highlightedTextColor = setAppColors.cellTextColorsPressed()
            
            // UNDER TITLE CELL:
            var faenskap = ""
            
            let highProm = sectionItems[indexPath.row].hoyestePromille as! Double
            print("Before Format Cell: \(highProm)")
            faenskap = String(format: "%.2f", highProm)
            print("After Format Cell: \(highProm)")
            
            cell.headTitleLabel?.text = "Høyeste promille \(faenskap)"
            
            if(highestPromilleTest > fetchGoal()){
                cell.headTitleLabel?.textColor = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0) // RED
            } else {
                cell.headTitleLabel?.textColor = UIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.0) // GREEN
            }
            cell.headTitleLabel?.font = setAppColors.cellTextFonts(18)
            cell.headTitleLabel?.highlightedTextColor = setAppColors.cellTextColorsPressed()
            
            //cell.textLabel?.text = "\(logItem.datoTwo!)"
            
            // ARROWS ON THE SIDE
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sectionItems = self.getSectionItems(indexPath.section)
        let logItem = sectionItems[indexPath.row]
        print(logItem.dato)
        self.performSegueWithIdentifier("showCellSegue", sender: self)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {
            
            var sectionItems = self.getSectionItems(indexPath.section)
            print("Section Items: \(sectionItems)")
            
            let object = sectionItems.removeAtIndex(indexPath.row)
            managedObjectContext.deleteObject(object)
            self.historikkTableView.beginUpdates()
            let indexSet = NSMutableIndexSet()
            indexSet.addIndex(indexPath.section)
            
            self.historikkTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            self.historikkTableView.insertSections(indexSet, withRowAnimation: .Automatic)
            self.historikkTableView.deleteSections(indexSet, withRowAnimation: .Automatic)
            
            self.historikkTableView.endUpdates()
            
            // Refresh the table view to indicate that it's deleted
            self.fetchLog()
            self.historikkTableView.reloadData()
            print("reloaddata/fetchlog")
            
            do{
                try managedObjectContext.save()
            }catch{
                print("Error, data not saved!")
            }
        }
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Slett"
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    // TESTING SECTIONS
    //override func table
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showCellSegue") {
            let upcoming: HistorikkCelleViewController = segue.destinationViewController as! HistorikkCelleViewController
            
            let indexPath = self.historikkTableView.indexPathForSelectedRow!
            
            let sectionItems = self.getSectionItems(indexPath.section)
            
            let datoString = sectionItems[indexPath.row].datoTwo
            let forbrukInt = sectionItems[indexPath.row].forbruk as! Int
            let hoyestePromilleDouble = sectionItems[indexPath.row].hoyestePromille as! Double
            let antallOlInt = sectionItems[indexPath.row].antallOl as! Int
            let antallVinInt = sectionItems[indexPath.row].antallVin as! Int
            let antallDrinkInt = sectionItems[indexPath.row].antallDrink as! Int
            let antallShotInt = sectionItems[indexPath.row].antallShot as! Int
            //let dateStamp = sectionItems[indexPath.row].dato! as NSDate
            let sessionNumber = sectionItems[indexPath.row].sessionNumber! as Int
            
            
            /*let testingShit = self.testArray[indexPath.row].text
            upcoming.helvete = testingShit*/
            
            //let sectionItems = self.getSectionItems(indexPath.section)
            //let datoString = self.logItems[indexPath.row].datoTwo
            //let forbrukInt = self.logItems[indexPath.row].forbruk as! Int
            //let hoyestePromilleDouble = self.logItems[indexPath.row].hoyestePromille as! Double
            //let antallOlInt = self.logItems[indexPath.row].antallOl as! Int
            //let antallVinInt = self.logItems[indexPath.row].antallVin as! Int
            //let antallDrinkInt = self.logItems[indexPath.row].antallDrink as! Int
            //let antallShotInt = self.logItems[indexPath.row].antallShot as! Int
            //let dateStamp = self.logItems[indexPath.row].dato! as NSDate
            //let sessionNumber = self.logItems[indexPath.row].sessionNumber! as Int
            
            
            upcoming.dato = datoString!
            upcoming.forbruk = forbrukInt
            upcoming.hoyestePromille = hoyestePromilleDouble
            upcoming.antallOl = antallOlInt
            upcoming.antallVin = antallVinInt
            upcoming.antallDrink = antallDrinkInt
            upcoming.antallShot = antallShotInt
            upcoming.sessionNumber = sessionNumber
            
            self.historikkTableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            if(sectionsInTable.isEmpty){
                
            } else {
                self.fetchLog()
                self.historikkTableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        fetchLog()
        self.historikkTableView.reloadData()
    }
    
    func fetchLog() {
        let fetchRequest = NSFetchRequest(entityName: "Historikk")
        do {
            let sortDescriptor = NSSortDescriptor(key: "dato", ascending: false)
            
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            if let fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Historikk] {
                logItems = fetchResults
            }
        } catch {
            fatalError("HAHA; ITS CRASHED")
        }
        
        testArray.removeAll()
        sectionsInTable.removeAll()
        
        // SECTIONS:
        for items in logItems {
            print("Fetchlog for loop: \(items.dato!)")
            testArray.append(items)
            
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: items.dato!)
            let year = components.year
            print("\(year)")
            // + " - " + String(year)
            
            // CHECK FOR WHICH MONTH
            let checkForMonth = brain.getMonthOfYear(items.dato!)! + " - " + String(year)
            print("checkFormonth: \(checkForMonth)")
            
            // create sections NSSet so we can use 'containsObject'
            let sections: NSSet = NSSet(array: sectionsInTable)
            
            // if sectionsInTable doesn't contain the dateString, then add it
            if !sections.containsObject(checkForMonth) {
                //let formatToMonth = getMonthOfYear(newItem.insertDate)
                sectionsInTable.append(checkForMonth)
            }
        }
    }
    
    @IBAction func clearHistoryButton(sender: AnyObject) {
        let title = "Slett Historikk"
        let msg = "Er du sikker på at du vil slette historikk?"
        let cnclTitle = "Avbryt"
        let confTitle = "Slett"
        endPartyAlert(title, msg: msg, cancelTitle: cnclTitle, confirmTitle: confTitle)
    }
    
    func endPartyAlert(titleMsg: String, msg: String, cancelTitle:String, confirmTitle: String ){
        
        let alertController = UIAlertController(title: titleMsg, message:
            msg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.Destructive, handler:{ (action: UIAlertAction!) in
            print("Handle cancel logic here")
        }))
        alertController.addAction(UIAlertAction(title:confirmTitle, style: UIAlertActionStyle.Default, handler:  { action in
            self.brainCoreData.clearCoreData("Historikk")
            self.fetchLog()
            self.historikkTableView.reloadData()
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func fetchGoal() -> Double{
        var userData = [UserData]()
        var getGoalPromille = 0.0
        
        let timeStampFetch = NSFetchRequest(entityName: "UserData")
        do {
            userData = try managedObjectContext.executeFetchRequest(timeStampFetch) as! [UserData]
            for item in userData {
                getGoalPromille = item.goalPromille! as Double
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return getGoalPromille
    }
    
    func getSectionItems(section: Int) -> [Historikk] {
        var sectionItems = [Historikk]()
        
        // loop through the testArray to get the items for this sections's date
        for item in logItems {
            let dateTextItem = item as Historikk
            let df = NSDateFormatter()
            df.dateFormat = "MM/dd/yyyy"
            //let dateString = df.stringFromDate(dateTextItem.dato!)
            
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: dateTextItem.dato!)
            let year = components.year
            print("\(year)")
            // + " - " + String(year)
            
            // CHECK OM MÅNEDEN ALLEREDE EKSISTERER
            let checkMonthExists = brain.getMonthOfYear(dateTextItem.dato)! + " - " + String(year)
            
            // if the item's date equals the section's date then add it
            if checkMonthExists == sectionsInTable[section] as NSString {
                sectionItems.append(dateTextItem)
            }
        }
        return sectionItems
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(sectionsInTable.isEmpty){
            return "Ingen kvelder"
        } else {
            return sectionsInTable[section]
        }
    }
    
    func setConstraints(){
        // CONSTRAINTS
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4
            historikkTableView.contentSize.height = 50
            historikkTableView.bounds.size.height = 50
            self.historikkTableView.sizeToFit()
            print("iphone 4 - Historikk")
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // IPhone 5
            
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
            
        }
    }
}