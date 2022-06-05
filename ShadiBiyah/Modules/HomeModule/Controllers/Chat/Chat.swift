//
//  Chat.swift
//  FoodChooRider
//
//  Created by Fazeel Ahmed on 02/08/2021.
//

import UIKit
import DZNEmptyDataSet
import ObjectMapper
import SocketIO

class Chat: BaseController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tfMessage: UITextFieldDeviceClass!
    @IBOutlet weak var btnSendMessage: LoadingButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblSupportTyping: UILabel!
    @IBOutlet weak var ViewTyping: UIView!
    
    var firstTime = true //For loading place holder
    
    var page = 1
    var pageCount = 0
    var arrChat = [ChatModel]()
    var indexpathsToReload = [IndexPath]()
    var isFirstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.getPreviousChat()
        self.connectSocket()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.getNotificationCount()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.disconnectSocket()
        self.removeKeyboardObservers()
    }
    
    @IBAction func onTfMessage(_ sender: UITextField) {
        self.emitTypingEvent()
    }
    @IBAction func onBtnSendMessage(_ sender: UIButton) {
        self.validateAndSendMessage(sender: sender)
    }
}

//MARK: TableView Delegate
extension Chat:UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.isFirstTime {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if tableView.visibleCells.contains(cell) {
                if indexPath.row == 0 && self.tableView.contentOffset.y < 10{
                    self.loadMoreCells()
                }
            }
        }
    }
    private func loadMoreCells(){
        if self.pageCount != self.page{
            self.page += 1
            self.getPreviousChat()
        }
    }
}
//MARK: TableView DataSouurce
extension Chat:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrChat.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.arrChat[indexPath.row]
        let sentBy = data.sentBy ?? ""
        
        switch sentBy{
        case ChatSenderType.Customer.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTVC", for: indexPath) as! SenderTVC
            cell.setData(data: data)
             return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecieverTVC", for: indexPath) as! RecieverTVC
                cell.setData(data: data)
                return cell
        }
    }
}
//MARK: DZNEmptyDataSetSource
extension Chat: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if self.firstTime {
            let str = Strings.LOADING_MESSAGES.text
            let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
            return NSAttributedString(string: str, attributes: attrs)
        }
        let str = Strings.NO_CHATS_TO_SHOW_YET.text
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
}
//MARK: UITextFieldDelegate
extension Chat: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tfMessage.resignFirstResponder()
        return true
    }
}
//MARK: Helper Method
extension Chat{
    private func setUI(){
        self.title = Strings.CONTACT_SUPPORT.text
        self.registerCell()
        self.setKeyboardObservers()
    }
    private func registerCell(){
        self.tableView.register(UINib(nibName: "SenderTVC", bundle: nil), forCellReuseIdentifier: "SenderTVC")
        self.tableView.register(UINib(nibName: "RecieverTVC", bundle: nil), forCellReuseIdentifier: "RecieverTVC")
    }
    private func scrollToBottom(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.arrChat.isEmpty{return}
            let lastRow = self.arrChat.count - 1
            let index = IndexPath(row: lastRow, section: 0)
            
            UIView.animate(withDuration: 0.5) {
                self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
            }
        }
    }
    private func validateAndSendMessage(sender:UIButton){
        self.tfMessage.text = (self.tfMessage.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if !Validation.shared.validateStringLength(self.tfMessage.text ?? ""){
            sender.shake()
            return
        }
        self.sendMessageToAdmin()
    }
    private func animateTableView(){
        DispatchQueue.main.async {
            if self.isFirstTime{
                self.tableView.reloadData()
                if self.arrChat.isEmpty{return}
                let lastRow = self.arrChat.count - 1
                let index = IndexPath(row: lastRow, section: 0)
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
                }) { (_) in
                    self.isFirstTime = false
                }
            }
            else{
                //this should contain the new indexPaths
                var height: CGFloat = 0.0
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    UIView.performWithoutAnimation {
                        
                        self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .none)
                        self.tableView.layoutIfNeeded()
                        self.indexpathsToReload.forEach({ (idx) in
                            height += self.tableView.rectForRow(at: idx).height
                        })
                        let afterContentOffset = self.tableView.contentOffset
                        let newContentOffset = CGPoint(x: afterContentOffset.x, y: afterContentOffset.y + height)
                        self.tableView.setContentOffset(newContentOffset, animated: false)
                    }
                }
            }
        }
    }
    private func setKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func removeKeyboardObservers(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0, animations: {
                self.bottomConstraint.constant = keyboardSize.height - Utility.main.getBottomSafeArea()
                self.view.layoutIfNeeded()
                self.scrollToBottom()
            }) { (completed) in
                self.scrollToBottom()
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.75, animations: {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
            self.scrollToBottom()
        }, completion: nil)
    }
    private func showSupportTyping(){
        if !self.ViewTyping.isHidden {return}
        self.lblSupportTyping.text = "\(Strings.SUPPORT.text) \(Strings.IS_TYPING.text)"
        UIView.animate(withDuration: 0) {
            self.ViewTyping.isHidden = false
            self.view.layoutIfNeeded()
        } completion: { (_) in
            if self.ViewTyping.isHidden {return}
            self.hideSupportTyping()
        }
    }
    private func hideSupportTyping(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.25) {
                self.ViewTyping.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
    }
}
//MARK: Service
extension Chat{
    private func getPreviousChat(){
        let page = self.page
        let param:[String:Any] = ["page":page]
        
        APIManager.sharedInstance.usersAPIManager.adminChat(params: param) { responseObject in
            self.firstTime = false
            
            if let pageCount = responseObject["page_count"] as? Int {
                self.pageCount = pageCount
            }
            guard let chats = responseObject["chats"] as? [[String:Any]] else {return}
            let arrChat = Mapper<ChatModel>().mapArray(JSONArray: chats)
            
            if arrChat.isEmpty {
                self.tableView.reloadData()
                return
            }
            
            if self.arrChat.isEmpty {
                self.arrChat = arrChat
            }else{
                self.indexpathsToReload.removeAll()
                
                for (index,chat) in  arrChat.enumerated(){
                    self.arrChat.insert(chat, at: index)
                    
                    let indexPath = IndexPath(row: index, section: 0)
                    self.indexpathsToReload.append(indexPath)
                }
            }
            self.animateTableView()
        } failure: { error in
            print(error)
        }
    }
    private func sendMessageToAdmin(){
        let message = self.tfMessage.text ?? ""
        let message_type = "text"
        let params:[String:Any] = ["message":message,
                                   "message_type":message_type]
        
        self.btnSendMessage.showLoading()
        self.btnSendMessage.isEnabled = false
        
        APIManager.sharedInstance.usersAPIManager.customerSendMessageToAdmin(params: params) { responseObject in
            self.btnSendMessage.hideLoading()
            self.btnSendMessage.isEnabled = true
            
            guard let chatData = responseObject["chat"] as? [String:Any] else {return}
            guard let chat = Mapper<ChatModel>().map(JSON: chatData) else {return}
            self.arrChat.append(chat)
            self.tfMessage.text = nil
            self.scrollToBottom()
        } failure: { error in
            self.btnSendMessage.hideLoading()
            self.btnSendMessage.isEnabled = true
        }
    }
}
//MARK: Socket
extension Chat{
    open class SocketConnection {
        public static let default_ = SocketConnection()
        let manager: SocketManager
        
        private init() {
            let token = "Bearer " + (AppStateManager.sharedInstance.loggedInUser?.authToken ?? "")
            let type = ChatSenderType.Customer.rawValue
            
            let param:[String:Any] = ["token":token,
                                      "type":type]
            
            let socketURL = Utility.main.URLforRoute(route: Constants.BaseSocketChatURL, params: param)! as URL
            
            manager = SocketManager(socketURL: socketURL, config: [.log(true), .compress])
            manager.config = SocketIOClientConfiguration(arrayLiteral: .connectParams(param), .secure(false))
        }
    }
    private func connectSocket(){
        let socket = SocketConnection.default_.manager.socket(forNamespace: Constants.chatNameSpace)
        if socket.status != .connected{
            socket.connect()
        }
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        let receiverId = UserDefaults.standard.string(forKey: "admin_id") ?? ""
        let senderId = AppStateManager.sharedInstance.loggedInUser?.id ?? ""
        
        socket.on("customer/\(senderId)") {data, ack in
            guard let chatData = data.first as? [String:Any] else {return}
            guard let chat = Mapper<ChatModel>().map(JSON: chatData) else {return}
            self.arrChat.append(chat)
            self.scrollToBottom()
            
            let messageId = chat.id ?? ""
            self.emitMessageSeenOfRider(messageId: messageId)
        }
        
        socket.on("typing-\(senderId)-\(receiverId)") {data, ack in
            print(data)
            self.showSupportTyping()
        }
    }
    private func emitTypingEvent(){
        let socket = SocketConnection.default_.manager.socket(forNamespace: Constants.chatNameSpace)
        let receiverId = UserDefaults.standard.string(forKey: "admin_id") ?? ""
        let senderId = AppStateManager.sharedInstance.loggedInUser?.id ?? ""
        let event = "typing-\(receiverId)-\(senderId)"
        socket.emitWithAck("typing", ["event":event]).timingOut(after: 5) {data in
            print(data)
        }
    }
    private func emitMessageSeenOfRider(messageId: String){
        let socket = SocketConnection.default_.manager.socket(forNamespace: Constants.chatNameSpace)
        
        let id = messageId
        let type = "adminCustomer"
        let params:[String:Any] = ["id":id,
                                   "type":type]
        
        socket.emitWithAck("read-message", params).timingOut(after: 5) {data in
            print(data)
        }
    }
    private func disconnectSocket(){
        let socket = SocketConnection.default_.manager.socket(forNamespace: Constants.chatNameSpace)
        socket.removeAllHandlers()
        socket.disconnect()
    }
}
