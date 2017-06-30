//
//  HomeViewControllerNew.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 28.06.2017.
//  Copyright © 2017 Lars Petter Kristiansen. All rights reserved.
//

import UIKit
import Charts

class HomeViewControllerNew: UIViewController, ChartViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
        
    @IBOutlet weak var defaultImage: UIImageView!
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var quoteTextView: UITextView!
    
    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var goalPieChartView: PieChartView!
    
    @IBOutlet weak var historyBarChartView: BarChartView!
    
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var totalHighestBac: UILabel!
    @IBOutlet weak var totalHighestAvgBac: UILabel!
    
    @IBOutlet weak var lastMonthCost: UILabel!
    @IBOutlet weak var lastMonthHighestBac: UILabel!
    @IBOutlet weak var lastMonthHighestAvgBac: UILabel!
    
    var userData:UserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userData = AppDelegate.getUserData()
        
        AppColors.setBackground(view: view)
        
        initTopCard()
        initPieCard()
        initBarCard()
        initCostCard()
    }
    
    func initTopCard() {
        defaultImage.layer.cornerRadius = 60
        self.defaultImage.clipsToBounds = true
        self.defaultImage.layer.borderWidth = 1.0
        self.defaultImage.layer.borderColor = UIColor.white.cgColor
        
        defaultImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.changeProfilePicButton)))
        greetingLabel.text = ResourceList.greetingArray[Int(arc4random_uniform(UInt32(ResourceList.greetingArray.count)))]
        nicknameLabel.text = userData?.height
        quoteTextView.text = ResourceList.quoteArray[Int(arc4random_uniform(UInt32(ResourceList.quoteArray.count)))]
    }
    
    func initPieCard() {
        goalPieChartView.delegate = self
        let allHistories = HistoryDao().getAll()
        
        guard let goalBac = userData?.goalPromille as? Double else {return}
        
        var overGoal = 0.0
        var underGoal = 0.0
        
        for history in allHistories {
            guard let historyHighestBac = history.hoyestePromille as? Double else {continue}
            if historyHighestBac > goalBac {overGoal += 1.0}
            else {underGoal += 1.0}
        }
        var dataEntries = [ChartDataEntry]()
        dataEntries.append(ChartDataEntry(x: 0.0, y: overGoal))
        dataEntries.append(ChartDataEntry(x: 1.0, y: underGoal))
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
        pieChartDataSet.colors = [AppColors.graphRed, AppColors.graphGreen]
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        goalPieChartView.data = pieChartData
        pieChartData.setDrawValues(false)
        
        styleGoalPieChart(goalBac: goalBac)
    }
    
    func styleGoalPieChart(goalBac:Double) {
        goalPieChartView.drawHoleEnabled = true
        goalPieChartView.holeRadiusPercent = CGFloat(0.80)
        goalPieChartView.holeColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        goalPieChartView.centerTextRadiusPercent = CGFloat(1.0)
        goalPieChartView.transparentCircleRadiusPercent = 0.85
        goalPieChartView.animate(yAxisDuration: 1.0)
        goalPieChartView.chartDescription?.text = ""
        goalPieChartView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        goalPieChartView.drawEntryLabelsEnabled = false
        goalPieChartView.legend.enabled = false
        goalPieChartView.isUserInteractionEnabled = false
        goalPieChartView.isUserInteractionEnabled = true
        
        let centerText = String(describing: goalBac)
        let fontAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 27.0), NSForegroundColorAttributeName: UIColor.white]
        let attriButedString = NSAttributedString(string: centerText, attributes: fontAttributes)
        goalPieChartView.centerAttributedText = attriButedString
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        goalTextView.text = ResourceList.pieChartTexts[Int(entry.x)]
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        goalTextView.text = ResourceList.pieChartTexts[2]
    }
    
    func initBarCard() {
        let historyList = HistoryDao().getAll()
        
        guard let goalBac = userData?.goalPromille as? Double else {return}
        styleBarChart(goalBac: goalBac)
        
        var dataEntries = [BarChartDataEntry]()
        var colors = [NSUIColor]()
        
        var days = [String]()
        
        for i in 0..<historyList.count{
            let history = historyList[i]
            let historyHighesetBAC = Double(history.hoyestePromille!)
            let day = Calendar.current.component(.day, from: history.dato! as Date)
            let month = DateUtil().getMonthOfYear(history.dato as Date?)!
            
            days.append("\(String(day)). \(month)")
            dataEntries.append(BarChartDataEntry(x: Double(i), y: historyHighesetBAC))
            
            if historyHighesetBAC > goalBac { colors.append(AppColors.graphRed) }
            else { colors.append(AppColors.graphGreen) }
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Brand 1")
        chartDataSet.drawValuesEnabled = false
        chartDataSet.colors = colors
        let chartData = BarChartData(dataSets: [chartDataSet])
        
        //YVals
        historyBarChartView.data = chartData
        
        //XVals
        historyBarChartView.xAxis.granularity = 1
        historyBarChartView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: { (index, _) -> String in
            return days[Int(index)]
        })
    }
    
    func styleBarChart(goalBac:Double){
        historyBarChartView.xAxis.labelPosition = .bottom
        historyBarChartView.leftAxis.drawGridLinesEnabled = false
        historyBarChartView.rightAxis.drawGridLinesEnabled = false
        historyBarChartView.xAxis.drawGridLinesEnabled = false
        historyBarChartView.noDataText = "ingen graf."
        historyBarChartView.rightAxis.drawTopYLabelEntryEnabled = false
        historyBarChartView.leftAxis.labelTextColor = UIColor.white
        historyBarChartView.xAxis.labelTextColor = UIColor.white
        historyBarChartView.chartDescription?.text = ""
        historyBarChartView.leftAxis.axisMinimum = 0.0
        historyBarChartView.rightAxis.enabled = false
        historyBarChartView.legend.enabled = false
        historyBarChartView.chartDescription?.textColor = UIColor.red
        historyBarChartView.isUserInteractionEnabled = false
        historyBarChartView.pinchZoomEnabled = false
        historyBarChartView.doubleTapToZoomEnabled = false
        
        let limitLine = ChartLimitLine(limit: goalBac)
        limitLine.lineColor = UIColor.white
        limitLine.lineDashLengths = [8.5, 8.5, 6.5]
        historyBarChartView.rightAxis.addLimitLine(limitLine)
    }
    
    func initCostCard() {
        var totalCostValue = 0
        var totalHighestBacValue = 0.0
        var totalHighestBacSumValue = 0.0
        
        var lastMonthTotalCostValue = 0
        var lastMonthTotalHighestBacValue = 0.0
        var lastMonthTotalHighestBacSumValue = 0.0
        var lastMonthCount = 0.0
        
        let allHistories = HistoryDao().getAll()
        
        for history in allHistories {
            if let historyCost = history.forbruk as? Int {
                totalCostValue += historyCost
                if dateIsWithinThePastMonth(date: history.dato!) {lastMonthTotalCostValue += historyCost}
            }
            if let historyHighestBac = history.hoyestePromille as? Double {
                totalHighestBacSumValue += historyHighestBac
                if historyHighestBac > totalHighestBacValue {totalHighestBacValue = historyHighestBac}
                
                if dateIsWithinThePastMonth(date: history.dato!) {
                    lastMonthTotalHighestBacSumValue += historyHighestBac
                    if historyHighestBac > lastMonthTotalHighestBacValue {
                        lastMonthTotalHighestBacValue = historyHighestBac
                        lastMonthCount += 1.0
                    }
                }
            }
        }
        totalCost.text = String(describing: totalCostValue)
        totalHighestBac.text = String(describing: totalHighestBacValue.roundTo(places: 2))
        let totalHighestBacAvgValue = totalHighestBacSumValue / Double(allHistories.count)
        totalHighestAvgBac.text = String(describing: totalHighestBacAvgValue.roundTo(places: 2))
        
        lastMonthCost.text = String(describing: lastMonthTotalCostValue)
        lastMonthHighestBac.text = String(describing: lastMonthTotalHighestBacValue.roundTo(places: 2))
        let lastMonthTotalHighestBacAvgValue = lastMonthTotalHighestBacSumValue / lastMonthCount
        lastMonthHighestAvgBac.text = String(describing: lastMonthTotalHighestBacAvgValue.roundTo(places: 2))
    }
    
    func dateIsWithinThePastMonth(date:Date) -> Bool {
        guard let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date()) else {
            return false
        }
        return date > oneMonthAgo
    }
    
    func changeProfilePicButton() {
        print("lol")
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Sett Profilbilde", message: "Velg fra kamerarull eller ta bilde selv", preferredStyle: .actionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Avbryt", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Ta Bilde", style: .default) { action -> Void in
            self.takepic()
        }
        actionSheetController.addAction(takePictureAction)
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Velg fra kamerarull", style: .default) { action -> Void in
            self.selectPicture()
        }
        actionSheetController.addAction(choosePictureAction)
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    // TESTING PROFILE PIC
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage {
            let selectorToCall = #selector(WelcomeUserSectionViewController.imageWasSavedSuccessfully(_:didFinishSavingWithError:context:))
            UIImageWriteToSavedPhotosAlbum(pickedImage, self, selectorToCall, nil)
        }
        imagePicker.dismiss(animated: true, completion: {
            // anything you want to happen when the user saves an image
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: {
            // anything you want to happen when the user selects cancel
        })
    }
    
    func imageWasSavedSuccessfully(_ image: UIImage, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
        if let theError = error {
            print("An error happond while saving the image = \(theError)")
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
                self.defaultImage.image = image
                
                let imageData = UIImageJPEGRepresentation(image, 1)
                let relativePath = "image_\(Date.timeIntervalSinceReferenceDate).jpg"
                let path = self.documentsPathForFileName(relativePath)
                try? imageData!.write(to: URL(fileURLWithPath: path), options: [.atomic])
                UserDefaults.standard.set(relativePath, forKey: "path")
                UserDefaults.standard.synchronize()
            })
        }
    }
    
    func documentsPathForFileName(_ name: String) -> String {
        return NSTemporaryDirectory().stringByAppendingPathComponent(name)
    }
    
    func readData(){
        let possibleOldImagePath = UserDefaults.standard.object(forKey: "path") as! String?
        if let oldImagePath = possibleOldImagePath {
            let oldFullPath = self.documentsPathForFileName(oldImagePath)
            let oldImageData = try? Data(contentsOf: URL(fileURLWithPath: oldFullPath))
            // here is your saved image:
            let oldImage = UIImage(data: oldImageData!)
            self.defaultImage.image = oldImage
        }
    }
    
    // PICK FROM CAMERA ROLE
    func selectPicture() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func takepic(){
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            if(UIImagePickerController.availableCaptureModes(for: .rear) != nil){
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                imagePicker.cameraCaptureMode = .photo
                present(imagePicker, animated: true, completion: {})
            } else {
                //postAlert("Rear Camera does not exist", message: "Application cannot access the camera.")
            }
        } else {
            //postAlert("Camera inaccesible", message: "Application cannot access the camera.")
        }
    }
}
