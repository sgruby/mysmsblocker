//
//  ListItemView.swift
//  MySMSBlocker
//
//  Created by Scott Gruby on 9/30/22.
//

import SwiftUI

struct ListItemView: View {
    enum Field: Hashable {
        case match
    }

    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @State var filter: Filter?
    @State var sender: Int = 0
    @State var allow: Int = 0
    @State var match: String = ""
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationView {
            Form {
                Section("Type") {
                    Picker("BodySender", selection: $sender) {
                        Text("Body").tag(0)
                        Text("Sender").tag(1)
                    }
                    .pickerStyle(.segmented)
                    Picker("Allow", selection: $allow) {
                        Text("Block").tag(0)
                        Text("Allow").tag(1)
                    }
                    .pickerStyle(.segmented)
                }
                Section("Match") {
                    TextField("Match", text: $match)
                        .focused($focusedField, equals: .match)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewContext.undo()
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        save()
                    } label: {
                        Text("Done")
                    }
                }
            }
            .onAppear {
                if let filter = filter {
                    sender = filter.sender == true ? 1 : 0
                    allow = filter.allow == true ? 1 : 0
                    match = filter.wrappedMatch
                } else {
                    sender = 0
                    allow = 0
                    match = ""
                }
                
                focusedField = .match
            }
        }
    }
    
    func save() {
        guard match.isEmpty == false else {return}
        if filter == nil {
            filter = Filter(context: viewContext)
        }
        filter?.match = match
        filter?.sender = sender == 1
        filter?.allow = allow == 1
        try? viewContext.save()
        dismiss()
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let newItem = Filter(context: CloudKitPersistenceController.preview.container.viewContext)
        ListItemView(filter: newItem)
            .environment(\.managedObjectContext, CloudKitPersistenceController.preview.container.viewContext)
    }
}
