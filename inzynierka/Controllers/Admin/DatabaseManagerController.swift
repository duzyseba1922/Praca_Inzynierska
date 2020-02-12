import UIKit

class DatabaseManagerController: UIViewController, UIAdaptivePresentationControllerDelegate {

    var team: String = ""
    var badge: UIImage?
    var option: String = ""
    
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamBadge: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func addButton(_ sender: Any) {
        option = "add"
        performSegue(withIdentifier: "tabManager", sender: self)
    }
    
    @IBAction func editButton(_ sender: Any) {
        option = "edit"
        performSegue(withIdentifier: "tabManager", sender: self)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        option = "delete"
        performSegue(withIdentifier: "tabManager", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.layer.cornerRadius = 20
        editButton.layer.cornerRadius = 20
        deleteButton.layer.cornerRadius = 20
        
        teamName.text = team
        teamBadge.image = badge
    }
    
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        teamName.layoutIfNeeded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tabManager" {
            let vc = segue.destination as! TabManagerController
            vc.chosenOption = option
            vc.team = team
            vc.badge = badge
        }
    }
}
