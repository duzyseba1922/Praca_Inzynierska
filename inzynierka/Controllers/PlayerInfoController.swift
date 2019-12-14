import UIKit

class PlayerInfoController: UIViewController {
    
    var cellId: Int?
    var team: String = ""
    var nation: String = ""
    var pos: String = ""
    var name: String = ""
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var nationality: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var club: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        
        playerImage.image = UIImage(named: "\(name)")
        playerImage.layer.masksToBounds = true
        playerImage.layer.cornerRadius = 10
        
        cancelButton.layer.masksToBounds = true
        
        switch team {
            case "Lech Poznań", "Wisła Płock", "Piast Gliwice", "Raków Częstochowa":
                playerName.textColor = UIColor.blue
            case "Lechia Gdańsk", "Śląsk Wrocław":
                playerName.textColor = UIColor.systemGreen 
            case "Legia Warszawa":
                playerName.textColor = UIColor.black
            case "Cracovia", "Korona Kielce", "Wisła Kraków", "Górnik Zabrze", "ŁKS Łódź":
                playerName.textColor = UIColor.red
            case "Jagiellonia Białystok", "Arka Gdynia":
                playerName.textColor = UIColor.yellow
            case "Zagłębie Lubin":
                playerName.textColor = UIColor.orange
            case "Pogoń Szczecin":
                if #available(iOS 13.0, *) {
                    playerName.textColor = UIColor.systemIndigo
                } else {
                    playerName.textColor = UIColor.blue
                }
            default:
                self.tabBarController?.tabBar.tintColor = UIColor.blue
        }
        
        club.text = team
        nationality.text = nation
        playerName.text = name
        position.text = pos
        
    }

}
