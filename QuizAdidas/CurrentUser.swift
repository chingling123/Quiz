//
//  CurrentUser.swift
//  QuizAdidas
//
//  Created by Laurent Lorena on 7/29/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit

public class CurrentUser{
    
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
    
    static let sharedUser = CurrentUser()
    
    func intialize(respostas: JSONDictionary?){
        
        CurrentUser.sharedUser.id = respostas?["id"] as? Int
        CurrentUser.sharedUser.nome = respostas?["nome"] as? String
        CurrentUser.sharedUser.email = respostas?["email"] as? String
        CurrentUser.sharedUser.celular = respostas?["celular"] as? String
        CurrentUser.sharedUser.documento = respostas?["documento"] as? String
        CurrentUser.sharedUser.dtaNasc = respostas?["dtaNasc"] as? String
        CurrentUser.sharedUser.criadoEm = respostas?["criadoEm"] as? NSDate
        CurrentUser.sharedUser.pontos = respostas?["pontos"] as? Int
        CurrentUser.sharedUser.acesso = respostas?["acesso"] as? Bool
        CurrentUser.sharedUser.futebol = respostas?["futebol"] as? Bool
        CurrentUser.sharedUser.basquete = respostas?["basquete"] as? Bool
        CurrentUser.sharedUser.codigoAcesso = respostas?["codigoAcesso"] as? String
        
    }

}
