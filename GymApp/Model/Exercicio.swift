//
//  Exercicio.swift
//  GymApp
//
//  Created by Caio Teodoro on 24/05/22.
//

import Foundation

class Exercicio {
    let nome: String
    let imagem: URL
    let observacoes: String
    
    init(nome: String, imagem: URL, observacoes: String){
        self.nome = nome
        self.imagem = imagem
        self.observacoes = observacoes
    }
    
}
