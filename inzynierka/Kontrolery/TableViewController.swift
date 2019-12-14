import UIKit
import MarqueeLabel

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var table = [[String]]()
    
    @IBOutlet weak var labelsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var teamNameLabel: MarqueeLabel!
    @IBOutlet weak var labelBackground: UIView!
    @IBOutlet weak var lpLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var matchesLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = tabBarController as! TabBarViewController
        
        switch tabBar.team {
        case "Lech Poznań", "Wisła Płock", "Piast Gliwice", "Raków Częstochowa":
            self.labelBackground.backgroundColor = UIColor.blue.withAlphaComponent(0.75)
        case "Lechia Gdańsk", "Śląsk Wrocław":
            self.labelBackground.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.75)
        case "Legia Warszawa":
            self.labelBackground.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        case "Cracovia", "Korona Kielce", "Wisła Kraków", "Górnik Zabrze", "ŁKS Łódź":
            self.labelBackground.backgroundColor = UIColor.red.withAlphaComponent(0.75)
        case "Jagiellonia Białystok", "Arka Gdynia":
            self.labelBackground.backgroundColor = UIColor.yellow.withAlphaComponent(0.75)
        case "Zagłębie Lubin":
            self.labelBackground.backgroundColor = UIColor.orange.withAlphaComponent(0.75)
        case "Pogoń Szczecin":
            if #available(iOS 13.0, *) {
                self.labelBackground.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.75)
            } else {
                self.labelBackground.backgroundColor = UIColor.blue.withAlphaComponent(0.75)
            }
        default:
            self.labelBackground.backgroundColor = UIColor.blue.withAlphaComponent(0.75)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        table = tabBar.table
        tableView.reloadData()
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.tableFooterView = UIView(frame: frame)
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 10
        
        imageView.image = UIImage(named: "\(tabBar.team)")
        imageView.backgroundColor = UIColor(red: 255/255, green: 224/255, blue: 178/255, alpha: 0.9)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        
        AppInstance.showLoader()
        if(tableView.numberOfRows(inSection: 0) != 0){
            AppInstance.hideLoader()
        }
        
        teamNameLabel.text = "\(tabBar.team), Założony: \(tabBar.founded), Barwy: \(tabBar.colors), Stadion: \(tabBar.stadium), Wartość drużyny: \(tabBar.teamValue), Sukcesy: \(tabBar.trophies.joined(separator: ", "))"
        teamNameLabel.type = .continuous
        teamNameLabel.textAlignment = .left
        teamNameLabel.speed = .duration(20.0)
        teamNameLabel.fadeLength = 15.0
        teamNameLabel.leadingBuffer = 40.0
        
        labelsView.layer.masksToBounds = true
        labelsView.layer.cornerRadius = 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return table.count
    }
    
    func getAttributedBoldString(string: String, boldText : String) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString.init(string: string)
        let boldedRange = NSRange(string.range(of: boldText)!, in: string)
        attrStr.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .bold)], range: boldedRange)
        return attrStr
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath as IndexPath) as! TableViewCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        cell.position.text = "\(indexPath.row + 1)"
        cell.teamName.text = table[indexPath.row][0]
        cell.matches.text = table[indexPath.row][1]
        cell.goals.text = table[indexPath.row][2]
        cell.points.text = table[indexPath.row][3]

        let tabBar = tabBarController as! TabBarViewController
        
        if (tabBar.team == "Arka Gdynia" || tabBar.team == "Jagiellonia Białystok"){
            lpLabel.textColor = UIColor.black
            teamLabel.textColor = UIColor.black
            matchesLabel.textColor = UIColor.black
            goalsLabel.textColor = UIColor.black
            pointsLabel.textColor = UIColor.black
        }
        
        if (cell.teamName.text == tabBar.team){
            cell.backgroundColor = UIColor.yellow.withAlphaComponent(0.75)
        }
        else {
            cell.backgroundColor = UIColor(red: 255/255, green: 224/255, blue: 178/255, alpha: 0.9)
        }
        cell.position.layer.masksToBounds = true
        cell.position.layer.cornerRadius = 5
        if (indexPath.row >= 8 ){
            cell.position.backgroundColor = UIColor.red
        }
        else {
            cell.position.backgroundColor = UIColor.blue
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "🔵 - grupa mistrzowska\n🔴 - grupa spadkowa"
    }
}
