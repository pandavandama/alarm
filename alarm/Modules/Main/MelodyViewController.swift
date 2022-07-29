//
//  MelodyViewController.swift
//  alarm
//
//  Created by Константин Кифа on 28.07.2022.
//

import UIKit
import AVFoundation

class MelodyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    let musicList: [String] = ["a1","a2","a3","a4","a5","soundtrack"]
    var selectedSoundName: String?
    var player: AVAudioPlayer?
    var changeMusicName: ((String?)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewHeight?.constant = tableView.contentSize.height-1
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10.0
        tableView.tableHeaderView = UIView()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableViewHeight?.constant = tableView.contentSize.height-1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        musicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = musicList[indexPath.row]
        if selectedSoundName == musicList[indexPath.row]{
            cell.accessoryType = .checkmark
            selectedSoundName = ""
        } else{
            cell.accessoryType = .none
        }
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        changeMusicName?(musicList[indexPath.row])
        playSound(bool: true,soundName: musicList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        playSound(bool: false,soundName: musicList[indexPath.row])
    }
    
}
extension MelodyViewController{
    func playSound(bool: Bool,soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "caf") else { return }
        do {
               try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
               try AVAudioSession.sharedInstance().setActive(bool)
               player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
               guard let player = player else { return }
               player.play()

           } catch let error {
               print(error.localizedDescription)
           }
    }
}
