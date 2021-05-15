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
    
    // MARK: - UIElements
    @IBOutlet weak var tfUrl: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    
    @IBOutlet weak var viewOuter: UIView!
    @IBOutlet weak var viewInner: UIView!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lblSiteName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var tvOutput: UITextView!
    
    // MARK: - Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfUrl.delegate = self
        viewOuter.isHidden = true
        
        viewInner.layer.cornerRadius = 8
        viewOuter.layer.cornerRadius = 8
        viewOuter.layer.shadowColor = UIColor.gray.cgColor
        viewOuter.layer.shadowOffset = .zero
        viewOuter.layer.shadowRadius = 8
        viewOuter.layer.shadowOpacity = 0.3
    }
    
    // MARK: - Click events
    @IBAction func btnSearchClick(_ sender: UIButton) {
        self.view.endEditing(true)
        getMetaData()
    }
    
    // MARK: - Methods
    func getMetaData() {
        getHTML(url: tfUrl.text ?? "") { (result) in
            
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.ivImage.image = nil
                    
                    self.lblSiteName.text = data.siteName
                    self.lblTitle.text = data.title
                    
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
                
                self.getImage(imageUrl: data.imageUrl) { (image) in
                    
                    DispatchQueue.main.async {
                        self.ivImage.image = image
                        self.viewOuter.isHidden = self.ivImage.image == nil
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.viewOuter.isHidden = true
                    self.tvOutput.text = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func getImage(imageUrl: String, completion: @escaping(_ result: UIImage?) -> Void) {
        if let imageUrl = URL(string: imageUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl) {
                    completion(UIImage(data: data))
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        getMetaData()
        return true
    }
}
