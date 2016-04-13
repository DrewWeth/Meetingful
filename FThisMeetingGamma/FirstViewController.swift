//
//  FirstViewController.swift
//  FThisMeetingGamma
//
//  Created by AGW on 6/9/15.
//  Copyright (c) 2015 Andrew Wetherington. All rights reserved.
//

import UIKit


extension NSTimeInterval {
    var time:String {
        return String(format:"%02d:%02d:%02d.%02d", Int((self/3600.0)%60),Int((self/60.0)%60), Int((self) % 60 ), Int(self*100 % 100 ) )
    }
    
    
    var costTime:Float {
        return Float( Float(self) / 3600 )
    }
}


class FirstViewController: UIViewController {

    @IBOutlet weak var lessPeople: UIButton!

    @IBOutlet weak var morePeople: UIButton!
    
    @IBOutlet weak var lessCost: UIButton!
    
    @IBOutlet weak var moreCost: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var costLabel: UILabel!
    
    @IBOutlet weak var peopleSlider: UISlider!
    
    @IBOutlet weak var peopleLabel: UILabel!
    
    @IBOutlet weak var hourlySlider: UISlider!
    
    @IBOutlet weak var hourlyLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var isPaused = false
    var pausedTimeInterval:NSTimeInterval = 0.0
    var state:MeetingState!
    let CLOCK_INTERVAL = 0.10
    var meeting:Meeting!
    var currentTime:NSString!
    var currentCost:Float!
    var numberFormatter = NSNumberFormatter()
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        state = MeetingState(people: Int(peopleSlider.value), hourly: Int(hourlySlider.value))

        resetButton.hidden = true

        peopleSlider.addTarget(self, action: Selector("peopleSliderDone"), forControlEvents: UIControlEvents.TouchUpInside)

        hourlySlider.addTarget(self, action: Selector("hourlySliderDone"), forControlEvents: UIControlEvents.TouchUpInside)
        print("viewDidLoad() done")

        

    }
    
    func peopleSliderDone(){
    }
    
    func hourlySliderDone(){
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startButtonHoldRelease(sender:UIButton){
    }
    
    func startButtonHoldDown(sender:UIButton){

    }
    
    @IBAction func peopleSliderChanged(sender: UISlider) {
        state.peopleCount = Int(sender.value)
        peopleLabel.text = "\(state.peopleCount) people"
    }
    func calcCostPerHour(cost:Float, people:Int, hourly:Int) -> Float {
        return Float(cost * Float(people) * Float(hourly))
    }
    
    @IBAction func hourlySliderChanged(sender: UISlider) {
        state.hourlyRate = Int(sender.value)
        hourlyLabel.text = "$\(state.hourlyRate)/h"
    }
    
    @IBAction func startButton(sender: AnyObject) {
        if !timer.valid {
            let aSelector : Selector = #selector(FirstViewController.updateTime)
            timer = NSTimer.scheduledTimerWithTimeInterval(CLOCK_INTERVAL, target: self, selector: aSelector, userInfo: nil, repeats:true)
            
            startTime = NSDate.timeIntervalSinceReferenceDate()
            startButton.setTitle("Pause", forState: UIControlState.Normal)
            meeting = Meeting()
        }
        else if(timer.valid){
            if !isPaused {
                startButton.setTitle("Continue", forState: UIControlState.Normal)
                isPaused = true
                resetButton.hidden = false
            }
            else if isPaused {
                startButton.setTitle("Pause", forState: UIControlState.Normal)
                isPaused = false
                resetButton.hidden = true
            }
        }
    }

    @IBAction func resetButtonPressed(sender: UIButton) {
        saveMeeting()
        resetStateAndGUI()
    }
    
    func resetStateAndGUI(){
        
        timer.invalidate()
        costLabel.text = "$0.00"
        currentCost = 0.0
        timerLabel.text = "00:00:00.00"
        currentTime = "00:00:00.00"
        startButton.setTitle("Start", forState: UIControlState.Normal)
        isPaused = false
        resetButton.hidden = true
        pausedTimeInterval = 0.0
    }
    
    func saveMeeting(){
        meeting.name = "Meeting" as NSString!
        meeting.worth = true
        meeting.cost = currentCost
        meeting.name = meeting.filename
        meeting.people = state.peopleCount
        
//        if self.sendAlert(){
        meeting.save()
//        }
    }

    func sendAlert() -> Bool{
        var alert = UIAlertController(title: "Worth it?", message: "Do you think your meeting was worth $\(meeting.cost) for these \(meeting.people) people?", preferredStyle: UIAlertControllerStyle.Alert)

        alert.addTextFieldWithConfigurationHandler({
            config in
            
            self.meeting.email = config.text
        })
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {
            action in


            self.meeting.worth = true
            self.dismissViewControllerAnimated(true, completion: {})
        }))

        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler:{
            action in

            self.meeting.worth = false
            self.dismissViewControllerAnimated(true, completion: {})
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        return true
    }
    
    
    @IBAction func lessPeople(sender: UIButton) {
        if state.peopleCount > 0{
            self.state.peopleCount = state.peopleCount - 1
            self.peopleSlider.value = peopleSlider.value - 1
            if Int(peopleSlider.value) == 1{
                self.peopleLabel.text = "\(Int(peopleSlider.value)) people"
            }else{
                self.peopleLabel.text = "\(Int(peopleSlider.value)) person"
            }
        }
    }
    
    @IBAction func morePeople(sender: UIButton) {
        if state.peopleCount < Int(peopleSlider.maximumValue) {
            self.state.peopleCount = state.peopleCount + 1
            self.peopleSlider.value = peopleSlider.value + 1
            if Int(peopleSlider.value) == 1{
                self.peopleLabel.text = "\(Int(peopleSlider.value)) person"
            }else{
                self.peopleLabel.text = "\(Int(peopleSlider.value)) people"
                
            }
        }
    }
    
    @IBAction func lessCost(sender: UIButton) {
        if state.hourlyRate > 0{
            self.state.hourlyRate = state.hourlyRate - 1
            self.hourlySlider.value = hourlySlider.value - 1
            self.hourlyLabel.text = "$\(Int(hourlySlider.value))/h"
        }
    
    }
    
    @IBAction func moreCost(sender: UIButton) {
        if state.hourlyRate < Int(hourlySlider.maximumValue) {
            self.state.hourlyRate = state.hourlyRate + 1
            self.hourlySlider.value = hourlySlider.value + 1
            self.hourlyLabel.text = "$\(Int(hourlySlider.value))/h"
        }
    }
    
    func updateTime(){
        var diff:NSTimeInterval = (NSDate.timeIntervalSinceReferenceDate() - startTime) - pausedTimeInterval
        if !isPaused {
            currentTime = diff.time
            timerLabel.text = "\(currentTime)"
            meeting.timeInSeconds = diff
            
            currentCost = calcCostPerHour(diff.costTime, people: Int(state.peopleCount), hourly: Int(state.hourlyRate))
//            Double(round(100*currentCost)/100)
            costLabel.text =  "$\(numberFormatter.stringFromNumber(currentCost)!)"
        }
        else if isPaused {
            pausedTimeInterval += CLOCK_INTERVAL
        }
    }
}

