//
//  Tracker.swift
//  KBReffing
//
//  Created by Mark Miranda on 3/13/21.
//

import Foundation

class Tracker {
    var undoOrRedoFunctionCalled = false
    var resetStatStateFunctionCalled = false
    
    func undoOrRedoCalled() -> Void {
        undoOrRedoFunctionCalled = true
    }
    
    func resetStatStateCalled() -> Void {
        resetStatStateFunctionCalled = true
    }
}


//
