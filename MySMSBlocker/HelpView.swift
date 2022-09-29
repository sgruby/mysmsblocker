//
//  HelpView.swift
//  MySMSBlocker
//
//  Created by Scott Gruby on 10/1/22.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            PageView(pages: [HelpPageView(pageNumber: 0), HelpPageView(pageNumber: 1), HelpPageView(pageNumber: 2)])
                .toolbar {
                    ToolbarItem (placement: .navigationBarTrailing){
                        Button(action: {dismiss()}) {
                            Text("Done")
                        }
                    }
                }
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
