//
//  Activity.swift
//  Yuki_Bored
//  Student# : 141082180
//  Created by Yuki Waka on 2021-04-20.
//

import Foundation

struct FavActivity : Codable{

    var activity : String
    
    init(){
        self.activity = ""
    }
    
    enum CodingKeys : String, CodingKey{
        case activity = "activity"
    }
    
    func encode(to encoder: Encoder) throws {
        //nothing to encode
    }
    
    init(from decoder: Decoder) throws{
        let response = try decoder.container(keyedBy: CodingKeys.self)
        self.activity = try response.decodeIfPresent(String.self, forKey: .activity) ?? "Unavailable"
        
    }
    

}
