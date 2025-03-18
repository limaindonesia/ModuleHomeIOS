//
//  LegalFormDocumentViewerViewController.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 11/03/25.
//

import Foundation
import UIKit
import PDFKit
import GnDKit

public class LegalFormDocumentViewerViewController: NiblessViewController {
  
  //Dependency
  private let pdfURL: URL?
  
  private var pdfView: PDFView!
  
  let dateLabel: UILabel = {
    let lbl = UILabel()
    lbl.text = "Dibuat pada Selasa, 29-1-2024, 14.00"
    lbl.font = .lexendFont(style: .caption(size: 14))
    lbl.numberOfLines = 2
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()
  
  lazy var downloadButton: UIButton = {
    let attributedString = NSAttributedString(
      string: "Unduh",
      attributes: [
        .font: UIFont.lexendFont(style: .title(size: 14)),
        .foregroundColor: UIColor.buttonActiveColor
      ]
    )
    let btn = UIButton(type: .system)
    btn.setAttributedTitle(attributedString, for: .normal)
    btn.addTarget(self, action: #selector(downloadAction), for: .touchUpInside)
    btn.translatesAutoresizingMaskIntoConstraints = false
    return btn
  }()
  
  let infoView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.roundCorners([.topLeft, .topRight], value: 8)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  public init(pdfURL: URL?) {
    self.pdfURL = pdfURL
    
    super.init()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    standardNavBar(title: "Detail Dokumen")
    view.backgroundColor = .gray100
    
    setupView()
    setupPDFView()
    loadRemotePDF(from: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf")
  }
  
  private func setupView() {
    view.addSubview(infoView)
    infoView.addSubview(dateLabel)
    infoView.addSubview(downloadButton)
    
    infoView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
      make.leading.equalTo(view.snp.leading).offset(8)
      make.trailing.equalTo(view.snp.trailing).offset(-8)
      make.height.equalTo(40)
    }
    
    dateLabel.snp.makeConstraints { make in
      make.centerY.equalTo(infoView.snp.centerY)
      make.leading.equalTo(infoView.snp.leading).offset(8)
      make.trailing.equalTo(downloadButton.snp.leading).offset(8)
    }
    
    downloadButton.snp.makeConstraints { make in
      make.centerY.equalTo(infoView.snp.centerY)
      make.trailing.equalTo(infoView.snp.trailing).offset(-8)
    }

  }
  
  private func setupPDFView() {
    pdfView = PDFView(frame: view.bounds)
    pdfView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(pdfView)
    
    pdfView.snp.makeConstraints { make in
      make.top.equalTo(infoView.snp.bottom)
      make.leading.equalTo(view.snp.leading).offset(8)
      make.trailing.equalTo(view.snp.trailing).offset(-8)
      make.bottom.equalTo(view.snp.bottom).offset(-8)
    }
  }
  
  private func loadRemotePDF(from urlString: String) {
    guard let url = URL(string: urlString) else { return }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, error == nil else {
        print("Failed to download PDF: \(error?.localizedDescription ?? "Unknown error")")
        return
      }
      
      DispatchQueue.main.async {
        if let pdfDocument = PDFDocument(data: data) {
          self.pdfView.document = pdfDocument
        } else {
          print("Failed to create PDF document")
        }
      }
    }
    
    task.resume()
  }
  
  @objc
  func downloadAction() {
    
  }
  
}
