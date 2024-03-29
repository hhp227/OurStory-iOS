//
//  NullPaddedList.swift
//  Application
//
//  Created by 홍희표 on 2023/01/04.
//

protocol NullPaddedList {
    associatedtype T
    
    var placeholdersBefore: Int { set get }
    
    func getFromStorage(_ localIndex: Int) -> T
    
    var placeholdersAfter: Int { set get }
    
    var size: Int { get }
    
    var storageCount: Int { set get }
}
