//
//  FavoritesVC.swift
//  FeedrApp
//
//  Created by chad hoang on 11/19/17.
//  Copyright © 2017 Team9. All rights reserved.
//

import UIKit

class FavoritesVC: UITableViewController
{
	static var favRecipes = [Recipe]()
	private var selectedRecipe = Recipe()
	
	override func viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)
		
		//Looks for single or multiple taps.
		//let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		
		//Uncomment the line below if you want the tap not not interfere and cancel other interactions.
		
		//tap.cancelsTouchesInView = false
		
		//view.addGestureRecognizer(tap)
		
		//	Populate the table view with data
		PopulateTable()
	}
	
	func PopulateTable()
	{
		print("Attempting to populate favorites view...")
		
		//let favRecipeIDs = RecipeDetailVC.GetFavoriteRecipeIDs()
		
		//  Dispatch queue so table view is refreshed with data
		DispatchQueue.main.async
		{
			self.tableView.reloadData()
		}
	}
	
	//	Global function to add a Recipe to favorites given a recipeID
	static func AddToFavorites(id: String)
	{
		//	if the id doesnt exists in the favorites. Add it to array
		if !IsRecipeFavorited(id: id)
		{
			YummlyAPI.GetRecipe(recipeID: id)
			{	recipe in
				favRecipes.append(recipe)
				print(id, "has been added to favorites")
				
				//RecipeDetailVC.UpdateFavoriteButton(RecipeDetailVC)
			}
		}
		else
		{
			print(id,"is already favorited. Doing nothing.")
			return
		}
	}
	
	//	Global function to remove a Recipe to favorites given a recipeID
	static func RemoveFromFavorites(id: String)
	{
		//	if the id exists in the favorites. Remove it from array
		if IsRecipeFavorited(id: id)
		{
			favRecipes = favRecipes.filter{$0.id != id}
			print(id, "has been removed to favorites")
		}
		else
		{
			print(id, "does not exist in favorites. Doing nothing.")
			return
		}
	}
	
	static func IsRecipeFavorited(id: String) -> Bool
	{
		let recipeFound = favRecipes.filter{$0.id == id}.count > 0
		if recipeFound == true
		{
			return true
		}
		else
		{
			return false
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		view.endEditing(true)
		super.touchesBegan(touches, with: event)
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
		return FavoritesVC.favRecipes.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		
		//  Initialize the variables to tags
		let img_recipeThumbnail = cell.viewWithTag(1) as! UIImageView
		let lbl_recipeName = cell.viewWithTag(2) as! UILabel
		//let lbl_cookingTime = cell.viewWithTag(3) as! UILabel
		
		//  Assign variables to actual values
		//  Image thumbnail (code is long because there needs to be a handler for when img download fails for whatever reason.)
		if FavoritesVC.favRecipes[indexPath.row].images![0].hostedLargeUrl != nil
		{
			let url = URL(string: FavoritesVC.favRecipes[indexPath.row].images![0].hostedLargeUrl!)
			URLSession.shared.dataTask(with: url!, completionHandler:
			{ (data, reponse, error) in
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
		}
		
		//  Recipe Name
		lbl_recipeName.text = FavoritesVC.favRecipes[indexPath.row].name
		//  Cooking Time
		//lbl_cookingTime.text = FavoritesVC.favRecipes[indexPath.row].GetCookingTime()
		
		return cell
	}
	
	/*override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
	return 80
	}*/
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		selectedRecipe = FavoritesVC.favRecipes[indexPath.row]
		self.performSegue(withIdentifier: "RecipeDetail", sender: self)
		print("Tapped on row ", indexPath.row)
	}
	
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
		if segue.identifier == "RecipeDetail"
		{
			//  Cache the recipe detail controller and pass the data over
			let RecipeDetailVC = segue.destination as! RecipeDetailVC
			RecipeDetailVC.recipeID = selectedRecipe.id!
			//RecipeDetailController.this_user_id = user_id
		}
		else
		{
			print("Could not find segue identifier")
		}
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
}

