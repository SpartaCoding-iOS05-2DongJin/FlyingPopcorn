//
//  MyPageViewController.swift
//  FlyingPopcornApp
//
//  Created by seohuibaek on 12/17/24.
//

import UIKit

final class MyPageViewController: UIViewController {
    private let userInformationView = UserInformationView()
    //private let myPageView = MyPageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = userInformationView
        view.backgroundColor = .gray
    }
}
