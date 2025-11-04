//
//  ContentView.swift
//  StudentManager
//
//  Created by ddukk15 on 04/11/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \StudentManagedObject.rollNumber, ascending: true)],
        animation: .default)
    private var students: FetchedResults<StudentManagedObject>
    
    @State  private var name = ""
    @State private var rollNumber = ""
    @State private var selectedStudent: StudentManagedObject? = nil
    
    var body: some View {
        NavigationView {
            VStack{
                TextField("Enter name",text: $name)
                    .padding(.all)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1))
                    .shadow(radius: 10)
                    .bold()
                    .foregroundColor(Color.gray)
                    .cornerRadius(10)
                TextField("RollNumber", text: $rollNumber)
                    .padding(.all)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1))
                    .shadow(radius: 10)
                    .bold()
                    .cornerRadius(10)
                    .keyboardType(.numberPad)
                    .foregroundColor(Color.gray)
                Button("Add")
                {
                    addItem()
                }
                .padding(.all)
                .background(Color.brown)
                .bold()
                .foregroundColor(.white)
                Divider()
                List{
                    ForEach(students){ student in
                        VStack{
                            Text(student.name ?? "No Name")
                                .foregroundColor(Color.gray)
                            Text("Roll Number: \(student.rollNumber)" )
                                .foregroundColor(Color.gray)
                        }
                    }.onDelete(perform: deleteItems)
                }
            }.padding(.all)
        }
    }
    
        private func addItem() {
            guard !name.isEmpty, let rollNum = Int32(rollNumber)
            else{
                print("Invalid Input")
                return
            }
                    
                let newstudent = StudentManagedObject(context: viewContext)
                newstudent.name = name
                newstudent.rollNumber = rollNum
    
                do {
                    try viewContext.save()
                    name = ""
                    rollNumber = ""
                    print("Student Added Successfully!")
                } catch {
                    print("Failed to Delete")
                }
        }
    
        private func deleteItems(offsets: IndexSet) {
            withAnimation {
                offsets.map { students[$0] }.forEach(viewContext.delete)
    
                do {
                    try viewContext.save()
                } catch {
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
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
