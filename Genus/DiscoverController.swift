//
//  DiscoverController.swift
//  Genus
//
//  Created by Orionsyrus24 on 12/9/20.
//

import UIKit


class DiscoverController: UIViewController,collectionViewCellClicked,collectionViewCellClicked2,collectionViewCellClicked3,collectionViewCellClicked4
{
    func cellClicked(idGame:Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameController") as! GameController
        vc.idUser=id
        vc.idGame=idGame
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
          

    //Widgets
    @IBOutlet weak var tableView: UITableView!
    //var
    var id:Int=0
    var username:String=""
    
   
    
 
  
 
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    
    //IBActions
        
    @IBAction func search(_ sender: Any) {
    }
    
    
    
}

extension DiscoverController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if(indexPath.row == 0) {
       let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath)
            as! TopPicksTableViewCell
        cell.delegate = self
            return cell
           
            
        }
        else if (indexPath.row == 1)
        {
          let  cell = tableView.dequeueReusableCell(withIdentifier: "secondCell", for: indexPath) as! TrendingGamesTableViewCell
           cell.delegate = self
            return cell
        }
        else if (indexPath.row == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lastCell", for: indexPath) as! BestRateTableViewCell
            cell.delegate = self
            return cell
           
        }
        
        else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "otherGames", for: indexPath) as! AllGamesTableViewCell
            cell.delegate = self
            return cell
           
        }
       
    }
    
 
}
