//
//  CancelPaymentRequest.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 26/11/24.
//

public struct CancelPaymentRequest: Paramable {
  
  let orderNumber: String
  let reasonID: Int
  let reason: String?
  let dismiss: Bool
  
  public init(dismiss: Bool) {
    self.orderNumber = ""
    self.reasonID = 0
    self.reason = nil
    self.dismiss = dismiss
  }
  
  public init(
    orderNumber: String,
    reasonID: Int,
    reason: String?,
    dismiss: Bool = false
  ) {
    self.orderNumber = orderNumber
    self.reasonID = reasonID
    self.reason = reason
    self.dismiss = dismiss
  }
  
  public func toParam() -> [String : Any] {
    if dismiss {
      return ["dismiss" : dismiss]
    }
    
    return [
      "dismiss": dismiss,
      "order_no": orderNumber,
      "reason_canceled_order_id": reasonID,
      "reason": reason ?? ""
    ]
  }
  
}
