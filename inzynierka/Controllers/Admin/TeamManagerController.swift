import UIKit
import Firebase

protocol teamsDelegate {
   func updateTeams()
}

class TeamManagerController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    var delegate: teamsDelegate!
    var imagePicker = UIImagePickerController()
    
    var teams = [String]()
    var badge: UIImage?
    var selectedTeam: String = ""
    var chosenOption: String = ""
    var chosenTab: String = ""
    var cellId: Int = 0
    var teamId: String = ""
    var list = [String:Any]()
    var stringKeys = [String]()
    var intKeys = [Int]()
    var maxKey: Int = 0
    
    @IBOutlet weak var teamBadge: UIImageView!
    @IBOutlet weak var addImage: UIButton!
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self

        ref = Database.database().reference()
        
        teamBadge.image = badge
        
        if chosenOption == "add" {
            getTeams()
        }
        
        if chosenOption == "edit" {
            
            selectedTeam = teams[cellId]
            teamName.text! = selectedTeam
            getBadge(team: normalize(selectedTeam))
            ref?.child("Teams").queryOrderedByValue().queryEqual(toValue: selectedTeam).observeSingleEvent(of: .value) { (querySnapshot) in
                for result in querySnapshot.children {
                    let resultSnapshot = result as! DataSnapshot
                    self.teamId = resultSnapshot.key
                }
            }
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func changeData(){
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                self.stringKeys.append(key)
            }
            if self.stringKeys.count == 6 {
                if let index = self.stringKeys.firstIndex(of: "Table") {
                    self.stringKeys.remove(at: index)
                }
                if let index = self.stringKeys.firstIndex(of: "Teams") {
                    self.stringKeys.remove(at: index)
                }
                for name in self.stringKeys {
                    self.ref?.child(name).observe(.value, with: { (snapshot) in
                        let post = snapshot.value as? [String:Any]
                        if let actualPost = post {
                            self.list = actualPost
                        }
                        self.list.switchKey(fromKey: self.selectedTeam, toKey: self.teamName.text!)
                        self.ref?.child(name).setValue(self.list)
                    })
                }
            }
        })
    }
    
    func getBadge(team: String){
        let url = "gs://praca-inzynierska-duzego.appspot.com/badges/\(team).png"
        Storage.storage().reference(forURL: url).getData(maxSize: 999999999999999, completion: { (data, error) in

            guard let imageData = data, error == nil else {
                return
            }
            self.teamBadge.image = UIImage(data: imageData)
        })
    }
    
    func getTable() {
        var table = [[String]]()
        ref?.child("Table").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                table.append(actualPost)
            }
            if(table.count == self.teams.count) {
                for x in 0...table.count - 1 {
                    if table[x][0] == self.selectedTeam {
                        self.ref?.child("Table/\(x)/0").setValue(self.teamName.text!)
                    }
                }
            }
        })
    }
    
    func getTeams() {
        refHandle = ref?.child("Teams").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? String
            if let actualPost = post {
                self.teams.append(actualPost)
            }
        })
    }
    
    func normalize(_ str: String) -> String {
        let original = ["Ą", "ą", "Ć", "ć", "Ę", "ę", "Ł", "ł", "Ń", "ń", "Ó", "ó", "Ś", "ś", "Ź", "ź", "Ż", "ż"]
        let normalized = ["A", "a", "C", "c", "E", "e", "L", "l", "N", "n", "O", "o", "S", "s", "Z", "z", "Z", "z"]
        var str = str
        for x in 0...original.count - 1 {
            if original.contains(where: str.contains) == true {
                str = str.replacingOccurrences(of: original[x], with: normalized[x])
            } else {
                return str
            }
        }
        return str
    }
    
    @IBAction func addImage(_ sender: Any) {  
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .savedPhotosAlbum

        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.teamBadge.contentMode = .scaleAspectFit
            self.teamBadge.image = pickedImage
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker = UIImagePickerController()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        
        if teamBadge.image != nil {
            let data = teamBadge.image?.pngData()

            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            let deleteRef = Storage.storage().reference().child("badges/\(normalize(selectedTeam)).png")
            let uploadRef = Storage.storage().reference().child("badges/\(normalize(teamName.text!)).png")

            deleteRef.delete { (error) in
                if let error = error {
                    print(error)
                } else {}
            }
            uploadRef.putData(data!, metadata: metadata) { (metadata, error) in
                guard let metadata = metadata else {
                    return
                }
            }
        } else {
            print("error")
        }
        
        if chosenOption == "add" {
            ref?.child("Teams").observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = Int(snap.key)
                    self.intKeys.append(key!)
                    self.maxKey = self.intKeys.max()!
                    if self.intKeys.count == self.teams.count {
                        self.ref?.child("\(self.chosenTab)/\(String(describing: self.maxKey + 1))").setValue(self.teamName.text!)
                        self.ref?.child("Table/\(String(describing: self.maxKey + 1))/0").setValue(self.teamName.text!)
                        self.ref?.child("Table/\(String(describing: self.maxKey + 1))/1").setValue("")
                        self.ref?.child("Table/\(String(describing: self.maxKey + 1))/2").setValue("")
                        self.ref?.child("Table/\(String(describing: self.maxKey + 1))/3").setValue("")
                    }
                }
            })
            ref?.child("News/\(teamName.text!)/0/0").setValue("")
            ref?.child("News/\(teamName.text!)/0/1").setValue("")
            ref?.child("Schedule/\(teamName.text!)/0/0").setValue("")
            ref?.child("Schedule/\(teamName.text!)/0/1").setValue("")
            ref?.child("Schedule/\(teamName.text!)/0/2").setValue("")
            ref?.child("Schedule/\(teamName.text!)/0/3").setValue("")
            ref?.child("Schedule/\(teamName.text!)/0/4").setValue("")
            ref?.child("Info/\(teamName.text!)/Colors").setValue("")
            ref?.child("Info/\(teamName.text!)/Founded").setValue("")
            ref?.child("Info/\(teamName.text!)/Stadium").setValue("")
            ref?.child("Info/\(teamName.text!)/TeamValue").setValue("")
            ref?.child("Info/\(teamName.text!)/Trophies").setValue([""])
            ref?.child("Squad/\(teamName.text!)/Bramkarze/0/0").setValue("")
            ref?.child("Squad/\(teamName.text!)/Bramkarze/0/1").setValue("")
            ref?.child("Squad/\(teamName.text!)/Obrońcy/0/0").setValue("")
            ref?.child("Squad/\(teamName.text!)/Obrońcy/0/1").setValue("")
            ref?.child("Squad/\(teamName.text!)/Pomocnicy/0/0").setValue("")
            ref?.child("Squad/\(teamName.text!)/Pomocnicy/0/1").setValue("")
            ref?.child("Squad/\(teamName.text!)/Napastnicy/0/0").setValue("")
            ref?.child("Squad/\(teamName.text!)/Napastnicy/0/1").setValue("")
            ref?.child("Squad/\(teamName.text!)/Trener/0/0").setValue("")
            ref?.child("Squad/\(teamName.text!)/Trener/0/1").setValue("")
            self.dismiss(animated: true, completion: nil)
        } else if chosenOption == "edit" {
            changeData()
            getTable()
            ref?.child("\(chosenTab)/\(teamId)").setValue(teamName.text!)
            delegate.updateTeams()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func DismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension Dictionary {
    mutating func switchKey(fromKey: Key, toKey: Key) {
        if let entry = removeValue(forKey: fromKey) {
            self[toKey] = entry
        }
    }
}
