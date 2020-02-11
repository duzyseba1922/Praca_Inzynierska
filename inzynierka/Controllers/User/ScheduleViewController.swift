import UIKit
import MarqueeLabel

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var schedule = [[String]]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var infoLabel: MarqueeLabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = tabBarController as! TabBarViewController
        
        infoLabel.text = "\(tabBar.team), Założony: \(tabBar.founded), Barwy: \(tabBar.colors), Stadion: \(tabBar.stadium), Wartość drużyny: \(tabBar.teamValue), Sukcesy: \(tabBar.trophies.joined(separator: ", "))"
        infoLabel.type = .continuous
        infoLabel.textAlignment = .left
        infoLabel.speed = .duration(20.0)
        infoLabel.fadeLength = 15.0
        infoLabel.leadingBuffer = 40.0
        
        imageView.image = tabBar.badge
        imageView.backgroundColor = UIColor(red: 255/255, green: 224/255, blue: 178/255, alpha: 0.9)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        
        AppInstance.showLoader()
        schedule = tabBar.schedule
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        if(tableView.numberOfRows(inSection: 0) != 0){
            AppInstance.hideLoader()
        }
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 10
    }
    
    func getAttributedBoldString(string: String, boldText : String) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString.init(string: string)
        let boldedRange = NSRange(string.range(of: boldText)!, in: string)
        attrStr.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .bold)], range: boldedRange)
        return attrStr
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tabBar = tabBarController as! TabBarViewController
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath)
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        switch schedule[indexPath.row][4] {
            case "true":
                cell.textLabel?.text = "\(tabBar.team) \(schedule[indexPath.row][2]):\(schedule[indexPath.row][3]) \(schedule[indexPath.row][1])"
            case "false":
                cell.textLabel?.text = "\(schedule[indexPath.row][1]) \(schedule[indexPath.row][3]):\(schedule[indexPath.row][2]) \(tabBar.team)"
            default:
                cell.textLabel?.text = "\(tabBar.team) \(schedule[indexPath.row][2]):\(schedule[indexPath.row][3]) \(schedule[indexPath.row][1])"
        }
        
        cell.detailTextLabel?.text = schedule[indexPath.row][0]
        cell.textLabel!.attributedText = getAttributedBoldString(string: cell.textLabel!.text!, boldText: tabBar.team)
        
        if (cell.detailTextLabel!.text == schedule[0][0]){
            cell.backgroundColor = UIColor.yellow.withAlphaComponent(0.75)
        }
        else {
            cell.backgroundColor = UIColor(red: 255/255, green: 224/255, blue: 178/255, alpha: 0.9)
        }
        
        return cell
    }
}
