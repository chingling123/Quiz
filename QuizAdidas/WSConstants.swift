//
//  WSConstants.swift
//  QuizAdidas
//
//  Created by Laurent Lorena on 7/27/16.
//  Copyright © 2016 Laurent Lorena. All rights reserved.
//

import UIKit

public class WSConstants {
    
    let wsAdress = "http://quizadidas.trafego.biz/api/"
    
    //----------------Cadastro-----------------
    
    //GET - Get simples que retorna a lista completa de Cadastros, pode ser usando com com /id
    //Post também uso passando um CadastroModel convertido em Json
    let cadastro = "cadastro/"
    
    
    //POST - Executa a rotina para reenvio do SMS + numero de celular
    let SMS = "SMS/"
    
    //----------------Agenda-------------------
    
    //GET - volta os horários e quantos possuem agendados
    let agenda2 = "Agenda2"
    
    //metodo padrão para get, post, put e delete
    let agenda = "agenda/"
    
    
    
    //---------------Perguntas------------------
    
    let perguta = "pergunta/"
    
    
    //---------------Resposta-------------------
    
    let pergunta = "resposta/"
}
