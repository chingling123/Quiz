//
//  CadastroModel.swift
//  QuizAdidas
//
//  Created by Laurent Lorena on 7/27/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import Foundation

public class CadastroModel{
    
    var id: Int?
    var nome: String?
    var email: String?
    var celular:  String?
    var documento: String?
    var dtaNasc: String?
    var criadoEm: NSDate?
    var pontos: Int?
    var acesso: Bool?
    var futebol: Bool?
    var basquete: Bool?
    var codigoAcesso: String?
    
    init(){
        
    }
    
    init(respostas: JSONDictionary?){
        
        self.id = respostas?["id"] as? Int
        self.nome = respostas?["nome"] as? String
        self.email = respostas?["email"] as? String
        self.celular = respostas?["celular"] as? String
        self.documento = respostas?["documento"] as? String
        self.dtaNasc = respostas?["dtaNasc"] as? String
        self.criadoEm = respostas?["criadoEm"] as? NSDate
        self.pontos = respostas?["pontos"] as? Int
        self.acesso = respostas?["acesso"] as? Bool
        self.futebol = respostas?["futebol"] as? Bool
        self.basquete = respostas?["basquete"] as? Bool
        self.codigoAcesso = respostas?["codigoAcesso"] as? String
        
    }
    
}
