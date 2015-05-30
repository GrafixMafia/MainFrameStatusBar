//
//  AppDelegate.swift
//  HackSpaceStatusBar
//
//  Created by markus on 26.07.14.
//  Copyright (c) 2014 grafixmafia.net. All rights reserved.
//

import Cocoa
import ApplicationServices

public class AppDelegate: NSObject, NSApplicationDelegate {
                            
  
    @IBOutlet weak var menu: NSMenu!
    
    @IBOutlet weak var about: NSWindow!
    
    @IBOutlet weak var prefs: PreferencePane!
    @IBOutlet weak var details: StatusDetails!
    
    var statusItem: NSStatusItem!
    var timer : NSTimer = NSTimer()
    
    var mainFrameStatus : StatusHandler?
    
    var defaultPrefs : NSDictionary!
    public var state : NSMutableDictionary!
    
    var userDefault : NSUserDefaults!
    
    override public func awakeFromNib()  {
       //  var myInt = NSInteger(NSVariableStatusItemLength)
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(CGFloat(-2))

        statusItem.menu = menu

        statusItem.highlightMode = true
        
        mainFrameStatus = StatusHandler()
        
        state = NSMutableDictionary(object: "hallo", forKey: "website")
        
        self.userDefault = NSUserDefaults.standardUserDefaults()
        
        if let defaultPrefLoaded = userDefault.objectForKey("defaultPrefLoaded") as? Bool {
            var defaultPrefsFile = NSBundle.mainBundle().URLForResource("DefaultPreferences", withExtension: "plist")
            self.defaultPrefs = NSDictionary(contentsOfURL: defaultPrefsFile!)

            if(defaultPrefLoaded) {
                self.defaultPrefs = NSDictionary(contentsOfURL: defaultPrefsFile!)
                self.defaultPrefs.writeToFile("\(NSHomeDirectory())/file.plist", atomically: true)            
            } else {
                self.userDefault.setObject(self.defaultPrefs, forKey: "defaultPrefs")
                self.userDefault.setObject(true, forKey: "defaultPrefLoaded")
                self.defaultPrefs.writeToFile("\(NSHomeDirectory())/file.plist", atomically: true)
            }
        } else {
            // self.userDefault.setObject(self.defaultPrefs, forKey: "defaultPrefs")
            // self.defaultPrefs.writeToFile("\(NSHomeDirectory())/file.plist", atomically: true)
            userDefault.setObject(true, forKey: "defaultPrefLoaded")
        }
        userDefault.setObject(false, forKey: "defaultPrefLoaded")
        userDefault.synchronize()
        
        // prefs.getListofSpaces()
    }
    
    @IBAction func quit(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(nil)
    }

    
    public func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        statusItem.title = mainFrameStatus?.status as? String
        
        if timer.valid {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateStatus"), userInfo: nil, repeats: true)
    }
    
    func updateStatus() {
        self.statusItem.title = self.mainFrameStatus?.status as? String
    }
    
    public func applicationWillFinishLaunching(notification: NSNotification) {
        
        var showDock = self.defaultPrefs.valueForKey("showDockIcon") as! Bool
       // self.prefs.setDefaultSettings(self.userDefault.valueForKey("defaultPrefs") as NSDictionary)
        
        var NSApp: NSApplication = NSApplication.sharedApplication()
        if(showDock){
           NSApp.setActivationPolicy(NSApplicationActivationPolicy.Regular)
        } else {
            NSApp.setActivationPolicy(NSApplicationActivationPolicy.Accessory)
        }
    }
    
    public func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        
    }

    @IBAction func showDetailsView(sender: AnyObject) {
        NSApp.activateIgnoringOtherApps(true)
        details.center()
        details.makeKeyAndOrderFront(nil)
    }
    
    @IBAction func showAboutView(sender: AnyObject) {
        NSApp.activateIgnoringOtherApps(true)
        about.center()
        about.makeKeyAndOrderFront(nil)
    }
    
    @IBAction func showPrefView(sender: AnyObject) {
        NSApp.activateIgnoringOtherApps(true)
        prefs.center()
        prefs.makeKeyAndOrderFront(nil)
    }
    
    @IBAction func refresh(sender: AnyObject) {
        self.statusItem.title = self.mainFrameStatus?.status as? String
    }
}

