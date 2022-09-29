//
//  ContentView.swift
//  MySMSBlocker
//
//  Created by Scott Gruby on 9/29/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("helpShown") var helpShown: Bool = false
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Filter.allow, ascending: false), NSSortDescriptor(key: "match", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))],
        animation: .default)
    private var filters: FetchedResults<Filter>
    @State private var selectedFilter: Filter?
    @State private var newFilter = false
    @State private var showHelp = false

    var body: some View {
        NavigationView {
            Group {
                if filters.isEmpty {
                    Button(action: addDefaultData) {
                        Text("Add sample filters")
                    }
                } else {
                    List {
                        ForEach(filters) { filter in
                            HStack {
                                Image(systemName: filter.allow ? "checkmark" : "exclamationmark.octagon")
                                    .imageScale(.large)
                                    .foregroundColor(filter.allow ? .green : .red)
                                Text(filter.wrappedMatch)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectedFilter = filter
                                    }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
            }
            .toolbar {
                ToolbarItem (placement: .navigationBarLeading){
                    Button(action: {showHelp = true}) {
                        Label("Help", systemImage: "questionmark.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .sheet(item: $selectedFilter) { filter in
            ListItemView(filter: filter)
        }
        .sheet(isPresented: $newFilter) {
            ListItemView()
        }
        .sheet(isPresented: $showHelp) {
            HelpView()
        }
        .onAppear {
            if helpShown == false {
                showHelp = true
                helpShown = true
            }
        }
        
    }

    private func addItem() {
        withAnimation {
            newFilter = true
        }
    }
    
    private func addDefaultData() {
        let defaultFilters = Bundle.main.decode([DefaultFilter].self, from: "DefaultList.json")
        defaultFilters.forEach { filter in
            let newFilter  = Filter(context: viewContext)
            newFilter.match = filter.match
            newFilter.sender = filter.sender
            newFilter.allow = filter.allow
        }
        try? viewContext.save()
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { filters[$0] }.forEach(viewContext.delete)

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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, CloudKitPersistenceController.preview.container.viewContext)
    }
}
