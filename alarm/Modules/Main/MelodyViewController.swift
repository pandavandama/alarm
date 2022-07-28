//
//  MelodyViewController.swift
//  alarm
//
//  Created by Константин Кифа on 28.07.2022.
//

import UIKit
import AVFoundation

class MelodyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    private let musicCount = 6
    var alarmEditVC: AlarmEditViewController?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    let musicList: [String] = ["a1","a2","a3","a4","a5","soundtrack"]
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
        musicCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell
        cell.textLabel?.text = musicList[indexPath.row]
        cell.textLabel?.textColor = .white
        return cell
    }
    var player: AVAudioPlayer?

    func playSound(bool: Bool,soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "caf") else { return }
        do {
               try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
               try AVAudioSession.sharedInstance().setActive(bool)

               /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
               player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

               /* iOS 10 and earlier require the following line:
               player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

               guard let player = player else { return }

               player.play()

           } catch let error {
               print(error.localizedDescription)
           }
    }
    func playMusic(bool: Bool){
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        alarmEditVC?.innerData?.soundName = musicList[indexPath.row]
        playSound(bool: true,soundName: alarmEditVC!.innerData!.soundName)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        playSound(bool: false,soundName: alarmEditVC!.innerData!.soundName)
    }
}
