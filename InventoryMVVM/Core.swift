//
//  Core.swift
//  InventoryMVVM
//
//  Created by Conner Yoon on 3/18/25.
//

import Foundation

struct Item : Identifiable {
    var name : String = ""
    var icon : String = ""
    var id : UUID = UUID()
    static let examples = [Item(name: "Shovel"), Item(name: "Axe"), Item(name: "Book")]
    static let icons = ["🗡","😌","👑"]
}

class Inventory : ObservableObject {
    @Published var items : [Item] = Item.examples
    func add(){
        items.append(Item(name:"Something"))
    }
    func add(name: String, icon: String){
        items.append(Item(name:name, icon:icon))
    }
    func delete(indexOffset : IndexSet){
        for index in indexOffset {
            items.remove(at: index)
        }
    }
    func update(item : Item){
        guard let index = items.firstIndex(where: {$0.id == item.id}) else { return  }
         items[index] = item
    }
}

struct CreateView : View {
    @ObservedObject var vm : Inventory
    @State var selectedIcon = ""
    @State var name : String = ""
    
    var body: some View {
        VStack {
            TextField("Name", text: $name).onSubmit {
                vm.add(name: name, icon: selectedIcon)
            }
            Picker("Icon", selection: $selectedIcon) {
                ForEach(Item.icons, id : \.self){ icon in
                    Text(icon)
                }
            }
        }
    }
}
import SwiftUI
struct ListView : View {
    @StateObject var vm : Inventory = .init()
    var body : some View {
        NavigationStack{
            List{
                Section("Create"){
                    CreateView(vm: vm)
                }
                Section("List of Items"){
                    ForEach(vm.items){ item in
                        
                        NavigationLink {
                            ToolEditView(item: item, update: vm.update)
                        } label: {
                            HStack{
                                Text(item.name).font(.headline)
                                Text(item.icon).font(.title)
                            }
                        }
                        
                        
                        
                    }.onDelete(perform: vm.delete)
                    
                }
            }
        
            .toolbar {
                Button {
                    vm.add()
                } label: {
                    Text("Add")
                }
            }
            .navigationTitle("Inventory has \(vm.items.count) items")
        }
        
    }
}
struct ToolEditView : View {
    @State var item : Item
    var update : (Item)->()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            TextField("Name", text: $item.name)
                .textFieldStyle(.roundedBorder)
        }
        .toolbar {
            Button("Update"){
                update(item)
                dismiss()
            }
        }
    }
}

#Preview {
    ListView(vm: Inventory())
}
