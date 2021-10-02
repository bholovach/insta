import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: "StoryViewCell", bundle: nil), forCellWithReuseIdentifier: "StoryViewCell")
        }
    }
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    private let networking = Networking()
    private var urlLinks: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.isHidden = true
        infoLabel.text = "Введите логин"
    }
    
    private func getStories(userID: Int) {
        networking.getStory(userID: userID) { [self] storyResult in
            switch storyResult {
            case .success(let storys):
                // for images
                let filteredStories = storys.downloadLinks.filter { $0.mediaType == "image" }
                self.urlLinks = filteredStories.compactMap { $0.url }
                // for all types:
//                self.urlLinks = storys.downloadLinks.compactMap { $0.url }
                self.loadingIndicator.isHidden = true
                collectionView.reloadData()
            case .failure(let error):
                self.handleError(error: error)
            }
        }
    }
    
    private func getUserID(nickname: String) {
        networking.getUserID(nickname: nickname) { result in
            switch result {
            case .success(let user):
                self.getStories(userID: user.userId)
            case .failure(let error):
                self.handleError(error: error)
            }
        }
    }
    
    private func handleError(error: Error) {
        self.infoLabel.isHidden = false
        self.infoLabel.text = error.localizedDescription
        self.loadingIndicator.isHidden = true
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        guard let text = searchBar.text?.lowercased() else {
            return
        }
        
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        infoLabel.isHidden = true
        getUserID(nickname: text)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryViewCell", for: indexPath) as! StoryViewCell
        cell.configure(urlLinks: urlLinks[indexPath.row])
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
