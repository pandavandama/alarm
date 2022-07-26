//
//  ViewController.swift
//  alarm
//
//  Created by Константин Кифа on 25.07.2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataList: [SpecificAlarm] = []
    var labelBigTitle: UILabel?
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(section)
        if section == 0{
            return 1
        }else{
            return dataList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewCell.id, for: indexPath) as! AlarmTableViewCell
        
        
        print(indexPath)
        if indexPath.row == 0{
            cell.bindView(data: dataList[indexPath.section])
        }else{
            cell.bindView(data: dataList[indexPath.row])
        }
        
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        35.0
    }
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return "Section \(section)"
    //    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var title = ""
        
        
        
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        if section==0{
            title="Сон | пробуждение"
            let image = UIImage(systemName: "bed.double.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 2, weight: .bold, scale: .small))?.withTintColor(.white, renderingMode: .alwaysOriginal)
             

            label.addTextWithImage(text: title, image: image!, imageBehindText: false, keepPreviousText: false)
        }else{
            title="Другие"
            label.text = title

        }
        


//        label.attributedText = completeText
        //        label.addSubview()
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        headerView.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
        
        return headerView
    }
    
    func dataInit(){
        for i in 0...10{
            dataList.append(SpecificAlarm(time: "00:0\(i)", swich: .random()))
        }
        print(dataList)
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataInit()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        
        
        
        header.backgroundColor = .clear
        
        labelBigTitle = UILabel(frame: header.bounds)
        labelBigTitle!.text = "Будильник"
        labelBigTitle!.font = .boldSystemFont(ofSize: 30)
        labelBigTitle!.textColor = .white
        header.addSubview(labelBigTitle!)
        header.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: labelBigTitle!.frame.height)
        
        tableView.tableHeaderView = header
        
        tableView.register(AlarmTableViewCell.nib(), forCellReuseIdentifier: AlarmTableViewCell.id)
        // Do any additional setup after loading the view.
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(-scrollView.contentOffset.y)
        labelBigTitle?.font = .boldSystemFont(ofSize: 30+(-scrollView.contentOffset.y/50))
    }
    
}

extension UILabel {
    /**
     This function adding image with text on label.

     - parameter text: The text to add
     - parameter image: The image to add
     - parameter imageBehindText: A boolean value that indicate if the imaga is behind text or not
     - parameter keepPreviousText: A boolean value that indicate if the function keep the actual text or not
     */
    func addTextWithImage(text: String, image: UIImage, imageBehindText: Bool, keepPreviousText: Bool) {
        
//        image.withTintColor(UIColor.white)
                    let lAttachment = NSTextAttachment()
        lAttachment.image = image

        // 1pt = 1.32px
        let lFontSize = round(self.font.pointSize * 0.70)
        let lRatio = image.size.width / image.size.height

        lAttachment.bounds = CGRect(x: 0, y: ((self.font.capHeight - lFontSize) / 2).rounded(), width: lRatio * lFontSize, height: lFontSize)

        let lAttachmentString = NSAttributedString(attachment: lAttachment)

        if imageBehindText {
            let lStrLabelText: NSMutableAttributedString

            if keepPreviousText, let lCurrentAttributedString = self.attributedText {
                lStrLabelText = NSMutableAttributedString(attributedString: lCurrentAttributedString)
                lStrLabelText.append(NSMutableAttributedString(string: text))
            } else {
                lStrLabelText = NSMutableAttributedString(string: text)
            }

            lStrLabelText.append(lAttachmentString)
            self.attributedText = lStrLabelText
        } else {
            let lStrLabelText: NSMutableAttributedString

            if keepPreviousText, let lCurrentAttributedString = self.attributedText {
                lStrLabelText = NSMutableAttributedString(attributedString: lCurrentAttributedString)
                lStrLabelText.append(NSMutableAttributedString(attributedString: lAttachmentString))
                lStrLabelText.append(NSMutableAttributedString(string: text))
            } else {
                lStrLabelText = NSMutableAttributedString(attributedString: lAttachmentString)
                lStrLabelText.append(NSMutableAttributedString(string: text))
            }

            self.attributedText = lStrLabelText
        }
    }

    func removeImage() {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}
