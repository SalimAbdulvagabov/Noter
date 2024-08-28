//
//  NouterWidget.swift
//  NouterWidget
//
//  Created by Салим Абдулвагабов on 15.12.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import SwiftUI

struct NouterWidgetEntryView: View {
    var entry: NouterWidgetProvider.Entry

    var body: some View {
        let text = (entry.note?.text ?? entry.note?.name ?? "Здесь могла быть гениаоьная мысль.").replacingOccurrences(of: "\n", with: " ", options: .regularExpression)
        let deeplink = URL(string: "noterapp://\(entry.note?.id ?? "")")

        ZStack(alignment: .leading) {
            Color("WidgetBackground")
            HStack(alignment: .center, spacing: 10) {
                ExDivider()
                Text(text)
                    .foregroundColor(Color("Text"))
                    .font(.custom("Inter-Medium", size: 18))
                    .lineSpacing(1.07)
                    .multilineTextAlignment(.leading)
                    .lineLimit(5)
            }.padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 20))
                .fixedSize(horizontal: false, vertical: true)
        }.widgetURL(deeplink)

    }
}

struct ExDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color("Blue"))
            .frame(width: 3)
            .cornerRadius(2)
            .edgesIgnoringSafeArea(.horizontal)
    }
}
