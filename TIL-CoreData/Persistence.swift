//
//  Persistence.swift
//  TIL-CoreData
//
//  Created by 青木雄太 on 2022/05/24.
//

import CoreData

struct PersistenceController {
    
    // 本番用 (実機、シュミレータ)
    static let shared = PersistenceController()

    // プレビュー用
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)  // inmemory=trueにすることで、メモリ上にだけ保持される。
        let viewContext = result.container.viewContext
        
        // プレビュー用のCoreDataのデータ生成
        // （メモリ上に保持されるので、プレビューが消えると破棄される）
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    // NSPersistentContainerの定義
    let container: NSPersistentCloudKitContainer
    
    // 初期化処理
    // 実行されるたイミングは、sharedまたはpreviewを呼び出したときに実行される
    // previewを実行時は、inMemoryがtrueになるので、メモリ上のみにデータが保持される
    init(inMemory: Bool = false) {
        
        // NSPersistentContainerのセット（これはアプリ上でユニークとなる）
        container = NSPersistentCloudKitContainer(name: "TIL_CoreData")
        
        if inMemory {
            // ?（inMemory=trueの場合のみ）永続ストアの保存するURLパスの指定。
            // /dev/nullはおそらくメモリ上で保持されるURLパスと思われる
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // 永続ストアの読み込み
        // completionHandlerは読み込み完了時に実行される。
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        //
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
