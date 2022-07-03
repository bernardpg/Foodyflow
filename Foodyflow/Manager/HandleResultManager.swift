//
//  HandleResultManager.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/29/22.
//

import UIKit
 import PKHUD

enum HandleInputResult {
    
    case emailEmpty
    
    case passwordEmpty
    
    case formatFailed
    
    case nameEmpty
    
    case checkEmpty
    
    case passwordIsDifferent
    
   // case contentEmpty
    
 //   case titleEmpty
    
 //   case categoryEmpty
    
    case selectCategory
    
 //   case startDateEmpty
    
 //   case endDateEmpty
    
 //   case studyItemEmpty
    
 //   case startDatereLativelyLate
    
    case selectDate
    
    case messageEmpty
    
    case uploadImage
    
    var messageHUD: Void {
        
        switch self {
            
        case .emailEmpty:
            
            HUD.flash(.label("請輸入帳號！"), delay: 0.5)
            
        case .formatFailed:
            
            HUD.flash(.label("請輸入密碼！"), delay: 0.5)
            
        case .passwordEmpty:
            
            HUD.flash(.label("帳號格式錯誤！"), delay: 0.5)
            
        case .nameEmpty:
            
            HUD.flash(.label("請輸入姓名！"), delay: 0.5)
            
        case .checkEmpty:
            
            HUD.flash(.label("請輸入檢查碼！"), delay: 0.5)
            
        case .passwordIsDifferent:

            HUD.flash(.label("密碼與檢查碼不一致！"), delay: 0.5)
            
//        case .contentEmpty:
//
//            HUD.flash(.label(InputError.contentEmpty.title), delay: 0.5)
//
//        case .titleEmpty:
//
//            HUD.flash(.label(InputError.titleEmpty.title), delay: 0.5)
//
//        case .categoryEmpty:
//
//            HUD.flash(.label(InputError.categoryEmpty.title), delay: 0.5)
//
        case .selectCategory:
            
            HUD.flash(.label("請選擇標籤！"), delay: 0.5)
            
//        case .startDateEmpty:
//
//            HUD.flash(.label(InputError.startDateEmpty.title), delay: 0.5)
//
//        case .endDateEmpty:
//
//            HUD.flash(.label(InputError.endDateEmpty.title), delay: 0.5)
//
//        case .studyItemEmpty:
//
//            HUD.flash(.label(InputError.studyItemEmpty.title), delay: 0.5)
//
//        case .startDatereLativelyLate:
//
//            HUD.flash(.label(InputError.startDatereLativelyLate.title), delay: 0.5)
            
        case .selectDate:
            
            HUD.flash(.label("請選擇日期！"), delay: 0.5)
            
        case .messageEmpty:
            
            HUD.flash(.label("留言不可為空！"), delay: 0.5)
            
        case .uploadImage:
            
            HUD.flash(.label("請上傳認證照！"), delay: 0.5)
            
        }
        
    }
    
}

enum HandleResult {
    
    case imageUpload
    
    case imageUploadSuccess
    
    case imageUploadFailed
    
    case readDataFailed
    
    case reportFailed
    
    case addDataFailed
    
    case updateDataFailed
    
    case deleteDataFailed
    
    case modifyFriendStatusFailed
    
    case sendMassageFailed
    
    case deleteDataSuccessed
    
    case finishedStudyItem
    
    case addDataSuccess
    
    case updateDataSuccess
    
    case sendFriendApply
    
    case reportSuccess
    
    case articleDelete
    
    case isUnBlockUser
    
    case signOutFailed
    
    case shareToFriendSuccess
    
    var messageHUD: Void {
        
        switch self {
            
        case .imageUpload:
            
            HUD.show(.labeledProgress(title: "食譜上傳中...", subtitle: nil))
            
        case .imageUploadSuccess:
            
            HUD.flash(.labeledSuccess(title: "食譜上傳成功！", subtitle: nil))
            
        case .imageUploadFailed:
            
            HUD.flash(.labeledError(title: "圖片上傳失敗！", subtitle: nil))
            
        case .readDataFailed:
            
            HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
            
        case .reportFailed:
            
            HUD.flash(.labeledError(title: "檢舉失敗！", subtitle: "請稍後再試"), delay: 0.5)
            
        case .addDataFailed:
            
            HUD.flash(.labeledError(title: "新增失敗！", subtitle: "請稍後再試"), delay: 0.5)
            
        case .updateDataFailed:
            
            HUD.flash(.labeledError(title: "修改失敗！", subtitle: "請稍後再試"), delay: 0.5)
            
        case .deleteDataFailed:
            
            HUD.flash(.labeledError(title: "刪除失敗！", subtitle: "請稍後再試"), delay: 0.5)
            
        case .modifyFriendStatusFailed:
            
            HUD.flash(.labeledError(title: "狀態修改失敗！", subtitle: "請稍後再試"), delay: 0.5)
            
        case .sendMassageFailed:
            
            HUD.flash(.labeledError(title: "訊息傳送失敗！", subtitle: "請稍後再試"), delay: 0.5)
            
        case .deleteDataSuccessed:
            
            HUD.flash(.labeledSuccess(title: "刪除成功！", subtitle: nil), delay: 0.5)
            
        case .finishedStudyItem:
            
            HUD.flash(.labeledSuccess(title: "學習項目完成！", subtitle: nil), delay: 0.5)
            
        case .addDataSuccess:
            
            HUD.flash(.labeledSuccess(title: "新增成功！", subtitle: nil), delay: 0.5)
            
        case .updateDataSuccess:
            
            HUD.flash(.labeledSuccess(title: "修改成功！", subtitle: nil), delay: 0.5)
            
        case .sendFriendApply:
            
            HUD.flash(.labeledSuccess(title: "已發送好友邀請!", subtitle: "請等待對方的回覆"), delay: 0.5)
            
        case .reportSuccess:
            
            HUD.flash(.labeledSuccess(title: "檢舉成功！", subtitle: "站方會盡快處理此檢舉"), delay: 0.5)
            
        case .articleDelete:
            
            HUD.flash(.label("該文章已被刪除！"), delay: 0.5)
            
        case .isUnBlockUser:
            
            HUD.flash(.labeledSuccess(title: "已解除封鎖此帳號", subtitle: nil), delay: 0.5)
            
        case .signOutFailed:
            
            HUD.flash(.labeledError(title: "登出失敗！", subtitle: "請稍候嘗試"), delay: 0.5)
            
        case .shareToFriendSuccess:
            
            HUD.flash(.labeledSuccess(title: "傳送成功", subtitle: nil), delay: 0.5)
            
        }
        
    }
    
}

