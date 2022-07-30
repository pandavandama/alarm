//
//  AlarmNameViewController.swift
//  alarm
//
//  Created by Константин Кифа on 27.07.2022.
//

import UIKit

class AlarmNameViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBAction func changeValue(_ sender: UITextField) {
        navigationController?.popToRootViewController(animated: true)
        changeName?(nameTextField.text)
    }
    var name: String?
    var changeName: ((String?)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = name
    }
}
