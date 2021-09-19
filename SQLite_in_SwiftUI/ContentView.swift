//
//  ContentView.swift
//  SQLite_in_SwiftUI
//
//  Created by TonkaIn Mac Mini 2014 on 10/09/2021.
//

import SwiftUI

struct ContentView: View {
    
    // array of user models
    @State var userModels: [UserModel] = []
    
    // check if user is selected for edit
    @State var userSelected: Bool = false
     
    // id of selected user to edit or delete
    @State var selectedUserId: Int64 = 0
    
    var body: some View {
        // create navigation view
        NavigationView {
         
            VStack {
         
                // create link to add user
                HStack {
                    Spacer()
                    NavigationLink (destination: AddUserView(), label: {
                        Text("Add user")
                    })
                }
                
                // navigation link to go to edit user view
                NavigationLink (destination: EditUserView(id: self.$selectedUserId), isActive: self.$userSelected) {
                    EmptyView()
                }
         
                // create list view to show all users
                List (self.userModels) { (model) in
                 
                    // show name, email and age horizontally
                    HStack {
                        Text(model.name)
                        Spacer()
                        Text(model.email)
                        Spacer()
                        Text("\(model.age)")
                        Spacer()
                 
                        // button to edit user
                        Button(action: {
                            self.selectedUserId = model.id
                            self.userSelected = true
                        }, label: {
                            Text("Edit")
                                .foregroundColor(Color.blue)
                            })
                            // by default, buttons are full width.
                            // to prevent this, use the following
                            .buttonStyle(PlainButtonStyle())
                        
                        // button to delete user
                                Button(action: {
                         
                                    // create db manager instance
                                    let dbManager: DB_Manager = DB_Manager()
                         
                                    // call delete function
                                    dbManager.deleteUser(idValue: model.id)
                         
                                    // refresh the user models array
                                    self.userModels = dbManager.getUsers()
                                }, label: {
                                    Text("Delete")
                                        .foregroundColor(Color.red)
                                })// by default, buttons are full width.
                                // to prevent this, use the following
                                .buttonStyle(PlainButtonStyle())
                    }

                }// load data in user models array
                .onAppear(perform: {
                    self.userModels = DB_Manager().getUsers()
                })
            }.padding()
            .navigationBarTitle("SQLite")
        }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
