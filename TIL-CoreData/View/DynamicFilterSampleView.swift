//
//  DynamicFilterSampleView.swift
//  TIL-CoreData
//
//  Created by 青木雄太 on 2022/05/25.
//

import SwiftUI
import CoreData

/*
 参考：SwiftUIを使用して@FetchRequestを動的にフィルタリングする
 https://www.hackingwithswift.com/books/ios-swiftui/dynamically-filtering-fetchrequest-with-swiftui
 */

struct DynamicFilterSampleView: View {
    
////    @Environment(\.managedObjectContext) private var viewContext
//////
//////    @FetchRequest(
//////        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//////        animation: .default)
//    private var items: FetchedResults<Item>
    
    @Environment(\.managedObjectContext) var moc
    
    @State private var lastNameFilter = "A"
    
    var body: some View {
        VStack {
            //FilteredList(filter: lastNameFilter)
            FilteredList_v2(filterKey: "lastName", filterValue: lastNameFilter) { (singer: Singer) in
                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
            }

            Button("Add Examples") {
                let taylor = Singer(context: moc)
                taylor.firstName = "Taylor"
                taylor.lastName = "Swift"

                let ed = Singer(context: moc)
                ed.firstName = "Ed"
                ed.lastName = "Sheeran"

                let adele = Singer(context: moc)
                adele.firstName = "Adele"
                adele.lastName = "Adkins"

                try? moc.save()
            }

            Button("Show A") {
                lastNameFilter = "A"
            }

            Button("Show S") {
                lastNameFilter = "S"
            }
        }
    }
}

struct DynamicFilterSampleView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicFilterSampleView()
    }
}



struct FilteredList: View {
    
    // フェッチリクエスト（あくまで定義。この時点ではフェッチ要求を作成しない）
    @FetchRequest var fetchRequest: FetchedResults<Singer>
    
    init(filter: String) {
        // フェッチリクエスト
        //（このinit()内でフェッチを要求。親ビューの @State lastNameFilter が変更されるたびに内容が変更される）
        _fetchRequest = FetchRequest<Singer>(sortDescriptors: [], predicate: NSPredicate(format: "lastName BEGINSWITH %@", filter),animation: .default)
    }
    
    
    var body: some View{
        List(fetchRequest, id: \.self) { singer in
                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
            }
    }
}

struct FilteredList_v2<T: NSManagedObject, Content: View>: View {
    @FetchRequest var fetchRequest: FetchedResults<T>

    // this is our content closure; we'll call this once for each item in the list
    let content: (T) -> Content

    var body: some View {
        List(fetchRequest, id: \.self) { singer in
            self.content(singer)
        }
    }

    init(filterKey: String, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
        _fetchRequest = FetchRequest<T>(sortDescriptors: [], predicate: NSPredicate(format: "%K BEGINSWITH %@", filterKey, filterValue),animation: .default)
        self.content = content
    }
}



/*
 
 Tip: You might look at our code and think that every time the view is recreated – which is every time any state changes in our container view – we’re also recreating the fetch request, which in turn means reading from the database when nothing else has changed.

 That might seem terribly wasteful, and it would be terribly wasteful if it actually happened. Fortunately, Core Data won’t do anything like this: it will only actually re-run the database query when the filter string changes, even if the view is recreated.
 
 【翻訳】
 ヒント：
 コードを見て、ビューが再作成されるたびに、つまりコンテナビューで状態が変化するたびに考えるかもしれません。
 また、フェッチリクエストを再作成しています。これは、他に何も変更されていないときにデータベースから読み取ることを意味します。
 
 それはひどく無駄に見えるかもしれません、そしてそれが実際に起こったならばそれはひどく無駄になるでしょう。
 幸い、CoreDataはこのようなことはしません。
 ビューが再作成された場合でも、フィルター文字列が変更されたときにのみデータベースクエリを実際に再実行します。
 
 */


