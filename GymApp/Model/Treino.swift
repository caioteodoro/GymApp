//
//  Treino.swift
//  GymApp
//
//  Created by Caio Teodoro on 24/05/22.
//

import Foundation

class Treino {
    let nome: Int
    var descricao: String
    var data: Date
    
    init(nome: Int, descricao: String, data: Date){
        self.nome = nome
        self.descricao = descricao
        self.data = data
    }
    
    init(){
        self.nome = 0
        self.descricao = ""
        self.data = Date()
    }
    
}
