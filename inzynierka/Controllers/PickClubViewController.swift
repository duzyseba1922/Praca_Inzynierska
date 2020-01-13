import UIKit
import FirebaseDatabase
import FirebaseStorage

class PickClubViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var teamBadge: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    
    var teamSelect: String? = nil
    var teams = [String]()
    var badge: UIImage?
    var badgesList = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        getTeams()
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
    
    func getTeams() {
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
        getBadge(team: "Arka Gdynia")
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
        teamBadge.image = UIImage(named: "ekstralogo")
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
        AppInstance.showLoader()
        teamSelect = teams[row]
        if teamSelect == nil {
            getBadge(team: "Arka Gdynia")
        }
        else {
            getBadge(team: normalize())
        }
    }
    
    func getBadge(team: String){
        let url = "gs://praca-inzynierska-duzego.appspot.com/badges/\(team).png"
        Storage.storage().reference(forURL: url).getData(maxSize: 999999999999999, completion: { (data, error) in

            guard let imageData = data, error == nil else {
                return
            }
            self.teamBadge.image = UIImage(data: imageData)
            AppInstance.hideLoader()
        })
    }
    
    func normalize() -> String {
        let original = ["Ą", "ą", "Ć", "ć", "Ę", "ę", "Ł", "ł", "Ń", "ń", "Ó", "ó", "Ś", "ś", "Ź", "ź", "Ż", "ż"]
        let normalized = ["A", "a", "C", "c", "E", "e", "L", "l", "N", "n", "O", "o", "S", "s", "Z", "z", "Z", "z"]
        var str = teamSelect!
        for x in 0...original.count - 1 {
            if original.contains(where: str.contains) == true {
                str = str.replacingOccurrences(of: original[x], with: normalized[x])
            } else {
                return str
            }
        }
        return str
    }
    
    func selectRow(_ row: Int,inComponent component: Int,animated: Bool){
        self.teamSelect = teams[row]
        performSegue(withIdentifier: "name", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "name" {
            let desView = segue.destination as! TabBarViewController
            desView.badge = teamBadge.image
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
