//
//  ViewController.swift
//  GrantPermissionScriptSample
//
//  Created by Nico Prananta on 7/11/16.
//  Copyright © 2016 DelightfulDev. All rights reserved.
//

import UIKit
import Photos
import AddressBook
import HomeKit
import EventKit


class ViewController: UIViewController, HMHomeManagerDelegate {

    @IBOutlet weak var label: UILabel!
    var homeManager: HMHomeManager?
    
    func extractABAddressBookRef(abRef: Unmanaged<ABAddressBookRef>!) -> ABAddressBookRef? {
        if let ab = abRef {
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
        }
        return nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapPhotos(sender: AnyObject) {
        let result = getFetchResult()
        if result.count > 0 {
            PHImageManager.defaultManager().requestImageForAsset(result.objectAtIndex(0) as! PHAsset, targetSize: CGSizeMake(100,100), contentMode: .AspectFit, options: nil, resultHandler: { (image, dict) in
                if (image != nil) {
                    self.label.text = "Photos granted"
                }
            })
        }
        
    }
    @IBAction func didTapAddress(sender: AnyObject) {
        var errorRef: Unmanaged<CFError>? = nil
        ABAddressBookRequestAccessWithCompletion(extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef)), { success, error in
            if success {
                self.label.text = "Address granted"
            }
            else {
                print("error")
            }
        })
        
    }
    @IBAction func didTapCalendar(sender: AnyObject) {
        let eventStore = EKEventStore()
        eventStore.requestAccessToEntityType(.Event) { (accessGranted, error) in
            self.label.text = "Calendar granted"
        }
    }
    @IBAction func didTapHomeKit(sender: AnyObject) {
        homeManager = HMHomeManager()
        homeManager!.delegate = self
    }
    
    func getFetchResult() -> PHFetchResult {
        return PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
    }
    
    func homeManagerDidUpdateHomes(manager: HMHomeManager) {
        label.text = "Homekit granted"
    }

}

