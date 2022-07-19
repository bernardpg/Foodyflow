//
//  BlockUserTableViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 7/12/22.
//

import UIKit
import FirebaseAuth
import SnapKit

class BlockUserTableViewController: UITableViewController, UnblockUserCellDelegate {
    func didunblockTap(indexPathRow: IndexPath) {
        
        let removeblocks = allBlocksUsers[indexPathRow.row]// allBlocksUsers //.[indexPathRow.row]
        UserManager.shared.removeBlockList(uid: Auth.auth().currentUser?.uid ?? "", blockID: removeblocks.userID) { result in
            switch result {
            case .success:
                HandleResult.isUnBlockUser.messageHUD
                self.blockReload()
                
            case .failure:
                HandleResult.addDataFailed.messageHUD
            }
        }
        
    }

    private lazy var blockTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        blockTableView.register(
            UINib(nibName: "BlockUserTableViewCell", bundle: nil),
            forCellReuseIdentifier: "BlockUserTableViewCell")
    }

    var allBlocksUsers: [UserInfo] = []
    
    var myUserInfo: UserInfo?
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        
    guard let userID = Auth.auth().currentUser?.uid else { return }
        
    UserManager.shared.fetchUserInfo(fetchUserID: userID) { result in
        switch result {
        case .success(let userInfo):
            self.myUserInfo = userInfo
            var allBlocksUser:  [UserInfo] = []
            for singleUser in userInfo.blockLists {
                UserManager.shared.fetchUserInfo(fetchUserID: singleUser ?? "") { result in
                    switch result {
                    case .success(let blockuserInfo):
                        allBlocksUser.append(blockuserInfo)
                    case .failure:
                        HandleResult.readDataFailed.messageHUD
                    }
                }
            }
            self.allBlocksUsers = allBlocksUser
            DispatchQueue.main.async {
                self.blockTableView.reloadData()
            }
        case .failure:
                HandleResult.readDataFailed.messageHUD
        }
    }
    }
    
    private func setupUI() {
        view.addSubview(blockTableView)
        blockTableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin)
            make.bottom.equalTo(view.snp_bottomMargin)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
    }
    
    private func blockReload() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        UserManager.shared.fetchUserInfo(fetchUserID: userID) { result in
            switch result {
            case .success(let userInfo):
                self.myUserInfo = userInfo
                var allBlocksUser:  [UserInfo] = []
                for singleUser in userInfo.blockLists {
                    UserManager.shared.fetchUserInfo(fetchUserID: singleUser ?? "") { result in
                        switch result {
                        case .success(let blockuserInfo):
                            allBlocksUser.append(blockuserInfo)
                        case .failure:
                            HandleResult.readDataFailed.messageHUD
                        }
                    }
                }
                self.allBlocksUsers = allBlocksUser
                DispatchQueue.main.async {
                    self.blockTableView.reloadData()
                }
            case .failure:
                    HandleResult.readDataFailed.messageHUD
            }
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  allBlocksUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = blockTableView.dequeueReusableCell(
            withIdentifier: "BlockUserTableViewCell",
            for: indexPath) as? BlockUserTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        
        cell.indexPath = indexPath
        cell.selectionStyle = .none
        cell.delegate = self
        
        cell.userName.text = allBlocksUsers[indexPath.row].userName
        cell.userImage.isHidden = true
        return cell
    }
    
   // override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // update and fetch
                
        // UserManager.shared.updateUserInfo(user: <#T##UserInfo#>, completion: <#T##() -> Void#>)
        
  //  }

}
