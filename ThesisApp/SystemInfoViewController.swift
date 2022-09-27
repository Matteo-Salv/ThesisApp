//
//  SystemInfoViewController.swift
//  ThesisApp
//
//  Created by Matteo Salvatore on 27/09/22.
//

import UIKit

//per ottenere la versione precisa di iPhone. https://gist.github.com/adamawolf/3048717. Versioni non supportate non presenti nel file deviceVersions.txt
extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}

class SystemInfoViewController: UIViewController {
    @IBOutlet var deviceNameLabel: UILabel!
    @IBOutlet var osLabel: UILabel!
    @IBOutlet var osVersionLabel: UILabel!
    @IBOutlet var modelLabel: UILabel!
    @IBOutlet var uuidLabel: UILabel!
    @IBOutlet var cpuLabel: UILabel!
    @IBOutlet var memoryLabel: UILabel!
    @IBOutlet var uptimeLabel: UILabel!
    
    var modelName: [String: String] = [:]
    
    func readModelNames() {
        if let path = Bundle.main.path(forResource: "deviceVersions", ofType: "txt"){
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let stringLineByLine = data.components(separatedBy: .newlines)
                for line in stringLineByLine{
                    let tmpData = line.components(separatedBy: "#")
                    if tmpData.capacity == 2{
                        modelName.updateValue(tmpData[1], forKey: tmpData[0])
                    }
                }
                
            } catch{
                print("error: unable to parse deviceVersions.txt file")
            }
        }else{
            print("unable to find txt file")
        }
    }
    
    func uptime() -> time_t {
        var boottime = timeval()
        var mib: [Int32] = [CTL_KERN, KERN_BOOTTIME]
        var size = MemoryLayout<timeval>.stride

        var now = time_t()
        var uptime: time_t = -1

        time(&now)
        if (sysctl(&mib, 2, &boottime, &size, nil, 0) != -1 && boottime.tv_sec != 0) {
            uptime = now - boottime.tv_sec
        }
        return uptime
    }
    
    func secToDaysMinsAndHours(secs: time_t) -> String {
        let days = Int(secs/86400)
        let hours = Int((secs%86400)/3600)
        let mins = Int(((secs%86400)%3600)/60)
        return "\(days) days, \(hours) hours, \(mins) mins"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readModelNames()
        super.viewWillAppear(animated)
        deviceNameLabel.text = UIDevice.current.name
        osLabel.text = UIDevice.current.systemName
        osVersionLabel.text = UIDevice.current.systemVersion
        if let model = modelName[UIDevice.current.modelName]{
            modelLabel.text = model
        }else{
            print(modelName)
            modelLabel.text = UIDevice.current.modelName
        }
        uuidLabel.text = UIDevice.current.identifierForVendor?.uuidString
        UIDevice.current.isBatteryMonitoringEnabled = true
        cpuLabel.text = String(ProcessInfo().processorCount)
        memoryLabel.text = String(ProcessInfo().physicalMemory)
        uptimeLabel.text = secToDaysMinsAndHours(secs: uptime())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func orientationButton(_ sender: UIButton) {
        var message: String
        if UIDevice.current.orientation.isPortrait{
            message = "you are currently in portrait mode"
        }else{
            message = "you are currently in landscape mode"
        }
        let alert = UIAlertController(title: "Current Orientation", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        self.present(alert, animated: true)
    }
    
    @IBAction func batteryStatusButton(_ sender: UIButton) {
        var message: String
        var title: String
        if UIDevice.current.isBatteryMonitoringEnabled{
            if UIDevice.current.batteryState != .charging{
                if UIDevice.current.batteryLevel < 0.2{
                    message = "battery below 20%! Charge your iPhone!"
                }else if UIDevice.current.batteryLevel > 0.8{
                    message = "your iPhone is charged. To preserve the battery, unplug the device"
                }else{
                    message = "your iPhone is fine. To preserve the battery don't charge below 20% and over 80%"
                }
            }else{
                message = "charging in progress..."
            }
            title = "Battery at \(Int(UIDevice.current.batteryLevel*100))%"
        }else{
            title = "Error!"
            message = "battery monitoring disabled!"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        self.present(alert, animated: true)
    }
}
