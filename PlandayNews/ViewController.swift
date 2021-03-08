//
//  ViewController.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 03.03.2021.
//

import UIKit
import Combine

class ViewController: UIViewController {
    var anyCancellable: AnyCancellable?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        anyCancellable = NewsAPI.topHeadlines(page: 1)
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { news in
                print(news.articles.count)
                for item in news.articles {
                    print(item.content)
                }
            }
    }
}

