import UIKit
import FirebaseStorage

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
        
        let url = "gs://praca-inzynierska-duzego.appspot.com/players/\(team)/\(normalize()).png"
        Storage.storage().reference(forURL: url).getData(maxSize: 999999999999999, completion: { (data, error) in

            guard let imageData = data, error == nil else {
                return
            }
            self.playerImage.image = UIImage(data: imageData)

        })
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

    func normalize() -> String {
        let original = ["Ą", "ą", "Ć", "ć", "Ę", "ę", "Ł", "ł", "Ń", "ń", "Ó", "ó", "Ś", "ś", "Ź", "ź", "Ż", "ż"]
        let normalized = ["A", "a", "C", "c", "E", "e", "L", "l", "N", "n", "O", "o", "S", "s", "Z", "z", "Z", "z"]
        var str = name
        for x in 0...original.count - 1 {
            if original.contains(where: str.contains) == true {
                str = str.replacingOccurrences(of: original[x], with: normalized[x])
            } else {
                return str
            }
        }
        return str
    }
}
