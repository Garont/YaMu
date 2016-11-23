//
//  ViewController.swift
//  YaMu
//
//  Created by Roman Shkurov on 11/16/16.
//  Copyright © 2016 Roman Shkurov. All rights reserved.
//

import Cocoa
import WebKit
import Foundation

@discardableResult
func shell(launchPath: String, arguments: [String] = []) -> (String?, Int32) {
    let task = Process()
    task.launchPath = launchPath
    task.arguments = arguments
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: String.Encoding.utf8)
    task.waitUntilExit()
    return (output, task.terminationStatus)
}

class ViewController: NSViewController {
    
    @IBOutlet weak var WebKitAudioLabel: NSTextField!
    @IBOutlet weak var webView: WebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isWebkitAudioEnabled = shell(launchPath: "/usr/bin/defaults", arguments: ["read", "com.tj.YaMu", "WebKitWebAudioEnabled"]).0
        if (isWebkitAudioEnabled == "0\n") {
            shell(launchPath: "/usr/bin/defaults", arguments: ["write", "com.tj.YaMu", "WebKitWebAudioEnabled", "-bool", "yes"])
            WebKitAudioLabel.stringValue = "Webkit audio is currently disabled. Please relaunch the application."
        }else{
            WebKitAudioLabel.isHidden = true
        }
        
        let request = URLRequest(url: URL(string: "https://music.yandex.ua")!);
        webView.customUserAgent = "YaMu Client v0.1";
        self.webView.mainFrame.load(request);
        
        
    }


    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

