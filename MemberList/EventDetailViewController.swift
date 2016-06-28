//
//  EventDetailViewController.swift
//  MemberList
//
//  Created by flo on 17.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit
import CoreData
import Charts

class EventDetailViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, CellSwichChangedProtocol, UIPopoverPresentationControllerDelegate, SwichChanged_Member{

    var event: Event?
    var selectedEvent_Date: Event_Date?
    var eventDates: [ Event_Date] = [ ]
   
    let dateFormatter = NSDateFormatter()
    
    var trainer: Trainer?
    var eventDatePicker: Event_Date?
    var eventDatePickerMember: Event_Date?
    
    var member: Member?
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchedRSC_Trainer: NSFetchedResultsController = NSFetchedResultsController()
    var fetchedRSC_Member: NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewAllgemein.hidden = false
        self.viewTermine.hidden = true
        self.viewAusbilder.hidden = true
        self.viewTeilnehmer.hidden = true
        
        dP_begin.date = NSDate() //current date
        dP_end.date = NSDate()  //current date
        
        // Trainer fetch all
        fetchedRSC_Trainer = getFetchedRSC_Trainer()
        fetchedRSC_Trainer.delegate = self
        do{
            try fetchedRSC_Trainer.performFetch()
        } catch let error as NSError {
            print("Could not fetch Trainer \(error), \(error.userInfo)")
        }
        
        // alle Delegates auf self setzen
        self.setDelegates()
        
        // Datumsformat
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"

        // Daten setzen
        if(event != nil){
            setDataToView()
            hideFields(false)
        }else{
            hideFields(true)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    func hideFields(hide: Bool){
        btn_addMember.hidden = hide
        btn_addDate.hidden = hide
        label_AusbilderDate.hidden = hide
        label_TeilnehmerDate.hidden = hide
        stepper_Ausbilder.hidden = hide
        stepper_Teilnehmer.hidden = hide
    }
    
    func setDelegates(){
        // Member Table View
        self.memberTableView.delegate = self
        self.memberTableView.dataSource = self
        self.memberTableView.allowsSelection = false
        
        
        // Trainer Table View
        self.trainerTableView.delegate = self
        self.trainerTableView.dataSource = self
        self.trainerTableView.allowsSelection = false
        
        // Date Table View
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //Textfields
        tF_name.delegate = self
        tf_location.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var viewAllgemein: UIView!
    @IBOutlet weak var viewTermine: UIView!
    @IBOutlet weak var viewAusbilder: UIView!
    @IBOutlet weak var viewTeilnehmer: UIView!
    
//MARK: Segment Action
    // Jeweiligen View einblenden
    @IBAction func segmentChange(sender: AnyObject)
    {
        switch sender.selectedSegmentIndex {
        case 0:
            self.viewAllgemein.hidden = false
            self.viewTermine.hidden = true
            self.viewAusbilder.hidden = true
            self.viewTeilnehmer.hidden = true
        case 1:
            self.viewAllgemein.hidden = true
            self.viewTermine.hidden = false
            self.viewAusbilder.hidden = true
            self.viewTeilnehmer.hidden = true
        case 2:
            self.viewAllgemein.hidden = true
            self.viewTermine.hidden = true
            self.viewTeilnehmer.hidden = false
            self.viewAusbilder.hidden = true
        case 3:
            self.viewAllgemein.hidden = true
            self.viewTermine.hidden = true
            self.viewTeilnehmer.hidden = true
            self.viewAusbilder.hidden = false
        default:
            print("default")
        }
    }
    
    @IBOutlet weak var tF_name: UITextField!
    @IBOutlet weak var tf_location: UITextField!

    
    @IBOutlet weak var dP_begin: UIDatePicker!
    @IBOutlet weak var dP_end: UIDatePicker!
    
    
//MARK: Button Add Datum
    
    @IBOutlet weak var btn_addDate: UIButton!
    
    @IBAction func btn_addDate(sender: AnyObject) {
        
        selectedEvent_Date = Event_Date(event: event!, begin: dP_begin.date, end: dP_end.date, insertIntoManagedObjectContext: managedObjectContext)
        updateEvent()   // evtl. event == nil
        event!.addEvent_Date(selectedEvent_Date!)
        updateEvent()       // infos abspeichern
        
        tableView.reloadData()
    }
    
//MARK: Button Add Teilnehmer
    
    @IBOutlet weak var btn_addMember: UIButton!
    
    
//MARK: Textfield
    func textFieldDidEndEditing(textField: UITextField) {
        updateEvent()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
// MARK: Date Picker Ausbilder
    @IBOutlet weak var label_AusbilderDate: UILabel!
    @IBOutlet weak var stepper_Ausbilder: UIStepper!
    
    @IBAction func stepper_Ausbilder_Changed(sender: UIStepper) {
        if(eventDates.count > 1){
            eventDatePicker = eventDates[Int(stepper_Ausbilder.value)]
            label_AusbilderDate.text = dateFormatter.stringFromDate(eventDatePicker!.beginn!)
            trainerTableView.reloadData()
        }
    }
    
    
// MARK: Date Picker Teilnehmer
    @IBOutlet weak var label_TeilnehmerDate: UILabel!
    @IBOutlet weak var stepper_Teilnehmer: UIStepper!
    
    @IBAction func stepper_Teilnehmer_Changed(sender: UIStepper) {
        if(eventDates.count > 1){
            eventDatePickerMember = eventDates[Int(stepper_Teilnehmer.value)]
            label_TeilnehmerDate.text = dateFormatter.stringFromDate(eventDatePickerMember!.beginn!)
            memberTableView.reloadData()
        }
    }
    
    
    
//MARK: DateTable
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(tableView == self.trainerTableView){
            guard let sectionCount = fetchedRSC_Trainer.sections?.count else {
                return 0
            }
            return sectionCount
        }
        else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("Cells.count:  \(cells.count)")
        var result = 0
         if(tableView == self.tableView){
            if (event != nil){
                result = event!.eventHasDates!.count
            }
         }else if( tableView == self.trainerTableView){
            guard let sectionData = fetchedRSC_Trainer.sections?[section] else {
                return 0
            }
            return sectionData.numberOfObjects
         }
         else if( tableView == self.memberTableView){
            if(event != nil){
                return event!.eventHasMembers!.count
            }
         }
        
        return result
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // da sich in der Ansicht 3 Tabellen befinden die durch die Views ausgeblendet werden muss hier unterschieden werden!
        // Date View
        if(tableView == self.tableView){
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellEDDate)
           // eventDates = event!.eventHasDates!.allObjects as! [Event_Date]
            eventDates = event!.hasEventDatesAsArray()
            let eventDate = eventDates[indexPath.row]
        
            let beginString = dateFormatter.stringFromDate(eventDate.beginn!)
            let endString = dateFormatter.stringFromDate(eventDate.end!)
        
            setDataToView()         //Stepper muss aktualisiert werden

            cell!.textLabel!.text = beginString + "  -  " + endString
            return cell!
        }
        // Trainer View
        else if(tableView == self.trainerTableView){
            // Alle Trainer laden!
            trainer = fetchedRSC_Trainer.objectAtIndexPath(indexPath) as? Trainer
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellEDTrainer) as! EDTrainerTableCell
            cell.label_name.text = trainer!.firstname! + ", " + trainer!.surname!
            cell.switch_present.on = false
            cell.trainer = trainer
            if (trainer!.hasEvent_Date?.count > 0 && eventDatePicker != nil){
                if(trainer!.hasEvent_Date!.containsObject(eventDatePicker!)){
                    cell.switch_present.on = true
                }
            }
           
            cell.cellDelegate = self
            return cell
        }
        // Member View
        else if(tableView == self.memberTableView){
            // nur Member laden die in Event bereits sind
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellEDMember) as! EDMemberTableCell
            
            var memberArray = event!.hasMembersAsArray()
            cell.member = memberArray[ indexPath.row ]
            cell.delegate = self
            cell.setData()
            if (cell.member!.hasEvent_Date?.count > 0 && eventDatePickerMember != nil){
                if(cell.member!.hasEvent_Date!.containsObject(eventDatePickerMember!)){
                    cell.switch_Member.on = true
                }
            }
            return cell
        }else{
            
            return UITableViewCell()
        }
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == self.tableView){
            selectedEvent_Date = eventDates[indexPath.row]
            //print(selectedEvent_Date)
            event!.removeEvent_Date(selectedEvent_Date!)
            tableView.reloadData()
            setDataToView()         //Stepper muss aktualisiert werden
        }
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
         if(tableView == self.tableView){
            return true
         }else{
            return false
        }
    }

//MARK: Trainer Table
    
    @IBOutlet weak var trainerTableView: UITableView!
    
    
    func switchChanged(sender: EDTrainerTableCell){
        trainer = sender.trainer
        
        if (sender.switch_present.on){                      //JA, Switch on
            trainer!.addEvent_Date(eventDatePicker!)        // füge Datum hinzu
        }else{                                              //Switch of
            trainer!.removeEvent_Date(eventDatePicker!)     // entferne Datum
        }
        updateEvent()   // speichern
    }
    
    // FetchRequest für alle Trainer
    func trainerFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: Constants.EntityTrainer)
        let primarySortDescriptor = NSSortDescriptor(key: "surname", ascending: true)
        fetchRequest.sortDescriptors = [primarySortDescriptor]
        
        return fetchRequest
    }
    

    func getFetchedRSC_Trainer() -> NSFetchedResultsController {
        fetchedRSC_Trainer = NSFetchedResultsController(fetchRequest: trainerFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedRSC_Trainer
    }
    
    
    
//MARK: Member Table
    
    @IBOutlet weak var memberTableView: UITableView!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Popup zum auswählen der Members für eine Veranstaltung
        if segue.identifier == Constants.ShowEDMemberPopover{
            let popVC = segue.destinationViewController as! EDMemberPopoverController
            popVC.event = event!        // Event übergeben!
            
            let contPop = popVC.popoverPresentationController
            if (contPop != nil) {
                contPop?.delegate = self
            }

        }
    }

    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        memberTableView.reloadData()
    }
    
    // wenn der Schalter in der Cell des Members geändert wurde -> Event_Date updaten
    func switchChanged_Member(sender: EDMemberTableCell ){  // wird von Celle aus aufgerufen
        member = sender.member
        
        if (sender.switch_Member.on){  //JA
            member!.addEvent_Date(eventDatePickerMember!)       // Datum zu Member hinzufügen
            //updateEvent()                                       // speichern
        }else{                  //NEIN
            member!.removeEvent_Date(eventDatePickerMember!)       // Datum entfernen
            //updateEvent()                                           // speichern
        }
        updateEvent()   //speichern
    }
    
    
//MARK: Bar Chart
    
    @IBOutlet weak var barChartView: BarChartView!
    

    // erzeugt ein Bar Chart
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = Constants.NoDataForChart      //"You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet1 = BarChartDataSet(yVals: dataEntries, label: Constants.Teilnehmer)
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet1)
        barChartView.data = chartData

        chartDataSet1.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
    }
    
    // erzeugt ein gruppiertes Bar Chart
    func setChartBarGroupDataSet(dataPoints: [String], values: [Double], values2: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries2: [BarChartDataEntry] = []
        
        // Data Entries erzeugen
        for i in 0..<dataPoints.count {
            
            var dataEntry = BarChartDataEntry(value: values2[i], xIndex: i)
            dataEntries2.append(dataEntry)
            
            dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        // Legende
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: Constants.Ausbilder)
        let chartDataSet2 = BarChartDataSet(yVals: dataEntries2, label: Constants.Teilnehmer)
        // Farben setzen
        chartDataSet2.colors =  [UIColor(red: 255/255, green: 70/255, blue: 108/255, alpha: 1)]
        chartDataSet.colors =  [UIColor(red: 49/255, green: 27/255, blue: 146/255, alpha: 1)]
        
        // Daten seten
        let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet2]
        let data = BarChartData(xVals: dataPoints, dataSets: dataSets)
        barChartView.data = data
        
        barChartView.descriptionText = ""   // keine Beschreibung, wird mitten im Diagramm angezeigt
        barChartView.noDataText = Constants.NoDataForChart
        
        // einige optische Sachen:
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.drawLabelsEnabled = false
        
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawAxisLineEnabled = false   //true
        
        
        barChartView.xAxis.drawGridLinesEnabled = true  //false
        barChartView.xAxis.drawLabelsEnabled = true
        barChartView.xAxis.setLabelsToSkip(0)   // jedes Label auf der x Achse soll angezeigt werden
        
        // Animation
        barChartView.animate(xAxisDuration:1.5, yAxisDuration: 1.5, easingOption: .EaseInBounce)
   
    }
    
    // das Chart neu zeichnen
    func refreshChart(){
        let chart_dates = event!.hasEventDatesForChart()
        setChartBarGroupDataSet(chart_dates, values: event!.sumTrainerArray , values2: event!.sumMemberArray)
        self.barChartView.setNeedsDisplay()
    }
    
    
//MARK: Update Data
    
    func updateEvent(){
        if event == nil{
            //neues Event
            let entityDescription = NSEntityDescription.entityForName(Constants.EntityEvent, inManagedObjectContext: managedObjectContext)
            event = Event(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        }
        getDataFromView()   //Daten Holen
        refreshChart()
        do {
            try managedObjectContext.save()
            setDataToView()
            //print("updateEvent(), saved finished \(event)")
        } catch let error as NSError{
            //print("Could not save Event \(error), \(error.userInfo)")
            NSLog("Could not save Event\(error), \(error.userInfo)")
        }
    }

    
    func getDataFromView(){
        event?.name = tF_name.text
        event?.location = tf_location.text
    }
    
    func setDataToView(){
        tF_name.text = event!.name
        tf_location.text = event!.location
        
        eventDates = event!.hasEventDatesAsArray()
        //Stepper Tab Ausbilder
        stepper_Ausbilder.minimumValue = 0.0
        stepper_Ausbilder.maximumValue = Double(eventDates.count - 1)
        stepper_Ausbilder.stepValue = 1.0
        
        // Stepper Tab Teilnehmer
        stepper_Teilnehmer.minimumValue = 0.0
        stepper_Teilnehmer.maximumValue = Double(eventDates.count - 1)
        stepper_Teilnehmer.stepValue = 1.0
        
        
        if(eventDates.count > 0){
            // Tab Member
            label_TeilnehmerDate.text = dateFormatter.stringFromDate(eventDates[0].beginn!)
            let eDM = eventDates[ 0 ]
            eventDatePickerMember = eDM
            // Tab Ausbilder
            label_AusbilderDate.text = dateFormatter.stringFromDate(eventDates[0].beginn!)
            let eDA = eventDates[ 0 ]
            eventDatePicker = eDA
            //Chart, Tab Allgemien
            self.refreshChart()
        }else{
            label_AusbilderDate.text = Constants.NOEventDates
            label_TeilnehmerDate.text = Constants.NOEventDates
            
        }
    }
    
}
