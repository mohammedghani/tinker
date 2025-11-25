import SwiftUI
import UIKit

struct FoodDetailView: View {
    let entry: FoodEntry

    var body: some View {
        ScrollView {
            VStack(alignment: .trailing, spacing: 12) {
                if let data = entry.photoData, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(16)
                }
                Text(entry.wrappedTitle)
                    .font(.title2).bold()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                if let notes = entry.notes, !notes.isEmpty {
                    Text(notes)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                macroRow(label: "السعرات", value: entry.calories)
                macroRow(label: "بروتين", value: entry.protein)
                macroRow(label: "كربوهيدرات", value: entry.carbs)
                macroRow(label: "دهون", value: entry.fat)
            }
            .padding()
        }
        .navigationTitle("تفاصيل الوجبة")
    }

    private func macroRow(label: String, value: Double) -> some View {
        HStack {
            Text("\(Int(value))")
            Spacer()
            Text(label)
        }
    }
}
