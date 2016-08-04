//
//  APIManager.swift
//  Easy Live Music
//
//  Created by Erik Nascimento on 3/25/16.
//  Copyright © 2016 2EG. All rights reserved.
//

import Foundation
typealias JSONDictionary = [String: AnyObject]
typealias JSONArray = Array<AnyObject>

struct ApiClient {
    
    private var serverUrl:String
    private var contentType:String
    
    init(contentType:String, customUrl:String?){
        self.contentType = contentType
        self.serverUrl = "http://quizadidas.trafego.biz/" //"http://192.168.30.197:50794/" //
        if customUrl != nil {
            self.serverUrl = customUrl!
        }
    }
    
    // MARK: private composition methods
    
    private func post(request: NSMutableURLRequest, completion: (success: Bool, object: AnyObject?) -> ()) {
        dataTask(request, method: "POST", completion: completion)
    }
    
    private func put(request: NSMutableURLRequest, completion: (success: Bool, object: AnyObject?) -> ()) {
        dataTask(request, method: "PUT", completion: completion)
    }
    
    private func get(request: NSMutableURLRequest, completion: (success: Bool, object: AnyObject?) -> ()) {
        dataTask(request, method: "GET", completion: completion)
    }
    
    private func dataTask(request: NSMutableURLRequest, method: String, completion: (success: Bool, object: AnyObject?) -> ()) {
        request.HTTPMethod = method
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let data = data {
                let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                if let response = response as? NSHTTPURLResponse where 200...299 ~= response.statusCode {
                    completion(success: true, object: json)
                } else {
                    completion(success: false, object: json)
                }
            }
            }.resume()
    }
    
    private func clientURLRequest(path: String, params: Dictionary<String, AnyObject>? = nil) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: serverUrl+path)!)
        print(request.URL?.absoluteString)
        if let params = params {
            var paramString = ""
            for (key, value) in params {
                
                let escapedKey = key.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
                let escapedValue = value.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
                paramString += "\(escapedKey!)=\(escapedValue!)&"
                
            }
            
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
            request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        return request
    }
    
    private func clientURLRequestForm(path: String, params: Dictionary<String, AnyObject>) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: serverUrl+path)!)
        
        let uniqueId = NSProcessInfo.processInfo().globallyUniqueString
        let boundary:String = "------WebKitFormBoundary\(uniqueId)"
        
        var paramString = "--\(boundary)\r\n"
        for (key, value) in params {
            if let v = value as? [String]{
                for item in v{
                    paramString += "--\(boundary)\r\n"
                    paramString += "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
                    paramString += "\(item)\r\n"
                }
            }else{
                paramString += "--\(boundary)\r\n"
                paramString += "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
                paramString += "\(value)\r\n"
            }
            paramString += "--\(boundary)\r\n"
            
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        return request
    }
    
    private func clientURLRequestJSON(path: String, params: Dictionary<String, AnyObject>? = nil) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: serverUrl+path)!)
        if let params = params {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
            request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(params, options: [])
        }
        
        return request
    }
    
    // MARK: public methods
    
    internal func criarCadastro(cadastro: CadastroModel, completion: (success: Bool, message:JSONDictionary?) -> ()) {
        
        let CadastroObject: [String: AnyObject] = ["nome": cadastro.nome!,
                              "email": cadastro.email!,
                              "documento": cadastro.documento!,
                              "dtaNasc": cadastro.dtaNasc!,
                              "criadoEm": "11/11/1111",
                              "celular": cadastro.celular!,
                              "pontos": 0,
                              "acesso": false,
                              "futebol": 0,
                              "basquete": 0,
                              "codigoAcesso": ""]
        
        post(clientURLRequestJSON("api/Cadastro/", params: CadastroObject)) { (success, object) -> () in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }
    
    internal func postAgenda2(ag: AgendumPost, completion: (success: Bool, message:JSONDictionary?) -> ()) {
        
        let AgendumModelObject: [String: AnyObject] = ["idCadastro": ag.idCadastro!,
                                                       "horario": ag.horario!]
        
        post(clientURLRequestJSON("api/Agenda2/", params: AgendumModelObject)) { (success, object) -> () in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }
    
    internal func getAgenda2(completion:(success:Bool, message: JSONArray?) -> ()){
        
        get(clientURLRequestJSON("api/Agenda2/", params: nil)){(success, object) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONArray)
            })
        }
    }
    
    internal func getSMS(telefone:String, completion:(success:Bool, message: JSONDictionary?) -> ()){
        
        get(clientURLRequestJSON("api/SMS/"+telefone, params: nil)){(success, object) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }
    
    internal func getPerguntas(completion:(success:Bool, message: JSONArray?) -> ()){
        
        get(clientURLRequestJSON("api/Pergunta/", params: nil)){(success, object) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONArray)
            })
        }
    }
    
    internal func getQuestions(completion:(success:Bool, message: JSONArray?) -> ()){
        
        get(clientURLRequestJSON("api/Questions/", params: nil)){(success, object) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONArray)
            })
        }
    }
    
    internal func postRespostas(respostas: [RespostaModel], completion: (success: Bool, message:String?) -> ()) {
        
        var RespostasObject = Dictionary<String, AnyObject>()
        var a = [NSDictionary]()
        for item:RespostaModel in respostas {
            
            var temp = [String: AnyObject]()
            temp = ["idCadastro":item.idCadastro!,
                    "resposta1":item.resposta1!,
                    "idPergunta":item.idPergunta!,
                    "correta":item.correta!,
                    "id":0,
                    "criadoEm":"11/11/1111"]
            
            a.append(temp)
            
        }
        
        RespostasObject = ["respostas":a, "idCadastro": CurrentUser.sharedUser.id!]
        
        post(clientURLRequestJSON("api/Resposta/", params: RespostasObject)) { (success, object) -> () in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? String)
            })
        }
    }
    
    internal func postSMS(ag: AgendumPost, completion: (success: Bool, message:JSONDictionary?) -> ()) {
        
        let SMSObject: [String: AnyObject] = ["idCadastro": ag.idCadastro!,
                                                       "celular": ag.horario!]
        
        post(clientURLRequestJSON("api/SMS/", params: SMSObject)) { (success, object) -> () in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }
    
    internal func postReSMS(celular: String, completion: (success: Bool, message:JSONDictionary?) -> ()) {
        
        let SMSObject: [String: AnyObject] = ["celular": celular]
        
        post(clientURLRequestJSON("api/ReSMS/", params: SMSObject)) { (success, object) -> () in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }

    
    internal func getUserCPF(CPF: String, completion:(success:Bool, message: JSONDictionary?) -> ()){
        
        get(clientURLRequestJSON("api/CPF/"+CPF, params: nil)){(success, object) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }
    
    internal func postCPF(cpf: String, completion: (success: Bool, message:JSONDictionary?) -> ()) {
        
        let CPFObject: [String: AnyObject] = ["DOCUMENTO": cpf]
        
        post(clientURLRequestJSON("api/CPF/", params: CPFObject)) { (success, object) -> () in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }



    /*
    internal func getLastStatus(id:String, completion:(success:Bool, message: JSONDictionary?) -> ()){
        let idObject = ["Id": id]
        
        post(clientURLRequestJSON("api/v1/pt/GetLastStatus", params: idObject)){(success, object) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }
    
    
    internal func lostPassword(email: String, completion: (success: Bool, message: JSONDictionary?) -> ()) {
        let loginObject = ["email": email]
        
        put(clientURLRequestJSON("api/v1/pt/login", params: loginObject)) { (success, object) -> () in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }
    
    internal func getGenres(completion: (success: Bool, message: JSONDictionary?) -> ()) {
        get(clientURLRequest("api/v1/pt/genres/",params: nil)) { (success, object) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }
    
    internal func checkEmail(params: Dictionary<String, AnyObject>, completion: (success: Bool, message: JSONDictionary?) -> ()) {
        
        get(clientURLRequest("api/v1/pt/signup?email=" + (params["email"] as! String), params: nil)) { (success, object) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }
    
    internal func signUp(params: Dictionary<String, AnyObject>, completion: (success: Bool, message: JSONDictionary?) -> ()) {
        
        post(clientURLRequestForm("api/v1/pt/signup", params: params)) { (success, object) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }
    
    internal func listCasas(params: Dictionary<String, AnyObject>, completion: (success: Bool, message: JSONDictionary?) -> ()) {

        post(clientURLRequestJSON("api/v1/pt/showhouses", params: params)) { (success, object) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }
    
    internal func listCasaShows(params: Dictionary<String, AnyObject>, completion: (success: Bool, message: JSONDictionary?) -> ()) {
        
        post(clientURLRequestJSON("api/v1/pt/SHouseShows", params: params)) { (success, object) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }
    
    
    internal func listBandas(params: Dictionary<String, AnyObject>, completion: (success: Bool, message: JSONDictionary?) -> ()) {

        post(clientURLRequestJSON("api/v1/pt/bands", params: params)) { (success, object) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }
    
    internal func searchBands(params: Dictionary<String, AnyObject>, completion: (success: Bool, message: JSONDictionary?) -> ()) {
        
        get(clientURLRequest("api/v1/pt/bands?name=" + (params["name"] as! String).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())! + "&idUsuario=" + (params["idUsuario"] as! String), params: nil)) { (success, object) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }
    
    internal func iWill(params: Dictionary<String, AnyObject>, completion: (success: Bool, message: JSONDictionary?) -> ()) {

        post(clientURLRequestJSON("api/v1/pt/iWill", params: params)) { (success, object) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }
    
    internal func follow(params: Dictionary<String, AnyObject>, completion: (success: Bool, message: JSONDictionary?) -> ()) {
        
        post(clientURLRequestJSON("api/v1/pt/Favorites", params: params)) { (success, object) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }

    internal func searchSHouses(params: Dictionary<String, AnyObject>, completion: (success: Bool, message: JSONDictionary?) -> ()) {
        
        get(clientURLRequest("api/v1/pt/showhouses?name=" + (params["name"] as! String).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())! + "&idUsuario=" + (params["idUsuario"] as! String), params: nil)) { (success, object) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }
    
    internal func searchSpotifyBands(params: Dictionary<String, AnyObject>, completion: (success: Bool, message: JSONDictionary?) -> ()) {
        
        get(clientURLRequest("/v1/search?query=genre%3A%22" + (params["genres"] as! String).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())! + "%22&type=artist", params: nil)) { (success, object) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }
    
    internal func userUpdate(params: Dictionary<String, AnyObject>, completion: (success: Bool, message: JSONDictionary?) -> ()) {
        
        post(clientURLRequestForm("api/v1/pt/users", params: params)) { (success, object) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }
    
    
    internal func rsvp(params: Dictionary<String, AnyObject>, completion: (success: Bool, message: JSONDictionary?) -> ()) {
        
        post(clientURLRequestJSON("api/v1/pt/rsvp", params: params)) { (success, object) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: success, message: object as? JSONDictionary)
            })
        }
    }
 */
    

}