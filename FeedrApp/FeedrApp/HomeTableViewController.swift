//
//  HomeTableViewController.swift
//  FeedrApp
//
//  Created by James Perry on 10/21/17.
//  Copyright © 2017 Team9. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController
{
    //THIS IS THE SEARCH BAR AT THE TOP OF THE VIEW
    @IBOutlet weak var lbl_searchbar: UITextField!
    
    var result = Result()
    
    @IBAction func btn_Search(_ sender: Any)
    {
        //  if the lbl_searchbar isnt empty...
        if lbl_searchbar.text != nil
        {
            //  if the lbl_searchbar isnt empty...
            YummlyAPI.GetSearch(
                search: lbl_searchbar.text!,
                requirePictures: true,
                allowedIngredients: [],
                allowedAllergies: [],
                allowedDiet: [],
                allowedCuisines: [],
                excludedCuisines: [],
                allowedCourses: [],
                excludeCourses: [],
                allowedHoliday: [],
                excludeHoliday: [],
                maxTotalTimeInSeconds: -1,
                maxResults: -1)
            { result in
                
                for match in result.matches!
                {
                    //print (match.recipeName!)
                    //print (match.smallImageUrls![0])
                }
                
                //  Update the current result variable so it can be used outside of this function
                self.result = result
                
                //  Dispatch queue so table view is refreshed with data
                DispatchQueue.main.async
                {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return self.result.matches!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //  Initialize the variables to tags
        let img_recipeThumbnail = cell.viewWithTag(1) as! UIImageView
        let lbl_recipeName = cell.viewWithTag(2) as! UILabel
        let lbl_cookingTime = cell.viewWithTag(3) as! UILabel
        
        //  Assign variables to actual values
        //  Image thumbnail (code is long because there needs to be a handler for when img download fails for whatever reason.)
        let url = URL(string: result.matches![indexPath.row].smallImageUrls![0])
        URLSession.shared.dataTask(with: url!, completionHandler:{ (data, reponse, error) in
            if error != nil
            {
                print(error!)
                return
            }
            DispatchQueue.main.async
            {
                //  Finally, assign the image if all is successful
                img_recipeThumbnail.image = UIImage(data: data!)
            }
        }).resume()
        
        //  Recipe Name
        lbl_recipeName.text = result.matches![indexPath.row].recipeName
        //  Cooking Time
        lbl_cookingTime.text = result.matches![indexPath.row].GetCookingTime()
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
