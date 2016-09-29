//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Marco De Filippo on 9/29/16.
//  Copyright © 2016 2AM App Labs. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = pokemon.name
        
    }



}
