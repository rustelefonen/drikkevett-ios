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
    
    let rusTLFURL = URL(string: "http://www.rustelefonen.no")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Rename back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        self.navigationItem.title = "RUStelefonen.no"
        
        webView.delegate = self
        loadFirstAid()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func loadFirstAid(){
        webView.loadRequest(URLRequest(url: rusTLFURL!))
    }
}

