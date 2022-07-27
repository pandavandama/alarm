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
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeValue(_ sender: UITextField) {
        print("opaa")
        navigationController?.popToRootViewController(animated: true)
        alarmEditVC?.innerData?.name = nameTextField.text!
        print(alarmEditVC?.innerData)
//        alarmEditVC?.loadData()
        alarmEditVC?.tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
