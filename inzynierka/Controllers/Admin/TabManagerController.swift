import UIKit

class TabManagerController: UIViewController {

    var team: String = ""
    var badge: UIImage?
    var chosenOption: String = ""
    var chosenTab: String = ""
    
    @IBOutlet weak var optionLabel: UILabel!
    
    @IBOutlet weak var newsButton: UIButton!
    @IBOutlet weak var tableButton: UIButton!
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var squadButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var teamsButton: UIButton!
    
    @IBAction func newsButton(_ sender: Any) {
        chosenTab = "News"
        if chosenOption == "add" {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "News Manager Controller") as! NewsManagerController
            vc.chosenOption = self.chosenOption
            vc.chosenTab = self.chosenTab
            vc.team = self.team
            vc.modalPresentationStyle = .pageSheet
            self.present(vc, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "recordsList", sender: self)
        }
    }
    
    @IBAction func tableButton(_ sender: Any) {
        chosenTab = "Table"
        if chosenOption == "delete" {
            deleteErrorAlert(tab: chosenTab)
        } else if chosenOption == "add" {
            addErrorAlert(tab: chosenTab)
        } else {
            performSegue(withIdentifier: "table", sender: self)
        }
    }
    
    @IBAction func scheduleButton(_ sender: Any) {
        chosenTab = "Schedule"
        if chosenOption == "add" {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "Schedule Manager Controller") as! ScheduleManagerController
            vc.chosenOption = chosenOption
            vc.chosenTab = chosenTab
            vc.team = team
            vc.modalPresentationStyle = .pageSheet
            present(vc, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "recordsList", sender: self)
        }
    }
    
    @IBAction func squadButton(_ sender: Any) {
        chosenTab = "Squad"
        if chosenOption == "add" {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "Squad Manager Controller") as! SquadManagerController
            vc.chosenOption = chosenOption
            vc.chosenTab = chosenTab
            vc.team = team
            vc.modalPresentationStyle = .pageSheet
            present(vc, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "recordsList", sender: self)
        }
    }
    
    @IBAction func infoButton(_ sender: Any) {
        chosenTab = "Info"
        if chosenOption == "delete" {
            deleteErrorAlert(tab: chosenTab)
        } else if chosenOption == "add" {
            addErrorAlert(tab: chosenTab)
        } else {
            performSegue(withIdentifier: "info", sender: self)
        }
    }
    
    @IBAction func teamsButton(_ sender: Any) {
        chosenTab = "Teams"
        if chosenOption == "add" {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "Team Manager Controller") as! TeamManagerController
            vc.chosenOption = chosenOption
            vc.chosenTab = chosenTab
            vc.modalPresentationStyle = .pageSheet
            present(vc, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "recordsList", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch chosenOption {
            case "add" : optionLabel.text = "Wybierz co chcesz dodać"
            case "edit" : optionLabel.text = "Wybierz co chcesz edytować"
            case "delete" : optionLabel.text = "Wybierz co chcesz usunąć"
            default: optionLabel.text = "Wybierz co chcesz zrobić"
        }
        
        newsButton.layer.cornerRadius = 20
        tableButton.layer.cornerRadius = 20
        scheduleButton.layer.cornerRadius = 20
        squadButton.layer.cornerRadius = 20
        infoButton.layer.cornerRadius = 20
        teamsButton.layer.cornerRadius = 20
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recordsList" {
            let vc = segue.destination as! RecordsListController
            vc.chosenOption = chosenOption
            vc.chosenTab = chosenTab
            vc.team = team
            vc.badge = badge
        } else if segue.identifier == "table" {
            let vc = segue.destination as! TableManagerController
            vc.chosenOption = chosenOption
            vc.chosenTab = chosenTab
            vc.team = team
        } else if segue.identifier == "info" {
            let vc = segue.destination as! InfoManagerController
            vc.chosenOption = chosenOption
            vc.chosenTab = chosenTab
            vc.team = team
        }
    }
    
    func deleteErrorAlert(tab: String) {
        let alert = UIAlertController(title: "Nie możesz usunąć tej zakładki", message: "Aby usunąć dane z zakładki \(tab) musisz usunąć drużynę z zakładki Drużyny", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okej", style: UIAlertAction.Style.default))
        present(alert, animated: true, completion: nil)
    }
    
    func addErrorAlert(tab: String) {
        let alert = UIAlertController(title: "Nie możesz dodawać danych do tej zakładki", message: "Aby dodać dane do zakładki \(tab) musisz wybrać zakładkę 'Edytuj dane' w poprzednim oknie", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okej", style: UIAlertAction.Style.default))
        present(alert, animated: true, completion: nil)
    }
}
