//
//  RootNavigationVC.swift
//  TheAppApp
//
//  Created by James on 11/19/22.
//

import UIKit
import SafariServices

struct RecipeData: Decodable {
    let title: String
    let url: String
    let img: String
}

class RootNavigationVC: UITableViewController {
    

    let cellID = "cellID"
    var recipeData = [RecipeData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        recipeNC()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        
    }

    func recipeNC() {
        let headers = [
            "X-RapidAPI-Key": "bc9a73da7dmshad208c4b6a57bf9p13e4f3jsnf6beb9575ddb",
            "X-RapidAPI-Host": "cooking-recipe2.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://cooking-recipe2.p.rapidapi.com/getbycat/Indian%20Desserts")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 14.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let _ = response as? HTTPURLResponse
               
                let recipes = try? JSONDecoder().decode([RecipeData].self, from: data!)
                if let recipes = recipes {
                    self.recipeData = recipes
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            }
        })

        dataTask.resume()
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeData.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let recipeCell = recipeData[indexPath.row]
        cell.textLabel?.text = recipeCell.title
        cell.backgroundColor = .systemGray5
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let html = recipeData[indexPath.row].url
        if let url = URL(string: html) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
      
    }
    
   
}
