import UIKit
import Firebase

class InfoManagerController: UIViewController {

    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    
    var trophies = [String]()
    var founded = ""
    var colors = ""
    var stadium = ""
    var teamValue = ""
    var trophy = ""
    
    var chosenOption: String = ""
    var chosenTab: String = ""
    var team: String = ""
    
    @IBOutlet weak var colorsTextField: UITextField!
    @IBOutlet weak var foundedTextField: UITextField!
    @IBOutlet weak var stadiumName: UITextField!
    @IBOutlet weak var stadiumCapacity: UITextField!
    @IBOutlet weak var teamValueTextField: UITextField!
    @IBOutlet weak var trophiesTextView: UITextView!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        getInfo()
        
        confirmButton.layer.cornerRadius = 10
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func getInfo(){
        refHandle = ref?.child("Info/\(team)/Founded").observe(.value, with: { (snapshot) in
            let post = snapshot.value as? String
            self.foundedTextField.text! = post ?? ""
        })
        refHandle = ref?.child("Info/\(team)/Trophies").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? String
            if let actualPost = post {
                self.trophies.append(actualPost)
            }
            self.trophiesTextView.text! = self.trophies.joined(separator: ", ")
        })
        refHandle = ref?.child("Info/\(team)/Colors").observe(.value, with: { (snapshot) in
            let post = snapshot.value as? String
            self.colorsTextField.text! = post ?? ""
        })
        refHandle = ref?.child("Info/\(team)/Stadium").observe(.value, with: { (snapshot) in
            let post = snapshot.value as? String
            self.stadium = post ?? ""
            if let range = self.stadium.range(of: "(") {
                let sCapacity = self.stadium[range.upperBound...]
                let sName = self.stadium[self.stadium.startIndex..<range.lowerBound]
                let capacity = sCapacity.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
                self.stadiumName.text! = "\(sName)"
                self.stadiumCapacity.text! = "\(capacity)"
            }
        })
        refHandle = ref?.child("Info/\(team)/TeamValue").observe(.value, with: { (snapshot) in
            let post = snapshot.value as? String
            self.teamValueTextField.text! = post ?? ""
        })
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        ref?.child("\(chosenTab)/\(team)/Colors").setValue(colorsTextField.text!)
        ref?.child("\(chosenTab)/\(team)/Founded").setValue(foundedTextField.text!)
        ref?.child("\(chosenTab)/\(team)/Stadium").setValue("\(stadiumName.text!) (\(stadiumCapacity.text!))")
        ref?.child("\(chosenTab)/\(team)/TeamValue").setValue(teamValueTextField.text!)
        let successes = trophiesTextView.text!.split(separator: ",")
        ref?.child("\(chosenTab)/\(team)/Trophies").setValue(successes)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func DismissKeyboard() {
        self.view.endEditing(true)
    }
}
