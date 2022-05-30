//
//  Treino.swift
//  GymApp
//
//  Created by Caio Teodoro on 24/05/22.
//

import Foundation

class Treino {
    let nome: Int
    let descricao: String
    let data: NSDate
    
    init(nome: Int, descricao: String, data: NSDate){
        self.nome = nome
        self.descricao = descricao
        self.data = data
    }
}
