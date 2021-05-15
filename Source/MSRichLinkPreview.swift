//
//  MSRichLinkPreview.swift
//  MSRichLinkPreview
//
//  Created by Apple on 02/05/21.
//

import Kanna

class MyError: Error {
    
}

// MARK: - Method
public func getHTML(url: String, completion: @escaping(_ result: Result<MSLinkMetaData, Error>) -> Void) {
    
    var mSLinkMetaData: MSLinkMetaData = MSLinkMetaData()
    var http: String {
        get {
            return url.contains("https") ? "https://" : "http://"
        }
    }
    var urlHost: String {
        get {
            return URL(string: url)?.host ?? ""
        }
    }
    
    getHTMLData(url: url) { (result) in
        switch result {
        case .success(let data):
            if let doc = try? HTML(html: data, encoding: .utf8) {
                
                // MARK: - Title
                if mSLinkMetaData.title.isEmpty,
                   let meta = doc.xpath("//meta[@property='og:title']").first {
                    mSLinkMetaData.title = meta["content"] ?? ""
                }
                if mSLinkMetaData.title.isEmpty,
                   let meta = doc.xpath("//meta[@name='twitter:title']").first {
                    mSLinkMetaData.title = meta["content"] ?? ""
                }
                if mSLinkMetaData.title.isEmpty {
                    mSLinkMetaData.title = doc.title ?? ""
                }
                
                
                // MARK: - Description
                if mSLinkMetaData.description.isEmpty,
                   let meta = doc.xpath("//meta[@property='og:description']").first {
                    mSLinkMetaData.description = meta["content"] ?? ""
                }
                if mSLinkMetaData.description.isEmpty,
                   let meta = doc.xpath("//meta[@name='twitter:description']").first {
                    mSLinkMetaData.description = meta["content"] ?? ""
                }
                if mSLinkMetaData.description.isEmpty,
                   let meta = doc.xpath("//meta[@name='description']").first {
                    mSLinkMetaData.description = meta["content"] ?? ""
                }
                
                
                // // MARK: - URL
                if mSLinkMetaData.url.isEmpty,
                   let meta = doc.xpath("//meta[@property='og:url']").first {
                    mSLinkMetaData.url = meta["content"] ?? ""
                }
                if mSLinkMetaData.url.isEmpty,
                   let meta = doc.xpath("//link[@rel='canonical']").first {
                    mSLinkMetaData.url = meta["href"] ?? ""
                }
                
                
                // MARK: - Image
                if mSLinkMetaData.imageUrl.isEmpty,
                   let meta = doc.xpath("//meta[@property='og:image']").first {
                    mSLinkMetaData.imageUrl = meta["content"] ?? ""
                }
                if mSLinkMetaData.imageUrl.isEmpty,
                   let meta = doc.xpath("//link[@rel='image_src']").first {
                    mSLinkMetaData.imageUrl = meta["href"] ?? ""
                }
                if mSLinkMetaData.imageUrl.isEmpty,
                   let meta = doc.xpath("//meta[@name='twitter:image']").first {
                    mSLinkMetaData.imageUrl = meta["content"] ?? ""
                }
                
                if mSLinkMetaData.imageUrl.isEmpty,
                   !mSLinkMetaData.imageUrl.contains(urlHost),
                   !mSLinkMetaData.imageUrl.contains("http") {
                    
                    mSLinkMetaData.imageUrl = http + urlHost + mSLinkMetaData.imageUrl
                }
                
                
                // MARK: - SiteName
                if mSLinkMetaData.siteName.isEmpty,
                   let meta = doc.xpath("//meta[@property='og:site_name']").first {
                    mSLinkMetaData.siteName = meta["content"] ?? ""
                }
                
                
                // MARK: - MediaType
                if mSLinkMetaData.mediaType.isEmpty,
                   let meta = doc.xpath("//meta[@property='og:type']").first {
                    mSLinkMetaData.mediaType = meta["content"] ?? ""
                }
                if mSLinkMetaData.mediaType.isEmpty,
                   let meta = doc.xpath("//meta[@name='medium']").first {
                    mSLinkMetaData.mediaType = meta["content"] ?? ""
                }
                
                
                // MARK: - FavIcon
                if mSLinkMetaData.favIcon.isEmpty ,
                   let meta = doc.xpath("//link[@rel='icon']").first {
                    mSLinkMetaData.favIcon = meta["href"] ?? ""
                }
            }
            
            completion(.success(mSLinkMetaData))
            
            
        case .failure(let error):
            completion(.failure(error))
            
        }
    }
}

// MARK: - API
private func getHTMLData(url: String, completion: @escaping(_ result: Result<Data, Error>) -> Void) {
    
    if let url = URL(string: url) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36",
                         forHTTPHeaderField: "User-Agent")
        request.setValue("text/html,application/xhtml+xml,application/xml",
                         forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Error
                completion(.failure(error))
                
            } else {
                // Success
                completion(.success(data ?? Data()))
                
            }
        }.resume()
    } else {
        completion(.failure(MyError()))
    }
}
