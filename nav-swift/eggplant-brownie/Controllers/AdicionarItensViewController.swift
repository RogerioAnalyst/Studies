//
//  AdicionarItensViewController.swift
//  eggplant-brownie
//
//  Created by Usemobile PT000039 on 17/03/22.
//  Copyright © 2022 Alura. All rights reserved.
//

import UIKit

protocol AdicionarItensDelegate {
    func add(_ item: Item)
}

class AdicionarItensViewController: UIViewController {

    //MARK: IBOutlets
    
    @IBOutlet weak var textFieldNome: UITextField!
    @IBOutlet weak var textFieldCalorias: UITextField!
    
    //MARK: Atributos
    
    var delegate: AdicionarItensDelegate?
    
    init(delegate: AdicionarItensDelegate) {
        super.init(nibName: "AdicionarItensViewController", bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: IBAction
    
    @IBAction func adicionarItem(_ sender: Any) {
        
        guard let nome = textFieldNome.text, let calorias = textFieldCalorias.text else { return }
        
        guard let numeroDeCalorias = Double(calorias) else { return }
        
        let item = Item(nome: nome, calorias: numeroDeCalorias)
        
        delegate?.add(item)
        
        self.navigationController?.popViewController(animated: true)
    }
}
