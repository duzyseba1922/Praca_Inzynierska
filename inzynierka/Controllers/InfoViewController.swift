import UIKit
import MarqueeLabel

class InfoViewController: UIViewController{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var infoLabel: MarqueeLabel!
    @IBOutlet weak var foundedLabel: UILabel!
    @IBOutlet weak var colorsLabel: UILabel!
    @IBOutlet weak var trophiesLabel: UILabel!
    @IBOutlet weak var stadiumLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = tabBarController as! TabBarViewController
        
        infoLabel.text = "Ekstra Mobile™, Created by © Sebastian Niestój 2019"
        infoLabel.type = .continuous
        infoLabel.textAlignment = .left
        infoLabel.speed = .duration(8.0)
        infoLabel.fadeLength = 15.0
        infoLabel.leadingBuffer = 40.0
        
        imageView.image = UIImage(named: "\(tabBar.team)")
        imageView.backgroundColor = UIColor(red: 255/255, green: 224/255, blue: 178/255, alpha: 0.9)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 10
        
        AppInstance.showLoader()
        if(foundedLabel.text != nil && trophiesLabel.text != nil && colorsLabel.text != nil && stadiumLabel.text != nil && valueLabel.text != nil){
            AppInstance.hideLoader()
        }
        
        foundedLabel.text = tabBar.founded
        trophiesLabel.text = tabBar.trophies.joined(separator: "\n")
        colorsLabel.text = tabBar.colors
        stadiumLabel.text = tabBar.stadium
        valueLabel.text = tabBar.teamValue
    }
}
