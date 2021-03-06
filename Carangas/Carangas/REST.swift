//
//  REST.swift
//  Carangas
//
//  Created by Usemobile PT000039 on 08/04/22.
//  Copyright © 2022 Eric Brito. All rights reserved.
//

import Foundation

enum carError {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}

enum RESTOperation {
    case save
    case update
    case delete
}

class REST {
    
    private static let basePath = "https://carangas.herokuapp.com/cars"
    
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        config.timeoutIntervalForRequest = 30.0
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()
    
    private static let session = URLSession(configuration: configuration)     //URLSession.shared
    
    //MARK: GET METHOD
    
    class func loadCars(onComplete: @escaping ([Cars]) -> Void, onError: @escaping (carError) -> Void) {
        // escaping significa que ele segura essa closure, pois vai ser utilizado depois, mesmo que seja encerrado.
        //primeiro passo criar a URL
        guard let url = URL(string: basePath) else {
            onError(.url)
            return
        }
        //criar a tarefa que vai executar essa requisição
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return
                }
                if response.statusCode == 200 {
                    guard let data = data else { return }
                    do {
                        let cars = try JSONDecoder().decode([Cars].self, from: data)
                        onComplete(cars)
                    } catch {
                        print(error.localizedDescription)
                        onError(.invalidJSON)
                    }
                } else {
                    print("Algum status inválido pelo servidor!")
                    onError(.responseStatusCode(code: response.statusCode))
                }
            } else {
                onError(.taskError(error: error!))
            }
        }
        //solicita ao servidor essas informações
        dataTask.resume()
    }
    
    //MARK: POST METHOD
    
    class func save(car: Cars, onComplete: @escaping (Bool) -> Void) {
        applyOperation(car: car, operation: .save, onComplete: onComplete)
    }
    
    class func update(car: Cars, onComplete: @escaping (Bool) -> Void) {
        applyOperation(car: car, operation: .update, onComplete: onComplete)
    }
    
    class func delete(car: Cars, onComplete: @escaping (Bool) -> Void) {
        applyOperation(car: car, operation: .delete, onComplete: onComplete)
    }
    
    private class func applyOperation(car: Cars, operation: RESTOperation, onComplete: @escaping (Bool)-> Void) {
        
        let urlString = basePath + "/" + (car._id ?? "")
        
        guard let url = URL(string: urlString) else {
            onComplete(false)
            return
        }
        var httpMethod: String = ""
        var request = URLRequest(url: url)
        
        switch operation {
        case .save:
            httpMethod = "POST"
        case .update:
            httpMethod = "PUT"
        case .delete:
            httpMethod = "DELETE"
        }
        request.httpMethod = httpMethod
        
        guard let json = try? JSONEncoder().encode(car) else {
            onComplete(false)
            return
        }
        request.httpBody = json
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            if error == nil {
                guard let response = response as? HTTPURLResponse, response.statusCode == 200, let _ = data else {
                    onComplete(false)
                    return
                }
                onComplete(true)
            } else {
                onComplete(false)
            }
        }
        dataTask.resume()
    }
}
