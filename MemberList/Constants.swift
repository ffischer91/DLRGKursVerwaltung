//
//  Constants.swift
//  MemberList
//
//  Created by flo on 01.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import Foundation

public struct Constants {
    static let CellReuseIdentifier = "Member Table Cell"
    static let CellEventHeaders = "Event Cell Header"
    static let CellEventTable   = "Event Table Cell"
    static let CellEDTrainer = "Cell ED Trainer"
    static let CellEDDate = "Cell ED Date"
    static let CellEDMember = "Cell ED Member"
    static let CellEDMemberPopup = "Cell ED Member Popup"
    
    
    static let CellMemberDetailTextField = "MDTextfieldCell"
    static let CellMemberDetailPhoto = "MDPhotoCell"
    static let CellMemberDetailSwitch = "MDSwitchCell"
    static let CellMemberDetailTextView = "MDTextViewCell"
    static let CellMemberDetailTable = "MDTableCell"
    
    
    static let ShowDetailMemberSegue = "Show Detail Member"
    static let ShowNewMemberSegue = "Show New Member"
    
    static let ShowDetailEvent = "Show Detail Event"
    static let ShowNewEvent = "Show New Event"
    static let ShowEventHeader = "Show Event Header"
    
    static let Cell_Allgemein = 0
    static let ShowDetailEventAllgemein = "Show Detail Event Allgemein"
    static let Cell_Termine = 1
    static let ShowDetailEventTermin = "Show Detail Event Termin"
    static let Cell_Teilnehmer = 2
    static let Cell_Helfer = 3
    
    static let ShowEDMemberPopover = "Show Member Popover"
    
    
    
    static let EntityMember = "Member"
    static let EntityTrainer = "Trainer"
    static let EntityEvent = "Event"
    
    static let CellMDLableText = [ "Vorname", "Nachname", "Straße", "PLZ", "Ort", "Foto", "Mitglied", "Notiz", "Kurse"]
    
    static let CellTrainerInfo = "Trainer Table Cell"
    static let ShowNewTrainerSegue = "Show New Trainer"
    static let ShowDetailTrainerSegue = "Show Detail Trainer"
    static let CellTrainerDetailTextField = "TDTextfieldCell"
    static let CellTrainerDetailEventTab = "TDEventTabCell"
}