//
//  ContentView.swift
//  DragAndDropList_SwiftUI
//
//  Created by SeongMinK on 2022/01/03.
//

import SwiftUI

struct DataItem: Hashable, Identifiable {
    var id: UUID
    var title: String
    var color: Color
    
    init(title: String, color: Color) {
        self.id = UUID()
        self.title = title
        self.color = color
    }
}

struct ContentView: View {
    @State var dataList = [
        DataItem(title: "1번", color: .red),
        DataItem(title: "2번", color: .yellow),
        DataItem(title: "3번", color: .green)
    ]
    @State var draggedItem: DataItem?
    @State var isEditMode = false
    
    var body: some View {
        LazyVStack {
            Toggle("수정 모드", isOn: $isEditMode)
            ForEach(dataList, id: \.self) { dataItem in
                Text(dataItem.title)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(dataItem.color)
                    .onDrag {
                        self.draggedItem = dataItem
                        return NSItemProvider(item: nil, typeIdentifier: dataItem.title)
                    }
                    .onDrop(of: [dataItem.title],
                            delegate: MyDropDelegate(currentItem: dataItem,
                                                     dataList: $dataList,
                                                     draggedItem: $draggedItem,
                                                     isEditMode: $isEditMode))
            }
        }
        .onChange(of: isEditMode, perform: { changedEditMode in
            print("변경된 수정 모드 상태:", changedEditMode)
        })
    }
}

struct MyDropDelegate: DropDelegate {
    let currentItem: DataItem
    @Binding var dataList: [DataItem]
    @Binding var draggedItem: DataItem?
    @Binding var isEditMode: Bool
    
    // 드랍에서 벗어남
    func dropExited(info: DropInfo) {
        print(#fileID, #function, "called")
    }
    
    // 드랍 처리
    func performDrop(info: DropInfo) -> Bool {
        print(#fileID, #function, "called")
        return true
    }
    
    // 드랍 업데이트
    func dropUpdated(info: DropInfo) -> DropProposal? {
//        print(#fileID, #function, "called")
        return nil
    }
    
    // 드랍 유효 여부
    func validateDrop(info: DropInfo) -> Bool {
        print(#fileID, #function, "called")
        return true
    }
    
    // 드랍 시작
    func dropEntered(info: DropInfo) {
        print(#fileID, #function, "called")
        
        if !isEditMode { return }
        guard let draggedItem = draggedItem else { return }
        
        // 드래깅 된 아이템이 현재 아이템과 다르면
        if draggedItem != currentItem {
            let from = dataList.firstIndex(of: draggedItem)!
            let to = dataList.firstIndex(of: currentItem)!
            withAnimation {
                self.dataList.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
