//
//  ViewController.swift
//  Day4
//
//  Created by Ilya Krupko on 11.05.23.
//

import UIKit

struct RowData : Hashable {
    let name : String
    var isChecked: Bool = false
    
    static func ==(lhs:RowData, rhs:RowData) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

class ViewController: UITableViewController {
    
    var data = Array(1...30).map { RowData(name: String($0)) }
    
    lazy var dataSource = UITableViewDiffableDataSource<Int, RowData>(tableView: tableView) { tableView, indexPath, model in
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = model.name
        cell.accessoryType = model.isChecked ? .checkmark : .none
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Task 4"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(shuffle))
        tableView.register(Cell.self)
        snapshot()
    }
    
    @objc func shuffle() {
        data.shuffle()
        snapshot()
    }
    
    fileprivate func snapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, RowData>()
        snapshot.appendSections([0])
        snapshot.appendItems(data, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { snapshot() }
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        var selectedModel = data[indexPath.row]
        if selectedModel.isChecked {
            data[indexPath.row].isChecked = false
            cell.accessoryType = .none
            cell.setSelected(false, animated: true)
            return
        }
        selectedModel.isChecked = !selectedModel.isChecked
        data.remove(at: data.firstIndex(of: selectedModel)!)
        data.insert(selectedModel, at: 0)
        
        cell.accessoryType = selectedModel.isChecked ? .checkmark : .none
        cell.setSelected(false, animated: true)
    }
}

