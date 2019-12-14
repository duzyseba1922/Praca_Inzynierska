import UIKit
import FirebaseDatabase

class PickClubViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var teamBadge: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    
    var teamSelect: String? = nil
    var teams = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        ref = Database.database().reference()
        refHandle = ref?.child("Teams").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? String
            if let actualPost = post {
                self.teams.append(actualPost)
                self.pickerView.reloadAllComponents()
                self.teams.sort()
                if(self.pickerView.numberOfRows(inComponent: 0) == 16){
                    AppInstance.hideLoader()
                }
            }
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        if CheckInternet.Connection(){
            if(self.pickerView.numberOfRows(inComponent: 0) == 0){
                AppInstance.showLoader()
            }
        }
        else{
            self.Alert(Message: "Brak połączenia z Internetem.")
        }
    }
    
    func Alert (Message: String){
        let alert = UIAlertController(title: "Wystąpił błąd", message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Spróbuj ponownie", style: UIAlertAction.Style.default) {
            UIAlertAction in
                UIApplication.shared.keyWindow?.rootViewController = self.storyboard!.instantiateViewController(withIdentifier: "Picker")
            AppInstance.hideLoader()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        teamBadge.image = UIImage(named: "Arka Gdynia")
    }
    
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teams.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: teams[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 255/255, green: 224/255, blue: 178/255, alpha: 0.9)])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row < teams.count else {
            return
        }
        teamSelect = teams[row]
        teamBadge.image = UIImage(named: "\(teamSelect!)")
    }
    
    func selectRow(_ row: Int,inComponent component: Int,animated: Bool){
        self.teamSelect = teams[row]
        performSegue(withIdentifier: "name", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "name" {
            let desView = segue.destination as! TabBarViewController
            let selectedTeam = self.teamSelect
            if (selectedTeam != nil)
            {
                desView.team = selectedTeam!
            }
            else
            {
                desView.team = "Arka Gdynia"
            }
        }
    }
}
