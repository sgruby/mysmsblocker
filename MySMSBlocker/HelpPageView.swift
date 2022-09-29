//
//  HelpPageView.swift
//  MySMSBlocker
//
//  Created by Scott Gruby on 10/1/22.
//

import SwiftUI

struct HelpPageView: View {
    var pageNumber: Int
    var body: some View {
        switch pageNumber {
            case 0:
                GeometryReader { geo in
                    ScrollView {
                        HStack {
                            Spacer()
                            VStack(alignment: .leading) {
                                Spacer()
                                Text("1. Navigate to System Settings")
                                    .multilineTextAlignment(.leading)
                                Text("2. Tap Messages")
                                    .multilineTextAlignment(.leading)
                                Image("MessageSettings")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width * 0.85, height: 300)
                                Text("3. Tap Unknown & Spam")
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }
            case 1:
                GeometryReader { geo in
                    ScrollView {
                        HStack {
                            Spacer()
                            VStack(alignment: .leading) {
                                Spacer()
                                Text("1. Enable Filter Unknown Senders")
                                    .multilineTextAlignment(.leading)
                                Text("2. Select MySMSBlocker")
                                    .multilineTextAlignment(.leading)
                                Image("FilterSenders")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width * 0.85, height: 300)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }
            case 2:
                GeometryReader { geo in
                    ScrollView {
                        HStack {
                            Spacer()
                            VStack(alignment: .leading) {
                                Spacer()
                                Text("1. Tap Enable")
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                    .frame(height: 10)
                                Text("Note: MySMSBlocker does NOT send your messages to a server. All filtering is done locally.")
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(nil)
                                Image("EnableFilter")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width * 0.85, height: 300)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }
            default:
                Color.red
        }
    }
}

struct HelpPageView_Previews: PreviewProvider {
    static var previews: some View {
        HelpPageView(pageNumber: 0)
    }
}
