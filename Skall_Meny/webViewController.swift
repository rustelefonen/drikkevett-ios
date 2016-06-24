//
//  webViewController.swift
//  Drikkevett
//
//  Created by Lars Petter Kristiansen on 10.05.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class webViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let rusTLFURL = NSURL(string: "http://www.rustelefonen.no")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Rename back button
        let backButton = UIBarButtonItem(
            title: "",
            style: UIBarButtonItemStyle.Plain, // Note: .Bordered is deprecated
            target: nil,
            action: nil
        )
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        self.navigationItem.title = "RUStelefonen.no"
        
        webView.delegate = self
        loadFirstAid()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(webView: UIWebView){
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
    }
    func webViewDidFinishLoad(webView: UIWebView){
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
    }
    
    func loadFirstAid(){
        webView.loadRequest(NSURLRequest(URL: rusTLFURL!))
    }
}

