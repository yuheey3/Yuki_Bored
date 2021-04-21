//
//  ViewController.swift
//  Yuki_Bored
//  Student# : 141082180
//  Created by Yuki Waka on 2021-04-20.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet var lblActivity : UILabel!

    private let boredFetcher = BoredFetcher.getInstance()
    private var activityList : FavActivity = FavActivity()
    private var cancellables: Set<AnyCancellable> = []
    
    private let dbHelper = DatabaseHelper.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = " Random Activity"
        
        self.boredFetcher.fetchDataFromAPI()
        self.receiveChanges()
        
        let btnDisplayActivity = UIBarButtonItem(title: "MyActivity", style: .plain, target: self, action: #selector(performActivity))
        self.navigationItem.setRightBarButton(btnDisplayActivity, animated: true)
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
    
    @IBAction func addFavorite(){
        var newFav = MyFavorite()
        newFav.activity = lblActivity.text!
      
        self.dbHelper.insertActivity(newMyActivity: newFav)
        
        let confirmAlert = UIAlertController(title: "Confirmation", message: "Activity is added!", preferredStyle: .actionSheet)
        
        confirmAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
           
        }))
        self.present(confirmAlert,animated: true, completion: nil)

}
    
    @IBAction func showAnotherActivity(){
        
        self.boredFetcher.fetchDataFromAPI()
        self.receiveChanges()
    }
    
    @objc
    func performActivity()
    {
        self.navigationController?.popToRootViewController(animated: true)
        
        self.askConfirmation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func askConfirmation(){
        let confirmAlert = UIAlertController(title: "Confirmation", message: "Would you like to see your favorite activity?", preferredStyle: .actionSheet)
        
        confirmAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
            self.goToDisplayScreen()
        }))
        
        confirmAlert.addAction(UIAlertAction(title: "No, I will add more.", style: .cancel, handler: nil))
        self.present(confirmAlert,animated: true, completion: nil)
    }
    
    
    func goToDisplayScreen(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let boredVC = storyboard.instantiateViewController(identifier: "BoredVC") as! BoredTableViewController
    
     //   orderVC.orderList = orderList
        self.navigationController?.pushViewController(boredVC, animated: true)
        
    }
    
}

