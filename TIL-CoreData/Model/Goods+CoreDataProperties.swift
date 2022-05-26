//
//  Goods+CoreDataProperties.swift
//  TIL-CoreData
//
//  Created by 青木雄太 on 2022/05/25.
//
//

import Foundation
import CoreData


extension Goods {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goods> {
        return NSFetchRequest<Goods>(entityName: "Goods")
    }

    @NSManaged public var category: String
    @NSManaged public var name: String?
    @NSManaged public var price: NSDecimalNumber?
    @NSManaged public var createAt: Date?
    
    
    /*
     参考：SwiftUIリストのDate（）によるCoreDataのセクションとしてのグループ化
     https://stackoverflow.com/questions/70384263/grouping-coredata-by-date-in-swiftui-list-as-sections
     */
    @objc
    public var sections: String {
        // DateFormatter のインスタンスを作成
        let formatter: DateFormatter = DateFormatter()
        //日付フォーマットのロケール
        formatter.locale = Locale(identifier: "ja_JP")
        // 日付の書式を文字列に合わせて設定
        formatter.dateFormat = "yyyy / M / d (EEE)"
        // 日時DateからString型の日付を生成し、返却
        if createAt != nil {
            return formatter.string(from: createAt!)
        }else{
            return "unknown"
        }
        
        /*
         下記のセクションは、「今日」、「明日」、「次の7日間」....で動的に区切るセクションのサンプル
         
         */
        
//        // I used the base Xcode core data app which has timestamp as an optional.
//        // You can remove the unwrapping if your dates are not optional.
//        if let timestamp = createAt {
//            // This sets up the RelativeDateTimeFormatter
//            let rdf = RelativeDateTimeFormatter()
//            // This gives the verbose response that you are looking for.
//            rdf.unitsStyle = .spellOut
//            // This gives the relative time in names like today".
//            rdf.dateTimeStyle = .named
//
//            // If you are happy with Apple's choices. uncomment the line below
//            // and remove everything else.
//  //        return rdf.localizedString(for: timestamp, relativeTo: Date())
//
//            // You could also intercept Apple's labels for you own
//            switch rdf.localizedString(for: timestamp, relativeTo: Date()) {
//            case "now":
//                return "today"
//            case "in two days", "in three days", "in four days", "in five days", "in six days", "in seven days":
//                return "this week"
//            default:
//                return rdf.localizedString(for: timestamp, relativeTo: Date())
//            }
//        }
//        // This is only necessary with an optional date.
//        return "undated"
    }
    
    
}

extension Goods : Identifiable {

}
