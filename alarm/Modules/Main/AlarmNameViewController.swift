//
//  AlarmNameViewController.swift
//  alarm
//
//  Created by Константин Кифа on 27.07.2022.
//

import UIKit

class AlarmNameViewController: UIViewController {

    var alarmEditVC: AlarmEditViewController?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = alarmEditVC?.innerData?.name
    }
    
    @IBAction func changeValue(_ sender: UITextField) {
        navigationController?.popToRootViewController(animated: true)
        alarmEditVC?.innerData?.name = nameTextField.text!
        alarmEditVC?.tableView.reloadData()
    }

}
