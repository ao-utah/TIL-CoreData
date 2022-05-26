//
//  ContentView.swift
//  TIL-CoreData
//
//  Created by 青木雄太 on 2022/05/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DefaultSampleView()
                .tabItem {
                    Image(systemName: "app")
                    Text("sample1")
                }
            DynamicFilterSampleView()
                .tabItem {
                    Image(systemName: "app")
                    Text("sample2")
                }
            MVVMSampleView()
                .tabItem {
                    Image(systemName: "app")
                    Text("sample3")
                }
            SectionedFetchRequestSampleView()
                .tabItem {
                    Image(systemName: "app")
                    Text("sample4")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
