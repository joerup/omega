//
//  ExportView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/30/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI
import UniformTypeIdentifiers

struct ExportView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @ObservedObject var settings = Settings.settings
    
    var inputCalculations: [PastObject]
    @State private var calculations: [PastObject] = []
    
    @State private var fileType: UTType = .commaSeparatedText
    
    @State private var exportCSV = false
    @State private var csvFile: CSVFile = CSVFile()
    
    @State private var exportPDF = false
    @State private var pdfFile: PDFFile = PDFFile()
    
    var calculationsPreset: Bool = false
    @State private var selectType: CalculationSelectType = .all
    @State private var pastRangeValue: Int = 1
    @State private var pastRangeComponent: Calendar.Component = .day
    
    @State private var includeDate: Bool = true
    @State private var includeTime: Bool = true
    @State private var includeInput: Bool = true
    @State private var includeResult: Bool = true
    @State private var includeExtraResults: Bool = false
    @State private var includeName: Bool = false
    @State private var includeFolder: Bool = false
    
    var fullScreen: Bool = false
    
    var fileName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy_MM_dd_HHmmss"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        return "Omega_Calculator_Export_"+dateFormatter.string(from: Date())
    }
    
    var size: Size {
        return verticalSizeClass == .compact || horizontalSizeClass == .compact ? .small : .large
    }
    
    init() {
        self.inputCalculations = []
        self.fullScreen = true
    }
    init(calculation: PastObject) {
        self.inputCalculations = [calculation]
        self.calculationsPreset = true
    }
    init(calculations: [PastObject]) {
        self.inputCalculations = calculations
        self.calculationsPreset = true
    }
    
    enum CalculationSelectType {
        case all
        case range
    }
    
    var body: some View {
        
        PopUpSheet(title: "Export", fullScreen: fullScreen, showCancel: !fullScreen, confirmText: "Export", confirmAction: {
            
            if fileType == .commaSeparatedText {
                self.csvFile = createCSVFile()
                self.exportCSV = true
            }
            else if fileType == .pdf {
                self.exportPDF = true
            }
        }) {
            
            VStack(spacing: 0) {
                
                if fullScreen {
                    NavigationHeader("Export")
                }
                
                ScrollView {
                    
                    VStack(spacing: 20) {
                            
                        Text(calculations.count == 1 ? "1 calculation selected" : "\(calculations.count) calculations selected")
                            .font(Font.system(.subheadline, design: .rounded).weight(.semibold))
                            .foregroundColor(Color.init(white: 0.8))
                            .padding(.top, fullScreen ? 15 : 0)
                        
                        SettingsGroup(light: fullScreen ? 0.15 : 0.3) {
                           
                            if !calculationsPreset {
                                
                                SettingsRow {
                                    HStack {
                                        SettingsText(title: "Calculations Selected")
                                        Spacer()
                                        Picker("", selection: self.$selectType) {
                                            Text("All").tag(CalculationSelectType.all)
                                            Text("Select").tag(CalculationSelectType.range)
                                        }
                                        .pickerStyle(SegmentedPickerStyle())
                                    }
                                }
                                
                                if selectType == .range {
                                    SettingsRow {
                                        HStack(spacing: 0) {
                                            SettingsText(title: "Selection")
                                            Spacer()
                                            Text("in the past")
                                            Picker("", selection: self.$pastRangeValue) {
                                                ForEach(1..<51) { num in
                                                    Text(String(num)).tag(num)
                                                }
                                            }
                                            Picker("", selection: self.$pastRangeComponent) {
                                                Text(pastRangeValue > 1 ? "hours" : "hour").tag(Calendar.Component.hour)
                                                Text(pastRangeValue > 1 ? "days" : "day").tag(Calendar.Component.day)
                                                Text(pastRangeValue > 1 ? "months" : "month").tag(Calendar.Component.month)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .onChange(of: selectType) { _ in
                            self.calculations = getCalculations()
                        }
                        .onChange(of: pastRangeValue) { _ in
                            self.calculations = getCalculations()
                        }
                        .onChange(of: pastRangeComponent) { _ in
                            self.calculations = getCalculations()
                        }
                        
                        SettingsGroup(light: fullScreen ? 0.15 : 0.3) {
                            SettingsRow {
                                HStack {
                                    SettingsText(title: "File Type")
                                    Spacer()
                                    Picker("", selection: self.$fileType) {
                                        Text("CSV").tag(UTType.commaSeparatedText)
                                    }
                                }
                            }
                        }
                        
                        SettingsGroup("Columns", light: fullScreen ? 0.15 : 0.3) {
                            
                            SettingsToggle(toggle: self.$includeDate, title: "Date")
                            SettingsToggle(toggle: self.$includeTime, title: "Time")
                            
                            SettingsToggle(toggle: self.$includeInput, title: "Input")
                            SettingsToggle(toggle: self.$includeResult, title: "Result")
                            
                            SettingsToggle(toggle: self.$includeExtraResults, title: "Extra Results")
                            SettingsToggle(toggle: self.$includeName, title: "Name")
                            SettingsToggle(toggle: self.$includeFolder, title: "Folder")
                        }
                        
                        Text("Note: The exported file may take a few moments to generate.")
                            .font(.footnote)
                            .foregroundColor(Color.init(white: 0.6))
                            .multilineTextAlignment(.center)
                            .padding(15)
                            .padding(.bottom, 10)
                    }
                }
            }
        }
        .accentColor(color(settings.theme.color1, edit: true))
        .fileExporter(isPresented: self.$exportCSV, document: csvFile, contentType: fileType, defaultFilename: fileName, onCompletion: { result in
            switch result {
            case .success(let url):
                print("Saved to \(url)")
                completeExport()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        .onAppear {
            if calculationsPreset {
                self.calculations = inputCalculations
            } else {
                self.calculations = getCalculations()
            }
        }
    }
    
    func createCSVFile() -> CSVFile {
        return CSVFile(initialText: string())
    }
    
    func createPDFFile() -> PDFFile {
        return PDFFile(initialText: string())
    }
    
    func string() -> String {
        
        var string = ""
        if includeDate { string += "Date," }
        if includeTime { string += "Time," }
        if includeInput { string += "Input," }
        if includeResult { string += "Result," }
        if includeExtraResults { string += "Extra Results," }
        if includeName { string += "Name," }
        if includeFolder { string += "Folder," }
        if string.last == "," {
            string.removeLast()
            string += "\n"
        }
        
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        
        let calculations = self.calculations.sorted(by: { $0.date ?? Date() < $1.date ?? Date() }).filter({ $0 is PastCalculation }).map({ $0 as! PastCalculation })
        
        for calculation in calculations {
                
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.string(from: calculation.date ?? Date())
            
            dateFormatter.dateFormat = "HH:mm:ss"
            let time = dateFormatter.string(from: calculation.date ?? Date())
            
            let input = calculation.queue.exportString()
            let result = calculation.result.exportString()
            
            let extraResults = calculation.extraResults.map{ $0.exportString() }.joined(separator: ", ")
            
            let name = calculation.name ?? ""
            let folder = calculation.folder ?? ""
            
            if includeDate { string += "\(date)," }
            if includeTime { string += "\(time)," }
            if includeInput { string += "\(input)," }
            if includeResult { string += "\(result)," }
            if includeExtraResults { string += "\"\(extraResults)\"," }
            if includeName { string += "\(name)," }
            if includeFolder { string += "\(folder)," }
            if string.last == "," {
                string.removeLast()
                string += "\n"
            }
        }
        
        return string
    }
    
    func getCalculations() -> [PastObject] {
        
        if selectType == .all {
            
            return PastCalculation.getCalculations()
        }
        else if selectType == .range, let beginDate = Calendar.current.date(byAdding: pastRangeComponent, value: -pastRangeValue, to: Date()) {
            
            return PastCalculation.getCalculations(dates: beginDate..<Date())
        }
        
        return []
    }
    
    func completeExport() {
        settings.notification = .export
        settings.popUp = nil
        PastObject.refresh.toggle()
    }
}

struct CSVFile: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.commaSeparatedText]
    static var writableContentTypes = [UTType.commaSeparatedText]

    // by default our document is empty
    var text = ""

    // a simple initializer that creates new, empty documents
    init(initialText: String = "") {
        text = initialText
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}

struct PDFFile: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.pdf]
    static var writableContentTypes = [UTType.pdf]

    // by default our document is empty
    var text = ""

    // a simple initializer that creates new, empty documents
    init(initialText: String = "") {
        text = initialText
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
