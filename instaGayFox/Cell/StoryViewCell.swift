import UIKit

class StoryViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    // loading indicator?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    func configure(urlLinks: String) {
        imageView.image = UIImage(data: try! Data(contentsOf: URL(string: urlLinks)!))
    }
}
