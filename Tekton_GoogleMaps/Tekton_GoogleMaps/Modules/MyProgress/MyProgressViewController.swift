//
//  MyProgressViewController.swift
//  Tekton_GoogleMaps
//
//  Created by Miguel on 20/05/22.
//

import Foundation
import UIKit

class MyProgressViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var routes: [MapViewModel.Route] = []
    var routesPersistence:[RoutePersistence] = []
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            UINib(nibName: MyProgressCell.identifier, bundle: nil), forCellReuseIdentifier: MyProgressCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        getRoutesLocal()
    }
    
    func getRoutesLocal() {
        do {
            routesPersistence = try MapViewController.context.fetch(RoutePersistence.fetchRequest())
        } catch {
            print("Error retrieve core data")
        }
        
        routes = []
        for routePersistence in routesPersistence {
            if let route = routePersistence.toRoute() {
                routes.append(route)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
extension MyProgressViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: MyProgressCell.identifier, for: indexPath) as? MyProgressCell
        let route = routes[indexPath.row]
        let data = MyProgressModel.CellData(route: route)
        cell?.setupCell(data: data)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MyProgressCell.heightCell
    }
}
