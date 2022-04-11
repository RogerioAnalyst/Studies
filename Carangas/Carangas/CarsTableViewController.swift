//
//  CarsTableViewController.swift
//  Carangas
//
//  Created by Eric Brito on 21/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class CarsTableViewController: UITableViewController {

    var cars: [Cars] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        REST.loadCars { (cars) in
            self.cars = cars
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } onError: { (error) in
            print(error)
            //            switch error {
            //            case .invalidJSON:
            //                print("JSON Inválido")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSegue" {
            let vc = segue.destination as! CarViewController
            vc.car = cars[tableView.indexPathForSelectedRow!.row]
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cars.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let car = cars[indexPath.row]
        cell.textLabel?.text = car.name
        cell.detailTextLabel?.text = car.brand
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let car = cars[indexPath.row]
            
            REST.delete(car: car) { (success) in
                if success {
                    //tem que remover também do nosso item chamando ele aqui e nao chamando o tableView.deleteRows
                    self.cars.remove(at: indexPath.row)
                    
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }
}
