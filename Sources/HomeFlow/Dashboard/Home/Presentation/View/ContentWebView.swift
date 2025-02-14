//
//  ContentWebView.swift
//
//  Created by Ilham Hadi Prabawa on 23/03/22.
//

import UIKit
@preconcurrency import WebKit
import Combine

public class ContentWebView: UIView {
  
  private let htmlText: String
  
  let progressView: UIProgressView = {
    let pv = UIProgressView(backgroundColor: .clear)
    pv.translatesAutoresizingMaskIntoConstraints = false
    return pv
  }()
  
  let activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .medium)
    indicator.hidesWhenStopped = true
    return indicator
  }()
  
  private var observation: NSKeyValueObservation? = nil
  
  public var didGetHeight: ((CGFloat) -> Void)?
  
  private var subscriptions = Set<AnyCancellable>()
  
  //MARK: - Views
  lazy public var webView: WKWebView = {
    let webViewConfiguration = WKWebViewConfiguration()
    webViewConfiguration.allowsInlineMediaPlayback = false
    webViewConfiguration.allowsPictureInPictureMediaPlayback = true
    let webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
    webView.scrollView.isScrollEnabled = true
    webView.navigationDelegate = self
    return webView
  }()
  
  let scrollView: UIScrollView = {
    let sv = UIScrollView()
    sv.showsVerticalScrollIndicator = false
    return sv
  }()
  
  let contentView: UIView = {
    let view = UIView()
    return view
  }()
  
  public init(htmlText: String) {
    self.htmlText = htmlText
    super.init(frame: .zero)
    setupView()
    
    activityIndicator.startAnimating()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Setup Layout
  public func setupView() {
    
    addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(activityIndicator)
    contentView.addSubview(webView)
    
    scrollView.snp.makeConstraints { (make) in
      make.top.equalTo(safeAreaLayoutGuide.snp.top)
      make.leading.equalTo(snp.leading)
      make.trailing.equalTo(snp.trailing)
      make.bottom.equalTo(snp.bottom)
    }
    
    contentView.snp.makeConstraints { (make) in
      make.top.bottom.equalTo(scrollView)
      make.leading.equalTo(snp.leading)
      make.trailing.equalTo(snp.trailing)
    }
    
    activityIndicator.snp.makeConstraints { make in
      make.centerX.equalTo(contentView)
      make.centerY.equalTo(contentView).offset(50)
    }
    
    webView.snp.makeConstraints { (make) in
      make.top.equalTo(contentView).offset(20)
      make.leading.trailing.equalTo(contentView).inset(8)
    }
    
    webView.backgroundColor = UIColor.init(
      red: 247/255,
      green: 247/255,
      blue: 247/255,
      alpha: 1.0
    )
    
    setHTMLContent()
    
  }
  
  public func setHTMLContent() {
    let htmlCode = """
            <html>
                <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <meta charset="UTF-8">
                    <style>
                        body {
                            font-family: -apple-system, DMSans;
                            background-color: white;
                            padding: 0px;
                            box-sizing: border-box;
                        }
      
                        h1 {
                            color: #007AFF;
                            text-align: left;
                            margin-bottom: 20px;
                        }
      
                        p {
                            font-size: 16px;
                            color: #333333;
                            text-align: left;
                            margin-bottom: 20px;
                        }
      
                        img {
                            max-width: 100%;
                            height: auto;
                        }
      
                    </style>
                </head>
                      <body>
                      \(htmlText)
                      </body>
            </html>
      """
    
    webView.loadHTMLString(htmlText, baseURL: nil)
  }
  
  private func setupApprovedView() {
    addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(webView)
    
    scrollView.snp.makeConstraints { (make) in
      make.top.equalTo(safeAreaLayoutGuide.snp.top)
      make.leading.equalTo(snp.leading)
      make.trailing.equalTo(snp.trailing)
      make.bottom.equalTo(snp.bottom)
    }
    
    contentView.snp.makeConstraints { (make) in
      make.top.bottom.equalTo(scrollView)
      make.leading.equalTo(snp.leading)
      make.trailing.equalTo(snp.trailing)
    }
    
    webView.snp.makeConstraints { (make) in
      make.top.equalTo(contentView).offset(20)
      make.leading.trailing.equalTo(contentView).inset(8)
    }
    
    webView.backgroundColor = UIColor.init(
      red: 247/255,
      green: 247/255,
      blue: 247/255,
      alpha: 1.0
    )
    
    setHTMLContent()
  }
  
  private func setupCheckboxLabel() {
    let text = "Saya telah membaca dan menyetujui surat perjanjian kerjasama"
    
    let textAttributed = NSMutableAttributedString(
      string: text,
      attributes: [
        NSAttributedString.Key.font: UIFont.dmSansFont(style: .caption(size: 14)),
        NSAttributedString.Key.foregroundColor: UIColor.lightTextColor.cgColor
      ]
    )
    
    let boldRange = (text as NSString).range(of: "telah membaca dan menyetujui")
    textAttributed.addAttributes(
      [
        NSAttributedString.Key.foregroundColor: UIColor.darkTextColor.cgColor,
        NSAttributedString.Key.font: UIFont.dmSansFont(style: .title(size: 14))
      ],
      range: boldRange
    )
    
  }
  
  private func observer() {}
  
}

extension ContentWebView: WKNavigationDelegate{
  
  public func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
  ) {
    decisionHandler(WKNavigationActionPolicy.allow)
  }
  
  public func webView(
    _ webView: WKWebView,
    didFinish navigation: WKNavigation!
  ) {
    
    let javascriptStyle = "var css = '*{-webkit-touch-callout:none;-webkit-user-select:none}'; var head = document.head || document.getElementsByTagName('head')[0]; var style = document.createElement('style'); style.type = 'text/css'; style.appendChild(document.createTextNode(css)); head.appendChild(style);"
    
    webView.evaluateJavaScript(javascriptStyle, completionHandler: nil)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.webView.snp.makeConstraints { (make) in
        make.height.equalTo(webView.scrollView.contentSize.height)
        make.bottom.equalTo(self.contentView).offset(-138)
      }
    }
    
    activityIndicator.stopAnimating()
  }
  
}
