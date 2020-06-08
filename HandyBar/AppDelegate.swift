//
//  AppDelegate.swift
//  HandyBar
//
//  Created by Matt Linebarger on 10/30/15.
//  Copyright © 2020 Ransom Labs. All rights reserved.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true // ensures icon looks right in both light and dark mode
        
        statusItem.button?.image = icon
        statusItem.menu = statusMenu
        
    }
    
    
    // Begin Finder Tasks ************************************************************
    
    // Toggle Hiddle Files Menu Item
    @IBAction func toggleHiddenFiles(_ sender: NSMenuItem) {
        
        let task = Process()
        task.launchPath = "/usr/bin/defaults/"
        
        if(sender.state == NSControl.StateValue.on) {
            sender.state = NSControl.StateValue.off
            task.arguments = ["write", "com.apple.finder", "AppleShowAllFiles", "NO"]
        } else {
            sender.state = NSControl.StateValue.on
            task.arguments = ["write", "com.apple.finder", "AppleShowAllFiles", "YES"]
        }
        
        task.launch()
        task.waitUntilExit()
        
        let killtask = Process()
        killtask.launchPath = "/usr/bin/killall"
        killtask.arguments = ["Finder"]
        killtask.launch()
        
    }
    
    // Restart Finder Menu Item
    @IBAction func restartFinder(_ sender: NSMenuItem) {
        
        NSAppleScript(source: "do shell script \"killall -KILL Finder\"")!.executeAndReturnError(nil)
        
    }
    
    // Restart Dock Menu Item
    @IBAction func restartDock(_ sender: NSMenuItem) {
        
        NSAppleScript(source: "do shell script \"killall -KILL Dock\"")!.executeAndReturnError(nil)
        
    }
    
    // Restart Menu Bar Menu Item
    @IBAction func restartMenubar(_ sender: NSMenuItem) {
        
        NSAppleScript(source: "do shell script \"killall -KILL SystemUIServer\"")!.executeAndReturnError(nil)
        
    }
    
    // Show/Copy Internal IP Address Menu Item
    @IBAction func showIntIP(_ sender: NSMenuItem) {
        let intIP = NSAppleScript(source: "do shell script \"junkIP=$(ifconfig | grep 'inet ' | grep -v 127.0.0.1);ipArr=(${junkIP// / });thisIP=${ipArr[1]};echo $thisIP\"")!.executeAndReturnError(nil).stringValue
        
        let notification = NSUserNotification()
        notification.title = "HandyBar"
        notification.informativeText = "Internal IP Address: " + intIP! + "\r\nAddress has been copied to the clipboard."
        notification.soundName = NSUserNotificationDefaultSoundName
        
        NSUserNotificationCenter.default.deliver(notification)
        
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(intIP!, forType: NSPasteboard.PasteboardType.string)
        
    }
    
    // Show/Copy External IP Address Menu Item
    @IBAction func showExtIP(_ sender: NSMenuItem) {
        let extIP = NSAppleScript(source: "do shell script \"dig +short myip.opendns.com @resolver1.opendns.com\"")!.executeAndReturnError(nil).stringValue
        
        let notification = NSUserNotification()
        notification.title = "HandyBar"
        notification.informativeText = "External IP Address: " + extIP! + "\r\nAddress has been copied to the clipboard."
        notification.soundName = NSUserNotificationDefaultSoundName
        
        NSUserNotificationCenter.default.deliver(notification)
        
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(extIP!, forType: NSPasteboard.PasteboardType.string)
        
    }
    // End Finder Tasks **************************************************************
    
    // Begin Apache Tasks (Brew Version/Not Default Apache) **************************
    
    // Start Apache Menu Item
    @IBAction func apacheStart(_ sender: NSMenuItem) {
        
        NSAppleScript(source: "do shell script \"/usr/local/bin/apachectl start\"")!.executeAndReturnError(nil)
        
    }
    
    // Stop Apache Menu Item
    @IBAction func apacheStop(_ sender: NSMenuItem) {
        
        NSAppleScript(source: "do shell script \"/usr/local/bin/apachectl stop\"")!.executeAndReturnError(nil)
        
    }
    
    // Restart Apache Menu Item
    @IBAction func apacheRestart(_ sender: NSMenuItem) {
        
        NSAppleScript(source: "do shell script \"/usr/local/bin/apachectl restart\"")!.executeAndReturnError(nil)
        
    }
    // End Apache Tasks (Brew Version/Not Default Apache) ****************************
    
    
    // Quit Menu Item
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
}

