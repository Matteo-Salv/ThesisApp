//
//  ProtectedResourcesViewController.swift
//  ThesisApp
//
//  Created by Matteo Salvatore on 14/09/22.
//

import UIKit
import CoreBluetooth
import EventKit
import Contacts
import CoreLocation

class ProtectedResourcesViewController: UIViewController, CBCentralManagerDelegate, CLLocationManagerDelegate {
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var bluetoothButton: UIButton!
    @IBOutlet var calendarButton: UIButton!
    @IBOutlet var contactsButton: UIButton!
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var deniedAuthLabel: UILabel!
    
    var centralManager: CBCentralManager?
    var deniedAuthorizations = "Authorization denied for:"
    var isDeniedAuth = false
    var peripheral: CBPeripheral?
    let eventStore = EKEventStore()
    let contactStore = CNContactStore()
    let locationManager = CLLocationManager()
    
    //richiamato da centralManager ogni volta che il bluetooth cambia stato (ereditato da CBCentralManagerDelegate)
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch CBManager.authorization{
            
        case .notDetermined: break
        case .restricted: break
        case .denied, .allowedAlways:
            checkRequestsStatus()
        @unknown default: break
        }
    }
    
    // richiamato da locationManager ogni volta che cambia autorizzazione la localizzazione (ereditato da CLLocationManagerDelegate)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
        case .notDetermined: break
        case .restricted: break
        case .denied, .authorizedAlways, .authorizedWhenInUse:
            checkRequestsStatus()
        @unknown default: break
        }
    }
    
    func checkRequestsStatus(){
        //Location
        if locationManager.authorizationStatus == .authorizedWhenInUse{
            locationButton.isEnabled = false
        }else if locationManager.authorizationStatus == .denied{
            locationButton.isEnabled = false
            deniedAuthorizations = deniedAuthorizations + "\nLocation"
            isDeniedAuth = true
        }
        
        //Bluetooth
        if CBManager.authorization == .allowedAlways{
            bluetoothButton.isEnabled = false
        }else if CBManager.authorization == .denied{
            bluetoothButton.isEnabled = false
            deniedAuthorizations = deniedAuthorizations + "\nBluetooth"
            isDeniedAuth = true
        }
        
        //Contacts
        if CNContactStore.authorizationStatus(for: .contacts) == .authorized{
            contactsButton.isEnabled = false
        }else if CNContactStore.authorizationStatus(for: .contacts) == .denied{
            contactsButton.isEnabled = false
            deniedAuthorizations = deniedAuthorizations + "\nContacts"
            isDeniedAuth = true
        }
        
        //Calendar
        if EKEventStore.authorizationStatus(for: .event) == .authorized{
            calendarButton.isEnabled = false
        }else if EKEventStore.authorizationStatus(for: .event) == .denied{
            calendarButton.isEnabled = false
            deniedAuthorizations = deniedAuthorizations + "\nCalendar"
            isDeniedAuth = true
        }
        
        if !calendarButton.isEnabled && !contactsButton.isEnabled && !bluetoothButton.isEnabled && !locationButton.isEnabled && !isDeniedAuth {
            statusLabel.text = "All requests have been granted. In order to test again this part, you must go to 'Settings > General > Reset > Reset Location & Privacy' or reinstall the app"
            statusLabel.textColor = .systemGreen
        }else{
            statusLabel.text = "if a button is disabled (greyed out) it means that the corresponding authorization request already took place."
        }
        
        if(isDeniedAuth){
            deniedAuthLabel.text = deniedAuthorizations
            deniedAuthorizations = "Authorization denied for:"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkRequestsStatus()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //bluetooth
    //vedi funzione centralManagerDidUpdateState
    @IBAction func bluetoothPressed(_ sender: Any) {
        centralManager = CBCentralManager(delegate: self, queue: nil)   //delegate = oggetto che deve ricevere gli aggiornamenti
    }
    
    //calendar
    @IBAction func calendarsPressed(_ sender: Any) {
        checkRequestsStatus()
        //task: obbligatorio per effettuare codice async in un contesto non async
        Task{
            do{
                try await eventStore.requestAccess(to: .event)
            }catch{
                print(error)
            }
            checkRequestsStatus()
        }
        
    }
    
    //contacts
    @IBAction func contactsPressed(_ sender: Any) {
        Task{
            do{
                try await contactStore.requestAccess(for: .contacts)
            }catch{
                print(error)
            }
            checkRequestsStatus()
        }
    }
    
    //location
    //vedi funzione locationManagerDidChangeAuthorization
    @IBAction func locationPressed(_ sender: Any) {
        locationManager.delegate = self //obbligatorio, indica l'oggetto che dovrà ricevere gli aggiornamenti
        locationManager.requestWhenInUseAuthorization()
    }
}
