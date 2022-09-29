//
//  MessageFilterExtension.swift
//  MySMSBlockerExtension
//
//  Created by Scott Gruby on 9/29/22.
//

import IdentityLookup
import CoreData

final class MessageFilterExtension: ILMessageFilterExtension {}

extension MessageFilterExtension: ILMessageFilterQueryHandling {
    func handle(_ queryRequest: ILMessageFilterQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterQueryResponse) -> Void) {

        let response = ILMessageFilterQueryResponse()
        response.action = self.filterAction(for: queryRequest)
        completion(response)
    }

    private func filterAction(for queryRequest: ILMessageFilterQueryRequest) -> ILMessageFilterAction {
        let persistence = CloudKitPersistenceController(readOnly: true)
        // Look for all the records that contain the sender or body
        // Sort by allow
        let request = Filter.fetchRequest()
        var result: ILMessageFilterAction = .none
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Filter.allow, ascending: false)]
        do {
            let results = try persistence.container.viewContext.fetch(request)
            for (_, filter) in results.enumerated() {
                guard let match = filter.match?.lowercased() else {continue}
                if let sender = queryRequest.sender?.lowercased(), filter.sender == true, sender.contains(match) {
                    result = filter.allow ? .allow : .junk
                    break
                } else if let body = queryRequest.messageBody?.lowercased(), filter.sender == false, body.contains(match) {
                    result = filter.allow ? .allow : .junk
                    break
                }
            }
        } catch {
            
        }
        return result
    }
}
