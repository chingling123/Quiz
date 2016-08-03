//
//  PerguntaModel.swift
//  QuizAdidas
//
//  Created by Laurent Lorena on 7/27/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit

public class PerguntaModel{
    
    var id: Int?
    var questao: String?
    var respA: String?
    var respB: String?
    var respc: String?
    
    init(){
        
    }
    
    init(pergunta: JSONDictionary){
        self.id = pergunta["id"] as? Int
        self.questao = pergunta["questao"] as? String
        self.respA = pergunta["respA"] as? String
        self.respB = pergunta["respB"] as? String
        self.respc = pergunta["respC"] as? String
        
    }
}
