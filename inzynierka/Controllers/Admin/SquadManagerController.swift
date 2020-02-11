import UIKit
import Firebase

protocol squadDelegate {
   func updateSquad()
}

class SquadManagerController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    var delegate: squadDelegate!
    var imagePicker = UIImagePickerController()
    
    var list = [[String]]()
    var team: String = ""
    var chosenOption: String = ""
    var chosenTab: String = ""
    var cellId: Int = 0
    var position: String = ""
    var listOfPositions = ["Trener","Bramkarze","Obrońcy","Pomocnicy","Napastnicy"]
    var intKeys = [Int]()
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var nationality: UITextField!
    @IBOutlet weak var positionPicker: UIPickerView!
    
    @IBAction func addImageButton(_ sender: Any) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .savedPhotosAlbum

        self.present(imagePicker, animated: true, completion: nil)
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.playerImage.contentMode = .scaleAspectFit
            self.playerImage.image = pickedImage
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker = UIImagePickerController()
        dismiss(animated: true, completion: nil)
    }
    
    func getImage() {
        let url = "gs://praca-inzynierska-duzego.appspot.com/players/\(team)/\(normalize(list[cellId][0])).png"
        Storage.storage().reference(forURL: url).getData(maxSize: 999999999999999, completion: { (data, error) in

            guard let imageData = data, error == nil else {
                return
            }
            self.playerImage.image = UIImage(data: imageData)

        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        
        ref = Database.database().reference()
        getSquad()
        
        positionPicker.delegate = self
        positionPicker.dataSource = self
        
        if (chosenOption == "edit") {
            getImage()
            let names = list[cellId][0].split(separator: " ")
            firstName.text! = String(names[0])
            lastName.text! = String(names[1])
            nationality.text! = list[cellId][1]
            position = list[cellId][2]
            setDefaultValue(item: list[cellId][2])
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func setDefaultValue(item: String){
         if let indexPosition = listOfPositions.firstIndex(of: item){
           positionPicker.selectRow(indexPosition, inComponent: 0, animated: true)
         }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: listOfPositions[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row < listOfPositions.count else {
            return
        }
        position = listOfPositions[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
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
    
    func getSquad(){
        refHandle = ref?.child("Squad/\(team)/Trener").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                self.list.append(actualPost)
            }
        })
        refHandle = ref?.child("Squad/\(team)/Bramkarze").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                self.list.append(actualPost)
            }
        })
        refHandle = ref?.child("Squad/\(team)/Obrońcy").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                self.list.append(actualPost)
            }
        })
        refHandle = ref?.child("Squad/\(team)/Pomocnicy").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                self.list.append(actualPost)
            }
        })
        refHandle = ref?.child("Squad/\(team)/Napastnicy").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                self.list.append(actualPost)
            }
        })
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        if playerImage.image != nil {
            let data = playerImage.image?.pngData()

            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            let deleteRef = Storage.storage().reference().child("players/\(team)/\(normalize("\(list[cellId][0])")).png")
            let uploadRef = Storage.storage().reference().child("players/\(team)/\(normalize("\(firstName.text!) \(lastName.text!)")).png")

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
            if position == "" {
                position = "Bramkarze"
            } else {}
            ref?.child("\(chosenTab)/\(team)/\(intKeys.max()! + 1)/0").setValue("\(firstName.text!) \(lastName.text!)")
            ref?.child("\(chosenTab)/\(team)/\(intKeys.max()! + 1)/1").setValue(nationality.text!)
            ref?.child("\(chosenTab)/\(team)/\(intKeys.max()! + 1)/2").setValue(position)
            self.dismiss(animated: true, completion: nil)
        } else if chosenOption == "edit" {
            
            delegate.updateSquad()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func DismissKeyboard() {
        self.view.endEditing(true)
    }
}
