//
//  ComplicationController.swift
//  Kovid Apple Watch WatchKit Extension
//
//  Created by Kristaps Grinbergs on 16/10/2020.
//

import ClockKit
import SwiftUI

class ComplicationController: NSObject, CLKComplicationDataSource {
  
  // MARK: - Complication Configuration
  
  func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
    let descriptors = [
      CLKComplicationDescriptor(identifier: "complication", displayName: "Kovid", supportedFamilies: [CLKComplicationFamily.graphicCircular])
      
      // CLKComplicationFamily.allCases
      // Multiple complication support can be added here with more descriptors
    ]
    
    // Call the handler with the currently supported complication descriptors
    handler(descriptors)
  }
  
  func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
    // Do any necessary work to support these newly shared complication descriptors
  }
  
  // MARK: - Timeline Configuration
  
  func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
    // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
    handler(nil)
  }
  
  func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
    // Call the handler with your desired behavior when the device is locked
    handler(.showOnLockScreen)
  }
  
  // MARK: - Timeline Population
  
  func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
    // Call the handler with the current timeline entry
    
    if complication.family == .graphicCircular {
      
  
      //    switch complication.family {
      //    case .modularSmall:
      //      <#code#>
      //    case .modularLarge:
      //      <#code#>
      //    case .utilitarianSmall:
      //      <#code#>
      //    case .utilitarianSmallFlat:
      //      <#code#>
      //    case .utilitarianLarge:
      //      <#code#>
      //    case .circularSmall:
      //      <#code#>
      //    case .extraLarge:
      //      <#code#>
      //    case .graphicCorner:
      //      <#code#>
      //    case .graphicBezel:
      //      <#code#>
      //    case .graphicCircular:
      //      <#code#>
      //    case .graphicRectangular:
      //      <#code#>
      //    case .graphicExtraLarge:
      //      <#code#>
      //    @unknown default:
      //      <#code#>
      //    }

      let currentDate = Date()
      let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!

      KovidAPI().getYesterdayData { kovidData in

        let view = CLKComplicationTemplateGraphicCircularView(Text("\(kovidData.infectedCount)").foregroundColor(.orange))

        let entry = CLKComplicationTimelineEntry(date:currentDate, complicationTemplate: view)

        handler(entry)
      }
    }
  }
  
  func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
    // Call the handler with the timeline entries after the given date
//    let currentDate = Date()
//    let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
//    
//    KovidAPI().getYesterdayData { kovidData in
//      
//      let view = CLKComplicationTemplateGraphicCircularView(Text("\(kovidData.deathCount)").padding())
//      
//      let entry = CLKComplicationTimelineEntry(date:currentDate, complicationTemplate: view)
//      
//      handler([entry])
//    }
    
    handler(nil)
  }
  
  // MARK: - Sample Templates
  
  func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
    // This method will be called once per supported complication, and the results will be cached
    
    handler(CLKComplicationTemplateGraphicCircularView(Image(systemName: "cross.case")))
  }
  
  
}
