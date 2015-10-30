//
//  AppDelegate.swift
//  HandyBar
//
//  Created by Matt Linebarger on 10/30/15.
//  Copyright © 2015 Squabash. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        let icon = NSImage(named: "statusIcon")
        icon?.template = true // ensures icon looks right in both light and dark mode
        
        statusItem.image = icon
        statusItem.menu = statusMenu
        
    }

    
    // Begin Finder Tasks ************************************************************
    
    // Toggle Hiddle Files Menu Item
    @IBAction func toggleHiddenFiles(sender: NSMenuItem) {
        
        let task = NSTask()
        task.launchPath = "/usr/bin/defaults/"
        
        if(sender.state == NSOnState) {
            sender.state = NSOffState
            task.arguments = ["write", "com.apple.finder", "AppleShowAllFiles", "NO"]
        } else {
            sender.state = NSOnState
            task.arguments = ["write", "com.apple.finder", "AppleShowAllFiles", "YES"]
        }
        
        task.launch()
        task.waitUntilExit()
        
        let killtask = NSTask()
        killtask.launchPath = "/usr/bin/killall"
        killtask.arguments = ["Finder"]
        killtask.launch()
        
    }
    
    // Restart Finder Menu Item
    @IBAction func restartFinder(sender: NSMenuItem) {
        
        NSAppleScript(source: "do shell script \"killall -KILL Finder\"")!.executeAndReturnError(nil)
        
    }
    
    // Restart Dock Menu Item
    @IBAction func restartDock(sender: NSMenuItem) {
        
        NSAppleScript(source: "do shell script \"killall -KILL Dock\"")!.executeAndReturnError(nil)
        
    }
    
    // Restart Menu Bar Menu Item
    @IBAction func restartMenubar(sender: NSMenuItem) {
        
        NSAppleScript(source: "do shell script \"killall -KILL SystemUIServer\"")!.executeAndReturnError(nil)
        
    }
    
    // Show/Copy Internal IP Address Menu Item
    @IBAction func showIntIP(sender: NSMenuItem) {
        let intIP = NSAppleScript(source: "do shell script \"junkIP=$(ifconfig | grep 'inet ' | grep -v 127.0.0.1);ipArr=(${junkIP// / });thisIP=${ipArr[1]};echo $thisIP\"")!.executeAndReturnError(nil).stringValue
        
        let notification = NSUserNotification()
        notification.title = "HandyBar"
        notification.informativeText = "Internal IP Address: " + intIP! + "\r\nAddress has been copied to the clipboard."
        notification.soundName = NSUserNotificationDefaultSoundName
        
        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
        
        let pasteboard = NSPasteboard.generalPasteboard()
        pasteboard.clearContents()
        pasteboard.setString(intIP!, forType: NSPasteboardTypeString)
 
    }
    
    // Show/Copy External IP Address Menu Item
    @IBAction func showExtIP(sender: NSMenuItem) {
        let extIP = NSAppleScript(source: "do shell script \"dig +short myip.opendns.com @resolver1.opendns.com\"")!.executeAndReturnError(nil).stringValue
        
        let notification = NSUserNotification()
        notification.title = "HandyBar"
        notification.informativeText = "External IP Address: " + extIP! + "\r\nAddress has been copied to the clipboard."
        notification.soundName = NSUserNotificationDefaultSoundName
        
        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
        
        let pasteboard = NSPasteboard.generalPasteboard()
        pasteboard.clearContents()
        pasteboard.setString(extIP!, forType: NSPasteboardTypeString)
        
    }
    // End Finder Tasks **************************************************************
    
    // Begin Apache Tasks ************************************************************
    
    // Start Apache Menu Item
    @IBAction func apacheStart(sender: NSMenuItem) {
        
        NSAppleScript(source: "do shell script \"sudo apachectl start\" with administrator privileges")!.executeAndReturnError(nil)
        
    }
    
    // Stop Apache Menu Item
    @IBAction func apacheStop(sender: NSMenuItem) {
        
        NSAppleScript(source: "do shell script \"sudo apachectl stop\" with administrator privileges")!.executeAndReturnError(nil)
        
    }
    
    // Restart Apache Menu Item
    @IBAction func apacheRestart(sender: NSMenuItem) {
        
        NSAppleScript(source: "do shell script \"sudo apachectl -k restart\" with administrator privileges")!.executeAndReturnError(nil)
        
    }
    // End Apache Tasks **************************************************************
    
    
    // Quit Menu Item
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    
}

