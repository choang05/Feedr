//
//  YummlyAPI.swift
//  Feedr
//
//  Created by chad hoang on 10/12/17.
//  Copyright © 2017 Chad Hoang. All rights reserved.
//

import Foundation

/*
 Yummly Enums
 */
enum Cuisine
{
    case American
    case Italian
    case Asian
    case Mexican
    case Southern
    case French
    case Southwestern
    case Barbecue
    case Indian
    case Chinese
    case Cajun
    case English
    case Mediterranean
    case Greek
    case Spanish
    case German
    case Thai
    case Moroccan
    case Irish
    case Japanese
    case Cuban
    case Hawaiin
    case Swedish
    case Hungarian
    case Portugese
}

enum Allergy
{
    case Diary
    case Gluten
    case Peanut
    case Seafood
    case Sesame
    case Soy
    case Sulfite
    case TreeNut
    case Wheat
}

enum Diet
{
    case LactoVegetarian
    case OvoVegetarian
    case Pescetarian
    case Vegen
    case Vegetarian
}

enum Course
{
    case Main
    case Desserts
    case Sides
    case Lunch
    case Appetizers
    case Salads
    case Breads
    case Breakfast
    case Soups
    case Beverages
    case Condiments
    case Cocktails
}

enum Holiday
{
    case Christmas
    case Summer
    case Thanksgiving
    case NewYear
    case SuperBowl
    case Halloween
    case Hanukkah
    case FourthOfJuly
}

/*
 Yummly JSON structure
 */
struct Result: Decodable
{
    var attribution : Attribution?
    var totalMatchCount : Int?
    var facetCounts : [String: String]?
    var matches : [Matches]?
    var criteria : Criteria?
}
struct Attribution: Decodable
{
    var html : String?
    var url : String?
    var text : String?
    var logo : String?
}
struct Matches: Decodable
{
    var attributes : Attributes?
    var flavors : Flavors?
    var rating : Float?
    var id : String?
    var smallImageUrls : [String]?
    var sourceDisplayName : String?
    var totalTimeInSeconds : Int?
    var ingredients : [String]?
    var recipeName : String?
}
struct Attributes: Decodable
{
    var course : [String]?
    var cuisine : [String]?
}
struct Flavors: Decodable
{
    var salty : Float?
    var sour : Float?
    var sweet : Float?
    var bitter : Float?
    var meaty : Float?
    var piquant : Float?
}
struct Criteria: Decodable
{
    var maxResults : Int?
    var excludedIngredients : [String]?
    var excludedAttributes : [String]?
    var allowedIngredients : [String]?
    var attributeRanges : AttributeRanges?
    var nutritionRestrictions : NutritionRestrictions?
    var allowedDiets : [String]?
    var resultsToSkip : Int?
    var requirePictures : Bool?
    var facetFields : [String]?
    var terms : [String]?
    var allowedAttributes : [String]?
}
struct AttributeRanges: Decodable
{
    var flavorPiquant : FlavorPiquant?
}
struct FlavorPiquant: Decodable
{
    var min : Float
    var max : Float
}
struct NutritionRestrictions: Decodable
{
    var nutrition : [Nutrition]?
}
struct Nutrition: Decodable
{
    var min : Int
    var max : Int
}

class YummlyAPI
{
    //  VARIABLES
    
    //  yummly API variables

    
    //  Global function for making yummly calls. Returns a search result enum that contains all the data
    static func GetSearch(search: String?,
                         requirePictures: Bool?,
                         allowedIngredients: [String]?,
                         //excludedIngredients: [String]?,
                         allowedAllergies: [Allergy]?,
                         allowedDiet: [Diet]?,
                         allowedCuisines: [Cuisine]?,
                         excludedCuisines: [Cuisine]?,
                         allowedCourses: [Course]?,
                         excludeCourses: [Course]?,
                         allowedHoliday: [Holiday]?,
                         excludeHoliday: [Holiday]?,
                         maxTotalTimeInSeconds: Int?,
                         maxResults: Int?,
                         completion: @escaping (Result) -> ())
    {
        let yummlyID = "51013d4c"
        let yummlyKey = "0549dc2605e77741e0feb12736c65087"
        let yummlyURL = "https://api.yummly.com/v1/api/recipes?"
        
        //  Replace spaces with '+'
        let search = search!.replacingOccurrences(of: " ", with: "+")

        //  Check check parameter errors
        if search.isEmpty
        {
            print("Search parameter is empty!")
        }
        
        //  Create the base query string that will request from yummly
        var query = yummlyURL + "_app_id=" + yummlyID + "&_app_key=" + yummlyKey
        
        //  Append to query with parameters
        if !search.isEmpty
        {
            query += "&q=" + search
        }
        //  Does search require pictures?
        if  requirePictures == true
        {
            query += "&requirePictures=true"
        }
        //  Allowed Ingredients
        if allowedIngredients!.count > 0
        {
            for ingredient in allowedIngredients!
            {
                query += "&allowedIngredient[]=" + ingredient
            }
        }

        //excludedIngredients: [String]?,
        //  Allowed Allergies
        if allowedAllergies!.count > 0
        {
            for allergy in allowedAllergies!
            {
                query += "&allowedAllergy[]="
                
                switch allergy
                {
                    case Allergy.Diary:
                        query += "396^Dairy-Free"
                    case Allergy.Gluten:
                        query += "393^Gluten-Free"
                    case Allergy.Peanut:
                        query += "394^Peanut-Free"
                    case Allergy.Seafood:
                        query += "398^Seafood-Free"
                    case Allergy.Sesame:
                        query += "399^Sesame-Free"
                    case Allergy.Soy:
                        query += "400^Soy-Free"
                    case Allergy.Sulfite:
                        query += "401^Sulfite-Free"
                    case Allergy.TreeNut:
                        query += "395^Tree Nut-Free"
                    case Allergy.Wheat:
                        query += "392^Wheat-Free"
                }
            }
        }
        //  Allowed Diets
        if allowedDiet!.count > 0
        {
            for diet in allowedDiet!
            {
                query += "&allowedDiet[]="
                
                switch diet
                {
                case Diet.LactoVegetarian:
                    query += "388^Lacto vegetarian"
                case Diet.OvoVegetarian:
                    query += "389^Ovo vegetarian"
                case Diet.Pescetarian:
                    query += "390^Pescetarian"
                case Diet.Vegen:
                    query += "386^Vegan"
                case Diet.Vegetarian:
                    query += "387^Lacto-ovo vegetarian"
                }
            }
        }
        //  Allowed Cuisines
        if allowedCuisines!.count > 0
        {
            for cuisine in allowedCuisines!
            {
                query += "&allowedCuisine[]="
                
                switch cuisine
                {
                case Cuisine.American:
                    query += "cuisine^cuisine-american"
                case Cuisine.Asian:
                    query += "cuisine^cuisine-asian"
                case Cuisine.Barbecue:
                    query += "cuisine^cuisine-barbecue-bbq"
                case Cuisine.Cajun:
                    query += "cuisine^cuisine-cajun"
                case Cuisine.Chinese:
                    query += "cuisine^cuisine-chinese"
                case Cuisine.Cuban:
                    query += "cuisine^cuisine-cuban"
                case Cuisine.English:
                    query += "cuisine^cuisine-english"
                case Cuisine.French:
                    query += "cuisine^cuisine-french"
                case Cuisine.German:
                    query += "cuisine^cuisine-german"
                case Cuisine.Greek:
                    query += "cuisine^cuisine-greek"
                case Cuisine.Hawaiin:
                    query += "cuisine^cuisine-hawaiian"
                case Cuisine.Hungarian:
                    query += "cuisine^cuisine-hungarian"
                case Cuisine.Indian:
                    query += "cuisine^cuisine-indian"
                case Cuisine.Irish:
                    query += "cuisine^cuisine-irish"
                case Cuisine.Italian:
                    query += "cuisine^cuisine-italian"
                case Cuisine.Japanese:
                    query += "cuisine^cuisine-japanese"
                case Cuisine.Mediterranean:
                    query += "cuisine^cuisine-mediterranean"
                case Cuisine.Mexican:
                    query += "cuisine^cuisine-mexican"
                case Cuisine.Moroccan:
                    query += "cuisine^cuisine-moroccan"
                case Cuisine.Portugese:
                    query += "cuisine^cuisine-portuguese"
                case Cuisine.Southern:
                    query += "cuisine^cuisine-southern"
                case Cuisine.Southwestern:
                    query += "cuisine^cuisine-southwestern"
                case Cuisine.Spanish:
                    query += "cuisine^cuisine-spanish"
                case Cuisine.Swedish:
                    query += "cuisine^cuisine-swedish"
                case Cuisine.Thai:
                    query += "cuisine^cuisine-thai"
                }
            }
        }
        //  Excluded Cuisines
        if excludedCuisines!.count > 0
        {
            for cuisine in excludedCuisines!
            {
                query += "&excludedCuisine[]="
                
                switch cuisine
                {
                case Cuisine.American:
                    query += "cuisine^cuisine-american"
                case Cuisine.Asian:
                    query += "cuisine^cuisine-asian"
                case Cuisine.Barbecue:
                    query += "cuisine^cuisine-barbecue-bbq"
                case Cuisine.Cajun:
                    query += "cuisine^cuisine-cajun"
                case Cuisine.Chinese:
                    query += "cuisine^cuisine-chinese"
                case Cuisine.Cuban:
                    query += "cuisine^cuisine-cuban"
                case Cuisine.English:
                    query += "cuisine^cuisine-english"
                case Cuisine.French:
                    query += "cuisine^cuisine-french"
                case Cuisine.German:
                    query += "cuisine^cuisine-german"
                case Cuisine.Greek:
                    query += "cuisine^cuisine-greek"
                case Cuisine.Hawaiin:
                    query += "cuisine^cuisine-hawaiian"
                case Cuisine.Hungarian:
                    query += "cuisine^cuisine-hungarian"
                case Cuisine.Indian:
                    query += "cuisine^cuisine-indian"
                case Cuisine.Irish:
                    query += "cuisine^cuisine-irish"
                case Cuisine.Italian:
                    query += "cuisine^cuisine-italian"
                case Cuisine.Japanese:
                    query += "cuisine^cuisine-japanese"
                case Cuisine.Mediterranean:
                    query += "cuisine^cuisine-mediterranean"
                case Cuisine.Mexican:
                    query += "cuisine^cuisine-mexican"
                case Cuisine.Moroccan:
                    query += "cuisine^cuisine-moroccan"
                case Cuisine.Portugese:
                    query += "cuisine^cuisine-portuguese"
                case Cuisine.Southern:
                    query += "cuisine^cuisine-southern"
                case Cuisine.Southwestern:
                    query += "cuisine^cuisine-southwestern"
                case Cuisine.Spanish:
                    query += "cuisine^cuisine-spanish"
                case Cuisine.Swedish:
                    query += "cuisine^cuisine-swedish"
                case Cuisine.Thai:
                    query += "cuisine^cuisine-thai"
                }
            }
        }
        //  Allowed Courses
        if allowedCourses!.count > 0
        {
            for course in allowedCourses!
            {
                query += "&allowedCourse[]="
                
                switch course
                {
                case Course.Appetizers:
                    query += "course^course-Appetizers"
                case Course.Beverages:
                    query += "course^course-Beverages"
                case Course.Breads:
                    query += "course^course-Breads"
                case Course.Breakfast:
                    query += "course^course-Breakfast and Brunch"
                case Course.Cocktails:
                    query += "course^course-Cocktails"
                case Course.Condiments:
                    query += "course^course-Condiments and Sauces"
                case Course.Desserts:
                    query += "course^course-Desserts"
                case Course.Lunch:
                    query += "course^course-Lunch"
                case Course.Main:
                    query += "course^course-Main Dishes"
                case Course.Salads:
                    query += "course^course-Salads"
                case Course.Sides:
                    query += "course^course-Side Dishes"
                case Course.Soups:
                    query += "course^course-Soups"
                }
            }
        }
        //  Excluded Courses
        if excludeCourses!.count > 0
        {
            for course in excludeCourses!
            {
                query += "&excludedCourse[]="
                
                switch course
                {
                case Course.Appetizers:
                    query += "course^course-Appetizers"
                case Course.Beverages:
                    query += "course^course-Beverages"
                case Course.Breads:
                    query += "course^course-Breads"
                case Course.Breakfast:
                    query += "course^course-Breakfast and Brunch"
                case Course.Cocktails:
                    query += "course^course-Cocktails"
                case Course.Condiments:
                    query += "course^course-Condiments and Sauces"
                case Course.Desserts:
                    query += "course^course-Desserts"
                case Course.Lunch:
                    query += "course^course-Lunch"
                case Course.Main:
                    query += "course^course-Main Dishes"
                case Course.Salads:
                    query += "course^course-Salads"
                case Course.Sides:
                    query += "course^course-Side Dishes"
                case Course.Soups:
                    query += "course^course-Soups"
                }
            }
        }
        //  Allowed Holiday
        if allowedHoliday!.count > 0
        {
            for holiday in allowedHoliday!
            {
                query += "&excludedCourse[]="
                
                switch holiday
                {
                case Holiday.Christmas:
                    query += "holiday^holiday-christmas"
                case Holiday.FourthOfJuly:
                    query += "holiday^holiday-4th-of-july"
                case Holiday.Halloween:
                    query += "holiday^holiday-halloween"
                case Holiday.Hanukkah:
                    query += "holiday^holiday-hanukkah"
                case Holiday.NewYear:
                    query += "holiday^holiday-new-year"
                case Holiday.Summer:
                    query += "holiday^holiday-summer"
                case Holiday.SuperBowl:
                    query += "holiday^holiday-super-bowl"
                case Holiday.Thanksgiving:
                    query += "holiday^holiday-thanksgiving"
                }
            }
        }
        //  Excluded Holiday
        if excludeHoliday!.count > 0
        {
            for holiday in excludeHoliday!
            {
                query += "&excludedHoliday[]="
                
                switch holiday
                {
                case Holiday.Christmas:
                    query += "holiday^holiday-christmas"
                case Holiday.FourthOfJuly:
                    query += "holiday^holiday-4th-of-july"
                case Holiday.Halloween:
                    query += "holiday^holiday-halloween"
                case Holiday.Hanukkah:
                    query += "holiday^holiday-hanukkah"
                case Holiday.NewYear:
                    query += "holiday^holiday-new-year"
                case Holiday.Summer:
                    query += "holiday^holiday-summer"
                case Holiday.SuperBowl:
                    query += "holiday^holiday-super-bowl"
                case Holiday.Thanksgiving:
                    query += "holiday^holiday-thanksgiving"
                }
            }
        }
        //  total seconds to cook recipes
        if maxTotalTimeInSeconds! > 0
        {
            query += "&maxTotalTimeInSeconds=" + String(maxTotalTimeInSeconds!)
        }
        //  max results to return per page
        if maxResults! > 0
        {
            query += "&maxResult=" + String(maxResults!) + "0&start=0"
        }
        
        let url = URL(string: query)
        
        //  Empty result var to be returned after URLSession
        /*var result = Result(attribution : Attribution(html:"",url:"",text:"",logo:""),
                            totalMatchCount : -1,
                            facetCounts : ["": ""],
                            matches : [Matches(attributes : Attributes(course: [], cuisine: []),
                                                           flavors : Flavors(salty: -1, sour: -1, sweet: -1, bitter: -1, meaty: -1, piquant: -1),
                                                           rating : -1,
                                                           id : "",
                                                           smallImageUrls : [],
                                                           sourceDisplayName : "",
                                                           totalTimeInSeconds : -1,
                                                           ingredients : [],
                                                           recipeName : "")],
                            criteria : Criteria.init(maxResults: -1,
                                                     excludedIngredients: [],
                                                     excludedAttributes: [],
                                                     allowedIngredients: [],
                                                     attributeRanges: AttributeRanges(flavorPiquant: FlavorPiquant(min: -1, max: -1)),
                                                     nutritionRestrictions: NutritionRestrictions(nutrition: []),
                                                     allowedDiets: [],
                                                     resultsToSkip: -1,
                                                     requirePictures: false,
                                                     facetFields: [],
                                                     terms: [],
                                                     allowedAttributes: []))*/
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            //  Check error
            //  Check status code
            
            //  Ensure data is not null
            guard let data = data else {    return  }
            
            //  Try to serialize the JSON data.
            do
            {
                //let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                let result = try JSONDecoder().decode(Result.self, from: data)
                
                print("Total matches:", result.totalMatchCount!)
                
                //  Loop through all recipe matches
                /*for match in searchResult.matches!
                {
                    print("Attributes:", match.attributes!)
                    print("Ingredients:", match.ingredients!)
                    print("Total seconds to cook:", match.totalTimeInSeconds!)
                    print("Recipe Name:", match.recipeName!)
                    //print("Flavors:", match.flavors!)
                }*/
                
                completion(result)
            }
            catch let jsonErr
            {
                print("Error serializing json:", jsonErr)
            }
        }.resume()
    }
}
