//
//  IntX.swift
//  blk
//
//  Created by Nabeel Shafique on 02/11/2022.
//

import Foundation

extension Int {
	var toString: String {
		
		return String(self)
	}
	
	var shorted: String {
		let num = self
		let thousandNum = num/1000
		let millionNum = num/1000000
		if num >= 1000 && num < 1000000{
			if(thousandNum == thousandNum){
				return("\(thousandNum)k")
			}
			return("\(thousandNum)k")
		}
		if num > 1000000{
			if(millionNum == millionNum){
				return("\(millionNum)M")
			}
			return ("\(millionNum)M")
		}
		else{
			if(num == num){
				return ("\(num)")
			}
			return ("\(num)")
		}
	}
}
