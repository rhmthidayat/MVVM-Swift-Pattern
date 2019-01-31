//
//  NewsViewController.swift
//  mvvm
//
//  Created by Rahmat Hidayat on 29/01/19.
//  Copyright © 2019 Rahmat. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var actLoading: UIActivityIndicatorView!
    @IBOutlet weak var lblSource: UILabel!
    @IBOutlet weak var tbData: UITableView!
    
    lazy var viewModel: NewsViewModel = {
        return NewsViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        
        self.initVM()
    }
    
    func initView() {
        self.tbData.estimatedRowHeight = 160
        self.tbData.rowHeight = UITableView.automaticDimension
    }
    
    func initVM() {
        self.viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert(message)
                }
            }
        }
        
        self.viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.actLoading.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tbData.alpha = 0.0
                    })
                }else{
                    self?.actLoading.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tbData.alpha = 1.0
                    })
                }
            }
        }
        
        self.viewModel.reloadTbDataClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.lblSource.text = (self?.viewModel.listNews.source ?? "-").uppercased()
                self?.tbData.reloadData()
            }
        }
        
        self.viewModel.initFetch()
    }

    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let conn = segue.destination as? DetailNewsViewController, let article = self.viewModel.articleSelected {
            conn.article = article
        }
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return self.viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as? NewsCell else { fatalError("Cell not exists in storyboard") }
        
        let data = self.viewModel.getCellViewModel(at: indexPath)
        cell.NewsCellViewModel = data
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.didSelectCell(at: indexPath)
        self.performSegue(withIdentifier: "showDetailNews", sender: self)
    }
}

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgNews: UIImageView!
    @IBOutlet weak var lblDateBy: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    var NewsCellViewModel: NewsCellViewModel? {
        didSet{
            self.lblTitle.text = NewsCellViewModel?.title ?? ""
            self.imgNews.loadImageUsingCacheWithUrlString(NewsCellViewModel?.urlToImage ?? "")
            self.lblDateBy.text = "\(NewsCellViewModel?.publishedAt ?? "") by \(NewsCellViewModel?.author ?? "")"
            self.lblDesc.text = NewsCellViewModel?.description ?? ""
        }
    }
    
}
