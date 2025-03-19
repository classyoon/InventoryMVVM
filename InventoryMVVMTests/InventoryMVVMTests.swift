//
//  InventoryMVVMTests.swift
//  InventoryMVVMTests
//
//  Created by Conner Yoon on 3/18/25.
//

import Testing
@testable import InventoryMVVM

struct InventoryMVVMTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

}
enum Place : String, CaseIterable, Identifiable {
    var id : Self { self }
    case outside, inside, farm, grave
}

class Survivor {
    var place : Place = .inside
}
