//
//  RemoveRefeicaoViewController.swift
//  eggplant-brownie
//
//  Created by Usemobile PT000039 on 29/03/22.
//  Copyright © 2022 Alura. All rights reserved.
//

import UIKit

class RemoveRefeicaoViewController {
    
    let controller: UIViewController
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func exibe(_ refeicao: Refeicao, handler: @escaping (UIAlertAction) -> Void) {
        let alerta = UIAlertController(title: refeicao.nome, message: refeicao.detalhes(), preferredStyle: .alert)
        
        let botaocancelar = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alerta.addAction(botaocancelar)

        let botaoRemover = UIAlertAction(title: "Remover", style: .destructive, handler: handler)
        alerta.addAction(botaoRemover)
        
        controller.present(alerta, animated: true)
    }
}
