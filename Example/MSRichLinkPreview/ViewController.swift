//
//  ViewController.swift
//  MSRichLinkPreview
//
//  Created by Mayur312 on 05/02/2021.
//  Copyright (c) 2021 Mayur312. All rights reserved.
//

import UIKit
import MSRichLinkPreview

class ViewController: UIViewController {
    
    // MARK: - Variables
    let mSRichLinkPreview = MSRichLinkPreview()
    
    // MARK: - UIElements
    @IBOutlet weak var tfUrl: UITextField!
    @IBOutlet weak var btnGetData: UIButton!
    @IBOutlet weak var tvOutput: UITextView!
    
    // MARK: - Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvOutput.isEditable = false
        tvOutput.dataDetectorTypes = .all
        
    }

    // MARK: - view events
    @IBAction func btnGetDataCilck(_ sender: UIButton) {
        mSRichLinkPreview.getHTML(url: tfUrl.text ?? "") { (result) in
            
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.tvOutput.text = """
                        Title: \(data.title)
                        
                        Description: \(data.description)
                        
                        SiteName: \(data.siteName)
                        
                        Url: \(data.url)
                        
                        ImageUrl: \(data.imageUrl)
                        
                        MediaType: \(data.mediaType)
                        
                        FavIcon: \(data.favIcon)
                        """
                }
                
            case .failure(let error):
                self.tvOutput.text = "Error: \(error.localizedDescription)"
            }
        }
    }
}
