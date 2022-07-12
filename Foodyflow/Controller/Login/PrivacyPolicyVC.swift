//
//  PrivacyPolicyVC.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 7/12/22.
//

import UIKit
import WebKit



class PrivacyPolicyVC: UIViewController, WKNavigationDelegate {
    
    let fullScreenSize = UIScreen.main.bounds.size
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left")?
                .withTintColor(UIColor.darkGray)
                .withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(didTapClose)
        )
        
        // style
        view.backgroundColor = .white
        title = "隱私權政策"
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: fullScreenSize.width, height: fullScreenSize.height))
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        self.start()
    }
    
    @objc func start() {
        self.view.endEditing(true)
        
        let url = URL(string: "https://www.privacypolicies.com/live/f47437a1-9d69-4959-bebe-f50c1928bcaf")
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}
