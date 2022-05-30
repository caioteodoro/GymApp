//
//  Exercicio.swift
//  GymApp
//
//  Created by Caio Teodoro on 24/05/22.
//

import Foundation

class Exercicio {
    let nome: Int
    let imagem: URL
    let observacoes: String
    
    init(nome: Int, imagem: URL, observacoes: String){
        self.nome = nome
        self.imagem = imagem
        self.observacoes = observacoes
    }
    
}
