//
//  Alert.swift
//  eggplant-brownie
//
//  Created by Usemobile PT000039 on 28/03/22.
//  Copyright © 2022 Alura. All rights reserved.
//

import UIKit

class Alerta {
    
    let controller: UIViewController
    
    init(controller: UIViewController){
        self.controller = controller
    }
    
    func exibe(titulo: String = "Atenção", mensagem: String){
        let alert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let okaction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        controller.present(alert, animated: true)
        alert.addAction(okaction)
    }
}
