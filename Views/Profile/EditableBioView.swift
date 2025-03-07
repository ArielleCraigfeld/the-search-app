//
//  EditableBioView.swift
//  search
//
//  Created by Arielle Craigfeld on 2/6/25.
//
//  EditableBioView.swift
//  search
//
//  Created by Arielle Craigfeld on 2/6/25.
//
import SwiftUI

struct EditableBioView: View {
    @Binding var bioText: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 15) {
            // Header with back button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Text("Edit Bio")
                    .font(.title.bold())
                
                Spacer()
            }
            .padding(.horizontal)
            
            // Editable Bio Text Field
            TextEditor(text: $bioText)
                .frame(height: 150)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .padding(.horizontal)
            
            Button("Save") {
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            Spacer()
        }
        .padding()
    }
}

struct EditableBioView_Previews: PreviewProvider {
    static var previews: some View {
        EditableBioView(bioText: .constant("This is a sample bio."))
    }
}
