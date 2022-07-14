//
//  WebViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 7/14/22.
//

import UIKit
import WebKit
import SnapKit

class WebViewController: UIViewController {

    convenience init(urlString: String) {
        self.init()
        self.urlString = urlString
    }
    private var urlString: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let urlString = urlString else { return }
        view.backgroundColor = .white
        loadURL(urlString: urlString)
    }
    
    private func loadURL(urlString: String) {
        let url = URL(string: urlString)
        if let url = url {
            let request = URLRequest(url: url)
            let webView = WKWebView()
            webView.navigationDelegate = self
            webView.load(request)
            
            view.addSubview(webView)
            view.sendSubviewToBack(webView)
            webView.snp.makeConstraints { make in
                make.top.equalTo(view.snp_topMargin)
                make.left.equalTo(view)
                make.bottom.equalTo(view.snp_bottomMargin)
                make.right.equalTo(view)
            }
        }
    }
}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
//        view.addSubview(loadingAnimationView)
//        loadingAnimationView.center(inView: view)
//        loadingAnimationView.setDimensions(width: UIScreen.width * 0.6, height: UIScreen.width * 0.6)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
//        LottieAnimation.shared.stopAnimation(lottieAnimation: loadingAnimationView)
//        loadingAnimationView.removeFromSuperview()
    }
}
