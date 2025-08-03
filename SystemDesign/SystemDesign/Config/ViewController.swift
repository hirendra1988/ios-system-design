//
//  ViewController.swift
//  SystemDesign
//
//  Created by Hirendra Sharma on 16/07/25.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let controller = UIHostingController(rootView: TimerContentView())
//        self.navigationController?.pushViewController(controller, animated: false)
        
        let controller = UIHostingController(rootView: TicTacToeContentView())
        self.navigationController?.pushViewController(controller, animated: false)
    }


}

