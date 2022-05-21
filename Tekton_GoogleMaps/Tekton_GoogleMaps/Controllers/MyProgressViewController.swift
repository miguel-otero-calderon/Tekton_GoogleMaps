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
    var runs: [MyProgressCellData] = [
        MyProgressCellData(timer: "01:20:30", source: "A: Av. Aramburu 245 Surquillo", target: "B: Av. Brasil 245 Magdalena", distance: "20.0 km"),
        MyProgressCellData(timer: "02:30:30", source: "A: Av. Aramburu 245 Surquillo", target: "B: Av. Brasil 245 Magdalena", distance: "20.0 km"),
        MyProgressCellData(timer: "05:20:30", source: "A: Av. Aramburu 245 Surquillo", target: "B: Av. Brasil 245 Magdalena", distance: "20.0 km"),
        MyProgressCellData(timer: "06:20:30", source: "A: Av. Aramburu 245 Surquillo", target: "B: Av. Brasil 245 Magdalena", distance: "20.0 km"),
        MyProgressCellData(timer: "07:20:30", source: "A: Av. Aramburu 245 Surquillo", target: "B: Av. Brasil 245 Magdalena", distance: "20.0 km"),
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            UINib(nibName: MyProgressCell.identifier, bundle: nil), forCellReuseIdentifier: MyProgressCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
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
        return runs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: MyProgressCell.identifier, for: indexPath) as? MyProgressCell
        cell?.setupCell(data: runs[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}
