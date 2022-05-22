//
//  TimerViewController.swift
//  Tekton_GoogleMaps
//
//  Created by Miguel on 21/05/22.
//

import Foundation
import UIKit

protocol TimerViewControllerDelegate {
    func starLocation()
    func stopLocation()
}

class TimerViewController: UIViewController {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var stopLabel: UILabel!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var timer:Timer = Timer()
    var timerCounting: Bool = false
    var seconds: Int = 0
    static let identifier = "TimerViewController"
    var delegate:TimerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyView.layer.cornerRadius = 24
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func starAction(_ sender: Any) {
        timerCounting = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerEvent), userInfo: nil, repeats: true)
        stopLabel.textColor = UIColor.orange
        starLabel.textColor = UIColor.gray
        starButton.isEnabled = false
        stopButton.isEnabled = true
        delegate?.starLocation()
    }
    
    @IBAction func stopAction(_ sender: Any) {
        timerCounting = false
        timer.invalidate()
        starLabel.textColor = UIColor.orange
        stopLabel.textColor = UIColor.gray
        starButton.isEnabled = true
        stopButton.isEnabled = false
        delegate?.stopLocation()
        self.dismiss(animated: true)
    }
    
    @objc func timerEvent() {
        seconds = seconds + 1
        let time = secondsToHoursMinutesSeconds(seconds: seconds)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        timerLabel.text = timeString
    }
    
    func secondsToHoursMinutesSeconds(seconds:Int) -> (Int,Int,Int) {
        return ((seconds / 3600),
                ((seconds % 3600) / 60),
                ((seconds % 3600) % 60)
        )
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds: Int ) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
       return timeString
    }
    
    
}
