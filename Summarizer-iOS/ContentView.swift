//
//  ContentView.swift
//  Summarizer-iOS
//
//  Created by Woo Sung Jahng on 2024/06/01.
//

import SwiftUI

struct ContentView: View {
    @State private var documentType = "Text"
    @State private var userPrompt = ""
    @State private var userText = ""
    @State private var websiteLink = ""
    @State private var pdfData: Data?
    @State private var summary: [String] = []
    
    var body: some View {
        VStack {
            Picker("Document Type", selection: $documentType) {
                Text("Text").tag("Text")
                Text("Website Link").tag("Website Link")
                Text("PDF").tag("PDF")
            }
            .pickerStyle(SegmentedPickerStyle())
            
            switch documentType {
            case "Text":
                TextField("Enter prompt", text: $userPrompt)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextEditor(text: $userText)
                    .frame(height: 200)
                    .padding()
            case "Website Link":
                TextField("Enter prompt", text: $userPrompt)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Enter website link", text: $websiteLink)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            case "PDF":
                TextField("Enter prompt", text: $userPrompt)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: selectPDF) {
                    Text("Select PDF")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            default:
                EmptyView()
            }
            
            Button(action: summarizeDocument) {
                Text("Summarize")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(summary, id: \.self) { message in
                        Text(message)
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
    
    func selectPDF() {
        
    }
    
    func summarizeDocument() {
        let apiKey = Config.apiKey
        let url = URL(string: "https://api.anthropic.com/v1/messages")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        
        switch documentType {
        case "Text":
            guard !userText.isEmpty else { return }
            let requestBody: [String: Any] = [
                "system": userPrompt,
                "messages": [
                    ["role": "user", "content": "Summarize the following text delimited with triple backticks. ```\(userText)```"]
                ],
                "model": "claude-3-opus-20240229",
                "max_tokens": 1000
            ]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
                request.httpBody = jsonData
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let data = data else {
                        print("No data received")
                        return
                    }
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                             print("JSON Result: \(jsonResult)")
                            if let content = jsonResult["content"] as? [[String: Any]],
                               let text = content.first?["text"] as? String {
                                DispatchQueue.main.async {
                                    summary.append(text)
                                }
                            }
                        }
                    } catch {
                        print("Error parsing JSON: \(error.localizedDescription)")
                    }
                }.resume()
            } catch {
                print("Error creating JSON: \(error.localizedDescription)")
            }
        
        case "Website Link":
            guard !websiteLink.isEmpty else { return }
            let requestBody: [String: Any] = [
                "system": userPrompt,
                "messages": [
                    ["role": "user", "content": "Summarize the following website delimited with triple backticks. ```\(websiteLink)```"]
                ],
                "model": "claude-3-opus-20240229",
                "max_tokens": 1000
            ]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
                request.httpBody = jsonData
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let data = data else {
                        print("No data received")
                        return
                    }
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                             print("JSON Result: \(jsonResult)")
                            if let content = jsonResult["content"] as? [[String: Any]],
                               let text = content.first?["text"] as? String {
                                DispatchQueue.main.async {
                                    summary.append(text)
                                }
                            }
                        }
                    } catch {
                        print("Error parsing JSON: \(error.localizedDescription)")
                    }
                }.resume()
            } catch {
                print("Error creating JSON: \(error.localizedDescription)")
            }
            
//        case "PDF":
//            guard !pdfData.isEmpty else { return }
//            inputText = pdfData
            
        default:
            break
        }
    }
}

#Preview {
    ContentView()
}
