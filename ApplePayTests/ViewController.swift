//
//  ViewController.swift
//  ApplePayTests
//
//  Created by 张少康 on 16/2/19.
//  Copyright © 2016年 GYZH. All rights reserved.
//

import UIKit
import PassKit

class ViewController: UIViewController ,PKPaymentAuthorizationViewControllerDelegate{

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	@IBAction func payButton(sender: AnyObject) {
		let request = PKPaymentRequest()
		let paymentNetworks = [PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa]
		if PKPaymentAuthorizationViewController.canMakePaymentsUsingNetworks(paymentNetworks) {
			
			print("Apple pay is available")
			
			request.supportedNetworks = [PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa]
			request.countryCode = "US"
			request.currencyCode = "USD"
			request.merchantIdentifier = "merchant.com.shrikar.sellanything"
			request.merchantCapabilities = .Capability3DS
			request.requiredShippingAddressFields = PKAddressField.PostalAddress
			request.paymentSummaryItems = getPayments("sds", shipping: "9.99")
			
			let sameday = PKShippingMethod(label: "Same Day", amount: NSDecimalNumber(string: "9.99"))
			sameday.detail = "Guranteed Same day"
			sameday.identifier = "sameday"
			
			let twoday = PKShippingMethod(label: "Two Day", amount: NSDecimalNumber(string: "4.99"))
			twoday.detail = "2 Day delivery"
			twoday.identifier = "2day"
			
			let shippingMethods : [PKShippingMethod] = [sameday, twoday]
			request.shippingMethods = shippingMethods
			
			let  viewController = PKPaymentAuthorizationViewController(paymentRequest: request)
			viewController.delegate = self
			presentViewController(viewController, animated: true, completion: nil)
			
		}

	}
	
	func getPayments(item : String, shipping: String) -> [PKPaymentSummaryItem] {
		let wax = PKPaymentSummaryItem(label: "Shrikar Archak iOS programming : 45236453", amount: NSDecimalNumber(string: "5454"))
		let discount = PKPaymentSummaryItem(label: "Discount", amount: NSDecimalNumber(string: "-1.00"))
		let shipping = PKPaymentSummaryItem(label: "Shipping", amount: NSDecimalNumber(string: shipping))
		let totalAmount = wax.amount.decimalNumberByAdding(discount.amount)
			.decimalNumberByAdding(shipping.amount)
		let total = PKPaymentSummaryItem(label: "Shrikar Archak", amount: totalAmount)
		return [wax, discount, shipping, total]
	}

	
	//MARK: -- PKPaymentAuthorizationViewController DELEGATE
	func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController) {
		controller.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: (PKPaymentAuthorizationStatus) -> Void) {
		print("Payment was authorized: \(payment)")
		
		let asyncSuccessful = false
		if asyncSuccessful {
			completion(PKPaymentAuthorizationStatus.Success)
		}else {
			completion(PKPaymentAuthorizationStatus.Failure)
		}
	}


	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

