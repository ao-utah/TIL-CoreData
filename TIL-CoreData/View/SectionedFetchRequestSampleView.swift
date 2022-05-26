//
//  SectionedFetchRequestSampleView.swift
//  TIL-CoreData
//
//  Created by 青木雄太 on 2022/05/25.
//

import SwiftUI
import CoreData

/*
 参考：SwiftUI × CoreData でセクション分けされたリストを作る
 https://zenn.dev/muhiro12/articles/swiftui-sectionedfetchrequest
 */

struct SectionedFetchRequestSampleView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @SectionedFetchRequest(
        // グルーピングに利用する要素を指定
        sectionIdentifier: \.sections,
        // ソートの指定
        sortDescriptors: [NSSortDescriptor(keyPath: \Goods.category, ascending: true),
                          NSSortDescriptor(keyPath: \Goods.name, ascending: true)],
        animation: .default)
    
    private var sections: SectionedFetchResults<String, Goods>
    
    @State var inputName:String = ""
    @FocusState var isInputNameActive: Bool
    
    @State var inputCategory:String = ""
    @FocusState var isInputCategoryActive: Bool
    
    @State var inputPrice:String = ""
    @FocusState var isInputPriceActive: Bool
    
    var body: some View {
        NavigationView {
            VStack{
                TextField("商品名", text: $inputName)
                    .focused($isInputNameActive)
                    .padding(.horizontal)
                TextField("カテゴリ名", text: $inputCategory)
                    .focused($isInputCategoryActive)
                    .padding(.horizontal)
                TextField("金額", text: $inputPrice)
                    .focused($isInputPriceActive)
                    .padding(.horizontal)
                    .keyboardType(.numberPad)
                
                
                List {
                    ForEach(sections) { section in
                        Section(content: {
                            ForEach(section) { Goods in
                                Text(Goods.name ?? "") // りんご
                            }
                        }, header: {
                            // `section.id` で指定した要素(カテゴリ)を取得可能
                            Text(section.id) // フルーツ
                        })
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addGoods) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        
                        Button("Done") {
                            isInputNameActive = false
                            isInputCategoryActive = false
                            isInputPriceActive = false
                        }
                    }
                }
            }
        }
    }
    
    private func addGoods() {
        withAnimation {
            let newGoods = Goods(context: viewContext)
            newGoods.name = inputName
            newGoods.category = inputCategory
            newGoods.price =  Decimal(string: inputPrice) as NSDecimalNumber?
            newGoods.createAt =  Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct SectionedFetchRequestSampleView_Previews: PreviewProvider {
    static var previews: some View {
        SectionedFetchRequestSampleView()
    }
}
