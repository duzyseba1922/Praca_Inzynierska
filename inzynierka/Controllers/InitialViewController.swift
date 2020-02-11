import UIKit

class InitialViewController: UIViewController {
    
    var chosenOption: String = ""
    
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var adminButton: UIButton!
    
    @IBAction func userButton(_ sender: Any) {
        chosenOption = "user"
        performSegue(withIdentifier: "user", sender: self)
    }
    
    @IBAction func adminButton(_ sender: Any) {
        chosenOption = "admin"
        performSegue(withIdentifier: "admin", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userButton.layer.cornerRadius = 30
        adminButton.layer.cornerRadius = 30
        
        userButton.layer.borderColor = UIColor.white.cgColor
        adminButton.layer.borderColor = UIColor.white.cgColor
        userButton.layer.borderWidth = 3
        adminButton.layer.borderWidth = 3
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "user" {
            let vc = segue.destination as! PickClubViewController
            vc.chosenOption = chosenOption
        } else if segue.identifier == "admin" {
            let vc = segue.destination as! AdminLoginController
            vc.chosenOption = chosenOption
        }
    }
}
