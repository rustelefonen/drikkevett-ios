import UIKit
import CoreData

class HistorikkViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var historikkTableView: UITableView!
    var setAppColors = AppColors()
    var histories = [Historikk]()
    var sections = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBlurEffect()
        view.backgroundColor = setAppColors.mainBackgroundColor()
        historikkTableView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.0)
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchHistories()
        fetchSections()
        historikkTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(sections.count == 0) {return 1}
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if histories.count == 0 {return 1}
        return histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historikkTableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as! CustomHistorikkCellTableViewCell
        setMainColorsOf(cell: cell)
        
        if histories.count == 0 {
            cell.textLabel?.textColor = UIColor.green
            cell.dateLabel?.font = setAppColors.cellTextFonts(14)
            cell.dateLabel?.layer.borderColor = UIColor.white.cgColor
            cell.headTitleLabel?.textColor = UIColor.white
            cell.headTitleLabel?.highlightedTextColor = setAppColors.cellTextColorsPressed()
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.isUserInteractionEnabled = false
            cell.dateLabel?.text = "Dato"
            cell.undertitleLabel?.text = "Ingen kvelder lagt til"
            cell.headTitleLabel?.text = "Høyeste Promille"
        } else {
            //Silly stuff
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.isUserInteractionEnabled = true
            cell.dateLabel?.font = setAppColors.cellTextFonts(18)
            cell.headTitleLabel?.highlightedTextColor = setAppColors.cellTextColorsPressed()
            
            let currentHistory = histories[indexPath.row]
            let highestPromilleTest = currentHistory.hoyestePromille as! Double
            let userDataDao = UserDataDao()
            if(highestPromilleTest > userDataDao.fetchGoalBac()) {
                cell.textLabel?.textColor = UIColor.red
                cell.dateLabel?.layer.borderColor = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0).cgColor
                cell.headTitleLabel?.textColor = UIColor(red: 193/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0) // RED
            } else {
                cell.textLabel?.textColor = UIColor.green
                cell.dateLabel?.layer.borderColor = UIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.0).cgColor
                cell.headTitleLabel?.textColor = UIColor(red:26/255.0, green: 193/255.0, blue: 73/255.0, alpha: 1.0) // GREEN
            }
            let currentDate = currentHistory.dato
            
            let dateUtil = DateUtil()
            cell.dateLabel?.text = dateUtil.getDateOfMonth(currentDate)
            cell.undertitleLabel?.text = "\(dateUtil.getDayOfWeekAsString(currentDate)!) brukte du \(currentHistory.forbruk as! Int),-"
            let formattedHighestBac = String(format: "%.2f", currentHistory.hoyestePromille as! Double)
            cell.headTitleLabel?.text = "Høyeste promille \(formattedHighestBac)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showCellSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Slett"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {       //Rar kode
        view.tintColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.3)
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sections.count == 0 { return "Ingen kvelder" }
        return sections[section]
    }
    
    @IBAction func clearHistoryBtn(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Slett Historikk", message: "Er du sikker på at du vil slette historikk?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Avbryt", style: UIAlertActionStyle.destructive, handler: nil))
        alertController.addAction(UIAlertAction(title: "Slett", style: UIAlertActionStyle.default, handler:  { action in
            print("lol")
            let historyDao = HistoryDao()
            historyDao.deleteAll()
            let graphHistoryDao = GraphHistoryDao()
            graphHistoryDao.deleteAll()
            self.fetchHistories()
            self.fetchSections()
            self.historikkTableView.reloadData()
            /*self.brainCoreData.clearCoreData("Historikk")
            self.brainCoreData.clearCoreData("GraphHistorikk")
            self.fetchLog()
            self.historikkTableView.reloadData()*/
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete ) {
            
            /*var sectionItems = self.getSectionItems((indexPath as NSIndexPath).section)
            
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
            }*/
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showCellSegue") {
            let selectedHistoryVC = segue.destination as! HistorikkCelleViewController
            let indexPath = historikkTableView.indexPathForSelectedRow!
            selectedHistoryVC.history = histories[indexPath.row]
            historikkTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func fetchHistories(){
        let historyDao = HistoryDao()
        histories = historyDao.getAllOrderedByDate()
    }
    
    func fetchSections(){
        for history in histories {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            let components = (Calendar.current as NSCalendar).components([.day , .month , .year], from: history.dato! as Date)
            let year = components.year!
            
            let sectionLabel = DateUtil().getMonthOfYear(history.dato)! + " - " + String(describing: year)
            
            if !sections.contains(sectionLabel) {
                sections.append(sectionLabel)
            }
        }
    }
    
    func setBlurEffect(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
    }
    
    func setMainColorsOf(cell:CustomHistorikkCellTableViewCell){
        //Silly colors
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
        cell.undertitleLabel?.font = setAppColors.cellTextFonts(15)
        cell.dateLabel?.layer.cornerRadius = 0.5 * cell.dateLabel.bounds.size.width
        cell.dateLabel?.highlightedTextColor = setAppColors.cellTextColorsPressed()
        cell.dateLabel?.layer.borderWidth = 1.0
        cell.dateLabel?.textColor = UIColor.white
        cell.headTitleLabel?.font = setAppColors.cellTextFonts(18)
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
