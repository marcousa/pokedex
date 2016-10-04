//
//  Pokemon.swift
//  Pokedex
//
//  Created by Marco De Filippo on 9/28/16.
//  Copyright © 2016 2AM App Labs. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var nextEvolutionID: String {
        if _nextEvolutionID == nil {
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    
    var name: String {
        return _name.capitalized
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String,Any> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String,Any>] , types.count > 0 {
                    
                    var availableTypes = [String]()
                    var typesToSave = ""
                    
                    for i in 0..<types.count {
                        
                        if let newType = types[i]["name"] as? String {
                            availableTypes.append(newType)
                        }
                        
                    }
                    
                    if availableTypes.count > 1 {
                        
                        typesToSave = availableTypes[0].capitalized
                        
                        for t in 1..<availableTypes.count {
                            typesToSave += "/\(availableTypes[t].capitalized)"
                        }
                        
                    } else {
                        typesToSave = availableTypes[0].capitalized
                    }
                    
                    self._type = typesToSave
                    
                } else {
                    
                    self._type = ""
                }
                
                
                
                if let descArray = dict["descriptions"] as? [Dictionary<String,String>], descArray.count > 0 {
                    
                    if let URL = descArray[0]["resource_uri"] {
                        
                        let descURL = "\(URL_BASE)\(URL)"
                        
                        Alamofire.request(descURL).responseJSON(completionHandler: { (response) in
                            
                            if let descDict = response.result.value as? Dictionary<String, Any> {
                                if let description = descDict["description"] as? String {
                                    
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    
                                    self._description = newDescription
                                }
                            }
                            completed()
                            
                        })
                    }
                    
                } else {
                    self._description = ""
                }
               
                
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String,Any>], evolutions.count > 0 {
                    
                    if let nextEvolution = evolutions[0]["to"] as? String {
                        
                        //exclude MEGAs
                        if nextEvolution.range(of: "mega") == nil {
                            
                            self._nextEvolutionName = nextEvolution
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newString = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvolutionID = newString.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionID = nextEvolutionID
                                
                                if let levelExist = evolutions[0]["level"] {
                                    
                                    if let level = levelExist as? Int {
                                        self._nextEvolutionLevel = "\(level)"
                                    }
                                    
                                } else {
                                    self._nextEvolutionLevel = ""
                                }
                                
                            }
                        
                            
                        }
                        
                    }
                    
                } else {
                    
                    self._nextEvolutionText = ""
                    
                }
                
            }
            completed()
        }
    }
    
}
