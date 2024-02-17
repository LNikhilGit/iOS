//
//  SchoolInfoDetailView.swift
//  NYCSchoolsApp
//
//  Created by Nikhil Lalam on 17/02/24.
//

import SwiftUI

struct SchoolDetailView: View {
    
    var school: SchoolInfo
    
    var body: some View {
        VStack(alignment: .leading) {
            //Text(school.dbn)
            Text(school.name)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Text(school.overview)
            Spacer()
        }
        .padding()
        
    }
}

#Preview {
    SchoolDetailView(school: SchoolInfo(dbn: "02M2601"
                                            , name: "Liberation Diploma Plus High School"
                                            , boro: "K"
                                            , overview: "Overview"
                                            , phoneNumber: "987654321"
                                               , email: "example@gmail.com"
                                               , website: "https://anyurl2.com"
                                               , totalStudents: "60"
                                               , attendanceRate: "50"
                                               , latitude: "1235.01"
                                               , longitude: "123.02"
                                               , borough: "BROOKLYN"))
}
