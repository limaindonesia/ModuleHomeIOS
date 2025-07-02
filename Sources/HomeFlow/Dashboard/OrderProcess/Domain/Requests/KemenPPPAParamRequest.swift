//
//  KemenPPPAParamRequest.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 19/06/25.
//

import Foundation
import GnDKit

public struct KemenPPPAParamRequest: Paramable {
  
  private let type: String
  private let consultation: Consultation
  private let form: Form
  
  public init(
    type: String,
    consultation: Consultation,
    form: Form
  ) {
    self.type = type
    self.consultation = consultation
    self.form = form
  }
  
  public func toParam() -> [String : Any] {
    return [
      "type" : type,
      "consultation" : consultation.toParam(),
      "form" : form.toParam()
    ]
  }
  
  public struct Consultation: Paramable {
    private let orderType: String
    private let lawyerID: Int
    private let skillID: Int
    private let description: String
    
    public init(
      orderType: String,
      lawyerID: Int,
      skillID: Int,
      description: String
    ) {
      self.orderType = orderType
      self.lawyerID = lawyerID
      self.skillID = skillID
      self.description = description
    }
    
    public func toParam() -> [String : Any] {
      return [
        "order_type" : orderType,
        "lawyer_id" : lawyerID,
        "skill_id" : skillID,
        "description" : description
      ]
    }
  }
  
  public struct Form: Paramable {
    private let reasonFollowUpConsultation: String?
    private let relation: String
    private let identifier: String
    private let caseLocation: String
    
    public init(
      reasonFollowUpConsultation: String?,
      relation: String,
      identifier: String,
      caseLocation: String
    ) {
      self.reasonFollowUpConsultation = reasonFollowUpConsultation
      self.relation = relation
      self.identifier = identifier
      self.caseLocation = caseLocation
    }
    
    public func toParam() -> [String : Any] {
      var params: [String : Any] = [
        "relation": relation,
        "identifier": identifier,
        "case_location": caseLocation
      ]
      
      if let reason = reasonFollowUpConsultation {
        params["reason_follow_up_consultation"] = reason
      }
      
      return params
    }
    
  }
  
}
