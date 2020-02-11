import UIKit
import MarqueeLabel
import Firebase

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    var news = [[String]]()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoLabel: MarqueeLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = tabBarController as! TabBarViewController
        
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        
        switch tabBar.team {
            case "Lech Poznań", "Wisła Płock", "Piast Gliwice", "Raków Częstochowa":
                self.tabBarController?.tabBar.tintColor = UIColor.blue
            case "Lechia Gdańsk", "Śląsk Wrocław":
                self.tabBarController?.tabBar.tintColor = UIColor.systemGreen
            case "Legia Warszawa":
                self.tabBarController?.tabBar.tintColor = UIColor.white
            case "Cracovia", "Korona Kielce", "Wisła Kraków", "Górnik Zabrze", "ŁKS Łódź":
                self.tabBarController?.tabBar.tintColor = UIColor.red
            case "Jagiellonia Białystok", "Arka Gdynia":
                self.tabBarController?.tabBar.tintColor = UIColor.yellow
            case "Zagłębie Lubin":
                self.tabBarController?.tabBar.tintColor = UIColor.orange
            case "Pogoń Szczecin":
                if #available(iOS 13.0, *) {
                    self.tabBarController?.tabBar.tintColor = UIColor.systemIndigo
                } else {
                    self.tabBarController?.tabBar.tintColor = UIColor.blue
                }
            default:
                self.tabBarController?.tabBar.tintColor = UIColor.blue
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 10
        
        let url = "gs://praca-inzynierska-duzego.appspot.com/badges/\(normalize()).png"
        Storage.storage().reference(forURL: url).getData(maxSize: 999999999999999, completion: { (data, error) in

            guard let imageData = data, error == nil else {
                return
            }
            self.imageView.image = UIImage(data: imageData)
        })
        
        imageView.backgroundColor = UIColor(red: 255/255, green: 224/255, blue: 178/255, alpha: 0.9)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        
        AppInstance.showLoader()
        
        ref = Database.database().reference()
        refHandle = ref?.child("News/\(tabBar.team)").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                self.news.append(actualPost)
                self.tableView.reloadData()
                self.infoLabel.text = "\(tabBar.team), Założony: \(tabBar.founded), Barwy: \(tabBar.colors), Stadion: \(tabBar.stadium), Wartość drużyny: \(tabBar.teamValue), Sukcesy: \(tabBar.trophies.joined(separator: ", "))"
                self.infoLabel.type = .continuous
                self.infoLabel.textAlignment = .left
                self.infoLabel.speed = .duration(20.0)
                self.infoLabel.fadeLength = 15.0
                self.infoLabel.leadingBuffer = 40.0
                if(self.tableView.numberOfRows(inSection: 0) != 0){
                    AppInstance.hideLoader()
                }
            }
        })
    }
    
    func normalize() -> String {
        let tabBar = tabBarController as! TabBarViewController
        let original = ["Ą", "ą", "Ć", "ć", "Ę", "ę", "Ł", "ł", "Ń", "ń", "Ó", "ó", "Ś", "ś", "Ź", "ź", "Ż", "ż"]
        let normalized = ["A", "a", "C", "c", "E", "e", "L", "l", "N", "n", "O", "o", "S", "s", "Z", "z", "Z", "z"]
        var str = tabBar.team
        for x in 0...original.count - 1 {
            if original.contains(where: str.contains) == true {
                str = str.replacingOccurrences(of: original[x], with: normalized[x])
            } else {
                return str
            }
        }
        return str
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! FullNewsViewController
        let selectedRowIndex = self.tableView.indexPathForSelectedRow

        destinationVC.cellId = selectedRowIndex?.row
        destinationVC.news = news
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell")
        cell!.layer.masksToBounds = true
        cell!.layer.cornerRadius = 10
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.text = news[indexPath.row][0]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segue", sender: self)        
    }
}
