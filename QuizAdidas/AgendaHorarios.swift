//
//  AgendaHorarios.swift
//  QuizAdmin
//
//  Created by Erik Nascimento on 01/08/16.
//  Copyright © 2016 BizSys. All rights reserved.
//

import Foundation

typealias AgendaHorariosArray = Array<AgendaHorarios>

let hourFormatter = NSDateFormatter()
let hourFormatterWOSeconds = NSDateFormatter()

public class AgendaHorarios{
    
    var pontos: Int?
    var horario: String?
    var horaToDisplay: String?
    
    func initialize(dados:JSONArray) -> AgendaHorariosArray {
        
        hourFormatter.dateFormat = "HH:mm:ss"
        hourFormatterWOSeconds.dateFormat = "HH:mm"
        
        var itens = AgendaHorariosArray()
        
        for item in dados {
            
            let dataHour:NSDate = hourFormatter.dateFromString(item["hora"] as! String)!
            
            let agh = AgendaHorarios()
            
            agh.horario = hourFormatterWOSeconds.stringFromDate(dataHour)
            agh.horaToDisplay = hourFormatterWOSeconds.stringFromDate(dataHour) + "-" + hourFormatterWOSeconds.stringFromDate(dataHour.dateByAddingTimeInterval(30*60))
            agh.pontos = item["contador"] as? Int
            
            itens.append(agh)
        }
        
        return itens
    }
    
}
