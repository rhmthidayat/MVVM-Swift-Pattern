//
//  DetailNewsViewController.swift
//  mvvm
//
//  Created by Rahmat Hidayat on 31/01/19.
//  Copyright © 2019 Rahmat. All rights reserved.
//

import UIKit

class DetailNewsViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDateBy: UILabel!
    @IBOutlet weak var imgNews: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    
    var article: Article!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showArticle()
    }
    
    func showArticle() {
        if let article = self.article {
            self.lblTitle.text = article.title ?? ""
            self.imgNews.loadImageUsingCacheWithUrlString(article.urlToImage ?? "")
            var dateBy = ""
            if let date = article.publishedAt {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateBy = dateFormatter.string(from: date) + " by \(article.author ?? "")"
            }else{
                dateBy = "- by \(article.author ?? "")"
            }
            self.lblDateBy.text = dateBy
            self.lblDesc.text = article.description ?? ""
        }
    }

}
