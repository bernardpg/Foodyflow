//
//  BlockUserTableViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 7/12/22.
//

import UIKit
import FirebaseAuth
import SnapKit

class BlockUserTableViewController: UITableViewController {
    
    private lazy var blockTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        blockTableView.register(
            UINib(nibName: "BlockUserTableViewCell", bundle: nil),
            forCellReuseIdentifier: "BlockUserTableViewCell")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        
        cell.userName.text = allBlocksUsers[indexPath.row].userName
        
        
        return cell
    }
    
   // override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // update and fetch
        
        
        //UserManager.shared.updateUserInfo(user: <#T##UserInfo#>, completion: <#T##() -> Void#>)
        
  //  }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
