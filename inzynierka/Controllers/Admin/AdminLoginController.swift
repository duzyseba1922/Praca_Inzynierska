import UIKit

class AdminLoginController: UIViewController, UITextFieldDelegate {

    var chosenOption: String = ""
    
    @IBOutlet weak var loginTextField: UITextField! = nil
    @IBOutlet weak var passwordTextField: UITextField! = nil
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        backButton.layer.cornerRadius = 20
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        getAuthorization()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "adminLogin" {
            let vc = segue.destination as! PickClubViewController
            vc.chosenOption = chosenOption
        }
    }
    
    func getAuthorization() {
        if (loginTextField.text != "" && passwordTextField.text != "") {
            if (loginTextField.text == "admin" && passwordTextField.text == "admin") {
                alert(Title: "Świetnie!", Message: "Pomyślnie zalogowano.")
            } else {
                alert(Title: "Ups!", Message: "Podano nieprawidłowe dane. Spróbuj jeszcze raz.")
            }
        } else {
            alert(Title: "Ups!", Message: "Wypełnij wszystkie pola.")
        }
    }
    
    func alert(Title: String, Message: String) {
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okej", style: UIAlertAction.Style.default) {
            UIAlertAction in
            if Title == "Świetnie!" {
                self.passwordTextField.text = ""
                self.performSegue(withIdentifier: "adminLogin", sender: self)
            } else {}
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            loginTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            return true
        } else {
            passwordTextField.resignFirstResponder()
            getAuthorization()
            return true
        }
    }
    
    @objc func DismissKeyboard() {
        self.view.endEditing(true)
    }
}
