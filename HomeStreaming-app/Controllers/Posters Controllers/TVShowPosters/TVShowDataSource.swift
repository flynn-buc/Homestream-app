import UIKit

class TVShowDataSource: NSObject, UICollectionViewDataSource, ClientServiceDataSource {
    
    
    internal let dataManager: DataManager
    
    public private(set) var shows: [TVShow]?
    
    init<P: DataManager>(dataManager: P){
        self.dataManager = dataManager
    }
    
    // Updates data used to display folders
    // If reloadTable is nil or false, caller must update data manually
    private func updateData(to data: TVShowData, completed: ((Folder)->Void) = {(folder: Folder) -> Void in}){
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tvShowCell", for: indexPath) as? TVShowPosterCell{
            if let show = shows?[indexPath.row]{
                cell.setup(tvShow: show)
                return cell
            }
        }
        return TVShowPosterCell()
    }
    
    func getData(onSuccess: @escaping onSuccess, onError: @escaping onError){
        dataManager.get { (data) in
            if let data = data as? TVShowData{
                self.shows = data.data
                onSuccess(data)
            }
        } onError: { (error) in
            onError(error)
        }
        
    }
    
    func patch(data: FilesystemItem){
        
    }
    
    func refresh(onSuccess: @escaping onSuccess, onError: @escaping onError){
        
    }
}
