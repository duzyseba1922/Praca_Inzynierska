import UIKit
import MarqueeLabel

class SquadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var coach = [[String]]()
    var goalkeeper = [[String]]()
    var defender = [[String]]()
    var midfielder = [[String]]()
    var striker = [[String]]()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        AppInstance.showLoader()
        
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 10
        coach = tabBar.coach
        goalkeeper = tabBar.goalkeeper
        defender = tabBar.defender
        midfielder = tabBar.midfielder
        striker = tabBar.striker
        tableView.reloadData()
        if(tableView.numberOfRows(inSection: 0) != 0){
            AppInstance.hideLoader()
        }
        imageView.image = tabBar.badge
        imageView.backgroundColor = UIColor(red: 255/255, green: 224/255, blue: 178/255, alpha: 0.9)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabBar = tabBarController as! TabBarViewController
        let destinationVC = segue.destination as! PlayerInfoController
        let selectedRowIndex = self.tableView.indexPathForSelectedRow
        
        destinationVC.cellId = selectedRowIndex?.row
        destinationVC.team = tabBar.team
        let position = selectedRowIndex?.section
        switch position! {
            case 0:
                destinationVC.pos = "Trener"
                destinationVC.nation = coach[selectedRowIndex!.row][1]
                destinationVC.name = coach[selectedRowIndex!.row][0]
            case 1:
                destinationVC.pos = "Bramkarz"
                destinationVC.nation = goalkeeper[selectedRowIndex!.row][1]
                destinationVC.name = goalkeeper[selectedRowIndex!.row][0]
            case 2:
                destinationVC.pos = "Obrońca"
                destinationVC.nation = defender[selectedRowIndex!.row][1]
                destinationVC.name = defender[selectedRowIndex!.row][0]
            case 3:
                destinationVC.pos = "Pomocnik"
                destinationVC.nation = midfielder[selectedRowIndex!.row][1]
                destinationVC.name = midfielder[selectedRowIndex!.row][0]
            case 4:
                destinationVC.pos = "Napastnik"
                destinationVC.nation = striker[selectedRowIndex!.row][1]
                destinationVC.name = striker[selectedRowIndex!.row][0]
            default:
                destinationVC.pos = "Piłkarz"
                destinationVC.nation = coach[selectedRowIndex!.row][1]
                destinationVC.name = coach[selectedRowIndex!.row][0]
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "squad", sender: self)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        label.textColor = UIColor.white
        switch section {
            case 0:
                label.text = "Trener"
            case 1:
                label.text = "Bramkarze"
            case 2:
                label.text = "Obrońcy"
            case 3:
                label.text = "Pomocnicy"
            case 4:
                label.text = "Napastnicy"
            default:
                label.text = "Skład"
        }
        
        let tabBar = tabBarController as! TabBarViewController
        
        switch tabBar.team {
            case "Lech Poznań", "Wisła Płock", "Piast Gliwice", "Raków Częstochowa":
                label.backgroundColor = UIColor.blue.withAlphaComponent(0.7)
            case "Lechia Gdańsk", "Śląsk Wrocław":
                label.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.7)
            case "Legia Warszawa":
                label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            case "Cracovia", "Korona Kielce", "Wisła Kraków", "Górnik Zabrze", "ŁKS Łódź":
                label.backgroundColor = UIColor.red.withAlphaComponent(0.7)
            case "Jagiellonia Białystok", "Arka Gdynia":
                label.backgroundColor = UIColor.yellow.withAlphaComponent(0.7)
                label.textColor = UIColor.black
            case "Zagłębie Lubin":
                label.backgroundColor = UIColor.orange.withAlphaComponent(0.7)
            case "Pogoń Szczecin":
                if #available(iOS 13.0, *) {
                    label.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.7)
                } else {
                    label.backgroundColor = UIColor.blue.withAlphaComponent(0.7)
                }
            default:
                label.backgroundColor = UIColor.blue.withAlphaComponent(0.7)
        }
        return label
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return coach.count
            case 1:
                return goalkeeper.count
            case 2:
                return defender.count
            case 3:
                return midfielder.count
            case 4:
                return striker.count
            default:
                return coach.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "squadCell")
        cell!.layer.masksToBounds = true
        cell!.layer.cornerRadius = 10
        switch indexPath.section {
            case 0:
                cell?.textLabel?.text = coach[indexPath.row][0]
                cell?.detailTextLabel?.text = coach[indexPath.row][1]
            case 1:
                cell?.textLabel?.text = goalkeeper[indexPath.row][0]
                cell?.detailTextLabel?.text = goalkeeper[indexPath.row][1]
            case 2:
                cell?.textLabel?.text = defender[indexPath.row][0]
                cell?.detailTextLabel?.text = defender[indexPath.row][1]
            case 3:
                cell?.textLabel?.text = midfielder[indexPath.row][0]
                cell?.detailTextLabel?.text = midfielder[indexPath.row][1]
            case 4:
                cell?.textLabel?.text = striker[indexPath.row][0]
                cell?.detailTextLabel?.text = striker[indexPath.row][1]
            default:
                cell?.textLabel?.text = coach[indexPath.row][0]
                cell?.detailTextLabel?.text = coach[indexPath.row][1]
        }
        return cell!
    }
}

