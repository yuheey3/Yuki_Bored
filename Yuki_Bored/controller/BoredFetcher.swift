//
//  BoredFetcher.swift
//  Yuki_Bored
//  Student# : 141082180
//  Created by Yuki Waka on 2021-04-20.
//

import Foundation

class BoredFetcher : ObservableObject{
    
    var apiURL = "https://www.boredapi.com/api/activity"
    
    @Published var activityList = FavActivity()
    
    //singleton instance
    private static var shared : BoredFetcher?
    
    static func getInstance() -> BoredFetcher{
        if shared != nil{
            //instance already exists
            return shared!
        }else{
            // create a new singlton instance
            return BoredFetcher()
        }
    }
    
    
    
    func fetchDataFromAPI(){
       
        guard let api = URL(string: apiURL) else{
            return
        }
        
        URLSession.shared.dataTask(with: api){(data: Data?, response: URLResponse?, error : Error?) in
            
            if let err = error{
                print(#function, "Couldn't fetch data", err)
            }else{
                //received data or response
                
                DispatchQueue.global().async{
                    do{
                        if let jsonData = data{
                            
                            let decoder = JSONDecoder()
                            //use this if response is array of JSON objects
                            let decodedList = try decoder.decode(FavActivity.self, from: jsonData)
                            
                            //use this of response is JSON object
                            // let decodedList = try decoder.decode(Launch.self, from: jsonData)
                            DispatchQueue.main.async {
                                self.activityList = decodedList
                            }
                            
                            
                        }else{
                            print(#function, "No JSON data received")
                        }
                    }catch  let error{
                        print(#function, error)
                    }
                }
            }
            
        }.resume()
    }
}


