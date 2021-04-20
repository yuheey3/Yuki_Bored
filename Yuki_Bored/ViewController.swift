//
//  ViewController.swift
//  Yuki_Bored
//
//  Created by Yuki Waka on 2021-04-20.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet var lblActivity : UILabel!

    private let boredFetcher = BoredFetcher.getInstance()
    private var activityList : FavActivity = FavActivity()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.boredFetcher.fetchDataFromAPI()
        self.receiveChanges()
   
    }
    
    
    private func receiveChanges(){
        self.boredFetcher.$activityList.receive(on: RunLoop.main)
            .sink{ (bored) in
                print(#function, "Received bored : ", bored)
              
                self.activityList = bored
                self.lblActivity.text = self.activityList.activity
            }
            .store(in : &cancellables)
    }
    

}

