import UIKit
import CoreData

class HistorikkViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // TABLEVIEW OUTLET
    @IBOutlet weak var historikkTableView: UITableView!
    
    // Hente managedObjectContext fra AppDelegate (DATABASE)
    let managedObjectContext = DataController().managedObjectContext
    let brainCoreData = CoreDataMethods()
    let brain = SkallMenyBrain()
    let dateUtil = DateUtil()
    
    var testArray = [Historikk]()
    var sectionsInTable = [String]()
    
    // Set app Colors
    var setAppColors = AppColors()
    
    // Create the table view as soon as this class loads
    var logTableView = UITableView(frame: CGRect.zero, style: .plain)
    
    // Create an empty array of LogItem's
    var logItems = [Historikk]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        self.historikkTableView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.0)
 
        setConstraints()
        fetchLog()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchLog()
        self.historikkTableView.reloadData()
    }
    
    
    // MARK: UITableViewDataSource
    
    // TESTING SECTIONS:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(sectionsInTable.isEmpty){
            return 1
        } else {
            return sectionsInTable.count
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {       //Rar kode
        view.tintColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.3)
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.historikkTableView.dequeueReusableCell(withIdentifier: "LogCell")! as! CustomHistorikkCellTableViewCell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        cell.selectedBackgroundView = backgroundView
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.textLabel?.font = setAppColors.cellTextFonts(12)
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.highlightedTextColor = setAppColors.cellTextColorsPressed()
        cell.undertitleLabel?.highlightedTextColor = setAppColors.cellTextColorsPressed()
        cell.undertitleLabel?.textColor = UIColor.white
        

        let sectionItems = self.getSectionItems((indexPath as NSIndexPath).section)
        
        if sectionItems.isEmpty {
            cell.textLabel?.textColor = UIColor.red
            cell.textLabel?.textColor = UIColor.green
            
            
            cell.dateLabel?.text = "Dato"
            cell.dateLabel?.font = setAppColors.cellTextFonts(14)
            cell.dateLabel?.highlightedTextColor = setAppColors.cellTextColorsPressed()
            cell.dateLabel?.layer.cornerRadius = 0.5 * cell.dateLabel.bounds.size.width;
            cell.dateLabel?.layer.borderWidth = 1.0;
            cell.dateLabel?.textColor = UIColor.white
            cell.dateLabel?.layer.borderColor = UIColor.white.cgColor
            
            let headTitleString = "Ingen kvelder lagt til"
            cell.undertitleLabel?.text = "\(headTitleString)"
            cell.undertitleLabel?.font = setAppColors.cellTextFonts(15)
            
            cell.headTitleLabel?.text = "Høyeste Promille"
            cell.headTitleLabel?.textColor = UIColor.white
            cell.headTitleLabel?.font = setAppColors.cellTextFonts(18)
            cell.headTitleLabel?.highlightedTextColor = setAppColors.cellTextColorsPressed()
            
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.isUserInteractionEnabled = false
        } else {
            let highestPromilleTest = sectionItems[(indexPath as NSIndexPath).row].hoyestePromille as! Double
            
            if(highestPromilleTest > fetchGoal()) {
                cell.textLabel?.textColor = UIColor.red
                cell.dateLabel?.layer.borderColor = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0).cgColor
            } else {
                cell.textLabel?.textColor = UIColor.green
                cell.dateLabel?.layer.borderColor = UIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.0).cgColor
            }
            
            // DATO TITLE CELL:
            let dateTextItem = sectionItems[(indexPath as NSIndexPath).row].dato
            
            let getDate = dateUtil.getDateOfMonth(dateTextItem)
            let stringDate = "\(getDate!)"
            cell.dateLabel?.text = "\(stringDate)"
            
            cell.dateLabel?.font = setAppColors.cellTextFonts(18)
            cell.dateLabel?.highlightedTextColor = setAppColors.cellTextColorsPressed()
            cell.dateLabel?.layer.cornerRadius = 0.5 * cell.dateLabel.bounds.size.width;
            cell.dateLabel?.layer.borderWidth = 1.0;
            cell.dateLabel?.textColor = UIColor.white
            
            let getCosts = sectionItems[(indexPath as NSIndexPath).row].forbruk as! Int
            let getDay = dateUtil.getDayOfWeekAsString(dateTextItem)
            
            let headTitleString = "\(getDay!) brukte du \(getCosts),-"
            print("HeadTitleString: \(headTitleString)")
            
            cell.undertitleLabel?.text = "\(headTitleString)"
            cell.undertitleLabel?.font = setAppColors.cellTextFonts(15)
            
            let highProm = sectionItems[(indexPath as NSIndexPath).row].hoyestePromille as! Double
            let faenskap = String(format: "%.2f", highProm)
            
            cell.headTitleLabel?.text = "Høyeste promille \(faenskap)"
            
            if(highestPromilleTest > fetchGoal()){
                cell.headTitleLabel?.textColor = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0) // RED
            } else {
                cell.headTitleLabel?.textColor = UIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.0) // GREEN
            }
            cell.headTitleLabel?.font = setAppColors.cellTextFonts(18)
            cell.headTitleLabel?.highlightedTextColor = setAppColors.cellTextColorsPressed()
            
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.isUserInteractionEnabled = true
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionItems = self.getSectionItems((indexPath as NSIndexPath).section)
        let logItem = sectionItems[(indexPath as NSIndexPath).row]
        print(logItem.dato)
        self.performSegue(withIdentifier: "showCellSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete ) {
            
            var sectionItems = self.getSectionItems((indexPath as NSIndexPath).section)
            
            let object = sectionItems.remove(at: (indexPath as NSIndexPath).row)
            

            managedObjectContext.delete(object)
            brainCoreData.deleteCellGraphHistory(object.sessionNumber as! Int)
            self.historikkTableView.beginUpdates()
            let indexSet = NSMutableIndexSet()
            indexSet.add((indexPath as NSIndexPath).section)
            
            self.historikkTableView.deleteRows(at: [indexPath], with: .automatic)
            
            self.historikkTableView.insertSections(indexSet as IndexSet, with: .automatic)
            self.historikkTableView.deleteSections(indexSet as IndexSet, with: .automatic)
            
            self.historikkTableView.endUpdates()
            
            // Refresh the table view to indicate that it's deleted
            self.fetchLog()
            self.historikkTableView.reloadData()
            
            do{
                try managedObjectContext.save()
            }catch{
                print("Error, data not saved!")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Slett"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    // TESTING SECTIONS
    //override func table
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showCellSegue") {
            let upcoming: HistorikkCelleViewController = segue.destination as! HistorikkCelleViewController
            
            let indexPath = self.historikkTableView.indexPathForSelectedRow!
            
            let sectionItems = self.getSectionItems((indexPath as NSIndexPath).section)
            
            let datoString = sectionItems[(indexPath as NSIndexPath).row].datoTwo
            let forbrukInt = sectionItems[(indexPath as NSIndexPath).row].forbruk as! Int
            let hoyestePromilleDouble = sectionItems[(indexPath as NSIndexPath).row].hoyestePromille as! Double
            let antallOlInt = sectionItems[(indexPath as NSIndexPath).row].antallOl as! Int
            let antallVinInt = sectionItems[(indexPath as NSIndexPath).row].antallVin as! Int
            let antallDrinkInt = sectionItems[(indexPath as NSIndexPath).row].antallDrink as! Int
            let antallShotInt = sectionItems[(indexPath as NSIndexPath).row].antallShot as! Int
            //let dateStamp = sectionItems[indexPath.row].dato! as NSDate
            let sessionNumber = sectionItems[(indexPath as NSIndexPath).row].sessionNumber! as Int
            
            
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
            
            self.historikkTableView.deselectRow(at: indexPath, animated: true)
            
            if(sectionsInTable.isEmpty){
                
            } else {
                self.fetchLog()
                self.historikkTableView.reloadData()
            }
        }
    }
    
    func fetchLog() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Historikk")
        do {
            let sortDescriptor = NSSortDescriptor(key: "dato", ascending: false)
            
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            if let fetchResults = try managedObjectContext.fetch(fetchRequest) as? [Historikk] {
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
            
            let calendar = Calendar.current
            let components = (calendar as NSCalendar).components([.day , .month , .year], from: items.dato! as Date)
            let year = components.year
            print("\(year)")
            // + " - " + String(year)
            
            // CHECK FOR WHICH MONTH
            
            //let checkForMonth = "\(dateUtil.getMonthOfYear(items.dato!)!) - \(year!)"
            
            
            let checkForMonth = dateUtil.getMonthOfYear(items.dato!)! + " - " + String(describing: year)
            
            
            print("checkFormonth: \(checkForMonth)")
            
            // create sections NSSet so we can use 'containsObject'
            let sections: NSSet = NSSet(array: sectionsInTable)
            
            // if sectionsInTable doesn't contain the dateString, then add it
            if !sections.contains(checkForMonth) {
                //let formatToMonth = getMonthOfYear(newItem.insertDate)
                sectionsInTable.append(checkForMonth)
            }
        }
    }
    
    @IBAction func clearHistoryBtn(_ sender: AnyObject) {
        let title = "Slett Historikk"
        let msg = "Er du sikker på at du vil slette historikk?"
        let cnclTitle = "Avbryt"
        let confTitle = "Slett"
        endPartyAlert(title, msg: msg, cancelTitle: cnclTitle, confirmTitle: confTitle)
    }
    
    
    func endPartyAlert(_ titleMsg: String, msg: String, cancelTitle:String, confirmTitle: String ){
        
        let alertController = UIAlertController(title: titleMsg, message:
            msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.destructive, handler:{ (action: UIAlertAction!) in
            print("Handle cancel logic here")
        }))
        alertController.addAction(UIAlertAction(title:confirmTitle, style: UIAlertActionStyle.default, handler:  { action in
            self.brainCoreData.clearCoreData("Historikk")
            self.brainCoreData.clearCoreData("GraphHistorikk")
            self.fetchLog()
            self.historikkTableView.reloadData()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func fetchGoal() -> Double{
        var userData = [UserData]()
        var getGoalPromille = 0.0
        
        let timeStampFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        do {
            userData = try managedObjectContext.fetch(timeStampFetch) as! [UserData]
            for item in userData {
                getGoalPromille = item.goalPromille! as Double
            }
        } catch {
            fatalError("bad things happened \(error)")
        }
        return getGoalPromille
    }
    
    func getSectionItems(_ section: Int) -> [Historikk] {
        var sectionItems = [Historikk]()
        
        // loop through the testArray to get the items for this sections's date
        for item in logItems {
            let dateTextItem = item as Historikk
            let df = DateFormatter()
            df.dateFormat = "MM/dd/yyyy"
            //let dateString = df.stringFromDate(dateTextItem.dato!)
            
            let calendar = Calendar.current
            let components = (calendar as NSCalendar).components([.day , .month , .year], from: dateTextItem.dato! as Date)
            let year = components.year
            print("\(year)")
            // + " - " + String(year)
            
            // CHECK OM MÅNEDEN ALLEREDE EKSISTERER
            let checkMonthExists = dateUtil.getMonthOfYear(dateTextItem.dato)! + " - " + String(describing: year)
            
            // if the item's date equals the section's date then add it
            if checkMonthExists == sectionsInTable[section] {
                sectionItems.append(dateTextItem)
            }
        }
        return sectionItems
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(sectionsInTable.isEmpty){
            return "Ingen kvelder"
        } else {
            return sectionsInTable[section]
        }
    }
    
    func setConstraints(){
        // CONSTRAINTS
        if UIScreen.main.bounds.size.height == 480 {
            // iPhone 4
            historikkTableView.contentSize.height = 50
            historikkTableView.bounds.size.height = 50
            self.historikkTableView.sizeToFit()
        } else if UIScreen.main.bounds.size.height == 568 {
            // IPhone 5
            
        } else if UIScreen.main.bounds.size.width == 375 {
            // iPhone 6
            
        } else if UIScreen.main.bounds.size.width == 414 {
            // iPhone 6+
            
        }
    }
}
