//
//  UserModel.swift
//
//  Created by Hamza Hasan on 17/11/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class UserModel: Object, Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let updatedAt = "updated_at"
        static let email = "email"
        static let address = "address"
        static let businessName = "business_name"
        static let isApprove = "is_approve"
        static let status = "status"
        static let id = "_id"
        static let phoneNo = "phone_no"
        static let createdAt = "created_at"
        static let cuisine = "cuisine"
        static let logo = "logo"
        static let accountVerification = "account_verification"
        static let location = "location"
        static let notification = "notification"
        static let productAnnouncement = "product_announcement"
        static let country = "country"
        static let area = "area"
        static let currency = "currency"
        static let creditCard = "credit_card"
        static let cash = "cash"
        static let eWallet = "e_wallet"
        static let bankTransfer = "bank_transfer"
        static let companyRegistrationNumber = "company_registration_number"
        static let currencyInWords = "currency_in_words"
        static let currencyIcon = "currency_icon"
        static let bankName = "bank_name"
        static let accountTitle = "account_title"
        static let accountNumber = "account_number"
        static let routingNumber = "routing_number"
        static let isStripe = "is_stripe"
        static let isStripeCompleted = "isStripeCompleted"
    }
    
    // MARK: Properties
    @objc dynamic var updatedAt: String? = ""
    @objc dynamic var email: String? = ""
    @objc dynamic var address: String? = ""
    @objc dynamic var businessName: String? = ""
    @objc dynamic var isApprove = false
    @objc dynamic var status = false
    @objc dynamic var id: String? = ""
    @objc dynamic var phoneNo: String? = ""
    @objc dynamic var createdAt: String? = ""
    @objc dynamic var cuisine: String? = ""
    @objc dynamic var logo: String? = ""
    @objc dynamic var accountVerification: AccountVerification?
    @objc dynamic var accessToken: String? = ""
    @objc dynamic var password: String? = ""
    @objc dynamic var location: LocationModel?
    @objc dynamic var notification = false
    @objc dynamic var productAnnouncement = false
    @objc dynamic var country: String? = ""
    @objc dynamic var area: String? = ""
    @objc dynamic var currency: String? = ""
    @objc dynamic var creditCard = false
    @objc dynamic var cash = false
    @objc dynamic var eWallet = false
    @objc dynamic var bankTransfer = false
    @objc dynamic var companyRegistrationNumber: String? = ""
    @objc dynamic var currencyInWords: String? = ""
    @objc dynamic var currencyIcon: String? = ""
    @objc dynamic var bankName: String? = ""
    @objc dynamic var accountTitle: String? = ""
    @objc dynamic var accountNumber: String? = ""
    @objc dynamic var routingNumber: String? = ""
    @objc dynamic var isStripe = false
    @objc dynamic var isStripeCompleted = false
    // MARK: ObjectMapper Initializers
    /// Map a JSON object to this class using ObjectMapper.
    ///
    /// - parameter map: A mapping from ObjectMapper.
    
    required convenience public init?(map : Map){
        self.init()
    }
    
    public override class func primaryKey() -> String? {
        return "id"
    }
    
    /// Map a JSON object to this class using ObjectMapper.
    ///
    /// - parameter map: A mapping from ObjectMapper.
    public func mapping(map: Map) {
        updatedAt <- map[SerializationKeys.updatedAt]
        email <- map[SerializationKeys.email]
        address <- map[SerializationKeys.address]
        businessName <- map[SerializationKeys.businessName]
        isApprove <- map[SerializationKeys.isApprove]
        status <- map[SerializationKeys.status]
        id <- map[SerializationKeys.id]
        phoneNo <- map[SerializationKeys.phoneNo]
        createdAt <- map[SerializationKeys.createdAt]
        cuisine <- map[SerializationKeys.cuisine]
        logo <- map[SerializationKeys.logo]
        accountVerification <- map[SerializationKeys.accountVerification]
        location <- map[SerializationKeys.location]
        notification <- map[SerializationKeys.notification]
        productAnnouncement <- map[SerializationKeys.productAnnouncement]
        country <- map[SerializationKeys.country]
        area <- map[SerializationKeys.area]
        currency <- map[SerializationKeys.currency]
        companyRegistrationNumber <- map[SerializationKeys.companyRegistrationNumber]
        cash <- map[SerializationKeys.cash]
        eWallet <- map[SerializationKeys.eWallet]
        creditCard <- map[SerializationKeys.creditCard]
        bankTransfer <- map[SerializationKeys.bankTransfer]
        currencyInWords <- map[SerializationKeys.currencyInWords]
        currencyIcon <- map[SerializationKeys.currencyIcon]
        bankName <- map[SerializationKeys.bankName]
        accountTitle <- map[SerializationKeys.accountTitle]
        accountNumber <- map[SerializationKeys.accountNumber]
        routingNumber <- map[SerializationKeys.routingNumber]
        isStripe <- map[SerializationKeys.isStripe]
        isStripeCompleted <- map[SerializationKeys.isStripeCompleted]
    }
}
