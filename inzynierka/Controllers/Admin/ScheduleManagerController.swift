import UIKit
import Firebase

protocol scheduleDelegate {
   func updateSchedule()
}

class ScheduleManagerController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    var delegate: scheduleDelegate!
    
    var teams = [String]()
    var list = [[String]]()
    var team: String = ""
    var oponent: String = ""
    var pickedDate: String = ""
    var chosenOption: String = ""
    var chosenTab: String = ""
    var cellId: Int = 0
    var intKeys = [Int]()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var oponentPicker: UIPickerView!
    @IBOutlet weak var goalsScored: UITextField!
    @IBOutlet weak var goalsConceded: UITextField!
    @IBOutlet weak var homeOrAwaySwitch: UISwitch!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        ref = Database.database().reference()
        getKeys()
        if chosenOption == "add" {
            getTeams()
        }
        
        if let indexPosition = teams.firstIndex(of: team){
            teams.remove(at: indexPosition)
        }
        
        goalsScored.delegate = self
        goalsConceded.delegate = self
        oponentPicker.delegate = self
        oponentPicker.dataSource = self
        confirmButton.layer.cornerRadius = 10
        
        if chosenOption == "edit" {
            homeOrAwaySwitch.isOn = NSString(string: list[cellId][4]).boolValue
            oponent = list[cellId][1]
            setDefaultValue(item: oponent)
            goalsScored.text = list[cellId][2]
            goalsConceded.text = list[cellId][3]
            datePicker.date = dateFormatter.date(from: list[cellId][0])!
        }
        
        getSchedule()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func getKeys() {
        ref?.child("\(chosenTab)/\(team)").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = Int(snap.key)
                self.intKeys.append(key!)
            }
        })
    }
    
    func getSchedule(){
        list.removeAll()
        refHandle = ref?.child("Schedule/\(team)").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                self.list.append(actualPost)
            }
        })
    }
    
    func getTeams() {
        refHandle = ref?.child("Teams").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? String
            if let actualPost = post {
                if actualPost == self.team {
                    
                } else {
                    self.teams.append(actualPost)
                }
                self.oponentPicker.reloadAllComponents()
            }
        })
    }
    
    func setDefaultValue(item: String){
         if let indexPosition = teams.firstIndex(of: item){
           oponentPicker.selectRow(indexPosition, inComponent: 0, animated: true)
         }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        teams.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: teams[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row < teams.count else {
            return
        }
        oponent = teams[row]
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        pickedDate = dateFormatter.string(from: datePicker.date)
        if chosenOption == "add" {
            ref?.child("\(chosenTab)/\(team)/\(String(describing: intKeys.max() ?? -1 + 1))/0").setValue(pickedDate)
            ref?.child("\(chosenTab)/\(team)/\(String(describing: intKeys.max() ?? -1 + 1))/1").setValue(oponent)
            if (goalsScored.text == "" || goalsConceded.text == "") {
                ref?.child("\(chosenTab)/\(team)/\(String(describing: intKeys.max() ?? -1 + 1))/2").setValue("-")
                ref?.child("\(chosenTab)/\(team)/\(String(describing: intKeys.max() ?? -1 + 1))/3").setValue("-")
            } else {
                ref?.child("\(chosenTab)/\(team)/\(String(describing: intKeys.max() ?? -1 + 1))/2").setValue(goalsScored.text!)
                ref?.child("\(chosenTab)/\(team)/\(String(describing: intKeys.max() ?? -1 + 1))/3").setValue(goalsConceded.text!)
            }
            ref?.child("\(chosenTab)/\(team)/\(String(describing: intKeys.max() ?? -1 + 1))/4").setValue("\(homeOrAwaySwitch.isOn)")
        }else if chosenOption == "edit" {
            ref?.child("\(chosenTab)/\(team)/\(cellId)/0").setValue(pickedDate)
            ref?.child("\(chosenTab)/\(team)/\(cellId)/1").setValue(oponent)
            if (goalsScored.text == "" || goalsConceded.text == "") {
                ref?.child("\(chosenTab)/\(team)/\(cellId)/2").setValue("-")
                ref?.child("\(chosenTab)/\(team)/\(cellId)/3").setValue("-")
            } else {
                ref?.child("\(chosenTab)/\(team)/\(cellId)/2").setValue(goalsScored.text!)
                ref?.child("\(chosenTab)/\(team)/\(cellId)/3").setValue(goalsConceded.text!)
            }
            ref?.child("\(chosenTab)/\(team)/\(cellId)/4").setValue("\(homeOrAwaySwitch.isOn)")
            delegate.updateSchedule()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func DismissKeyboard() {
        self.view.endEditing(true)
    }
}
