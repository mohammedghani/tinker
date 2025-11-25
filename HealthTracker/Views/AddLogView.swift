import SwiftUI

struct AddLogView: View {
    @StateObject private var foodVM = FoodViewModel()
    @StateObject private var drinkVM = DrinkViewModel()
    @StateObject private var sleepVM = SleepViewModel()
    @StateObject private var bowelVM = BowelViewModel()
    @Environment(\.managedObjectContext) private var context
    @State private var showPhotoPicker = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    FoodForm
                    DrinkForm
                    SleepForm
                    BowelForm
                }
                .padding()
            }
            .navigationTitle("الإدخال السريع")
        }
        .sheet(isPresented: $showPhotoPicker) {
            PhotoPickerView(imageData: $foodVM.photoData)
        }
    }

    private var FoodForm: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text("تسجيل وجبة")
                .font(.title3).bold()
                .frame(maxWidth: .infinity, alignment: .trailing)
            TextField("اسم الوجبة", text: $foodVM.title)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
                .onChange(of: foodVM.title) { _ in foodVM.estimateFromTitle() }
            TextField("وصف / ملاحظات إضافية", text: $foodVM.notes, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
            HStack {
                Spacer()
                Button("إضافة صورة") { showPhotoPicker = true }
            }
            macroFields
            Button(action: { foodVM.save(context: context) }) {
                Text("حفظ الوجبة")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private var macroFields: some View {
        VStack(alignment: .trailing, spacing: 8) {
            HStack {
                TextField("السعرات (ك.س)", value: $foodVM.calories, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.trailing)
                Text("سعرات")
            }
            HStack {
                TextField("بروتين (غ)", value: $foodVM.protein, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.trailing)
                Text("بروتين")
            }
            HStack {
                TextField("كربوهيدرات (غ)", value: $foodVM.carbs, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.trailing)
                Text("كربوهيدرات")
            }
            HStack {
                TextField("دهون (غ)", value: $foodVM.fat, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.trailing)
                Text("دهون")
            }
        }
    }

    private var DrinkForm: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text("تسجيل مشروب")
                .font(.title3).bold()
                .frame(maxWidth: .infinity, alignment: .trailing)
            Picker("نوع المشروب", selection: $drinkVM.type) {
                ForEach(["ماء", "قهوة", "شاي", "مشروب طاقة", "مشروب غازي"], id: \.self) { type in
                    Text(type).tag(type)
                }
            }
            .pickerStyle(.segmented)
            TextField("الكمية (مل)", text: $drinkVM.amount)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
            HStack {
                VStack(alignment: .trailing) {
                    Text("الكافيين المقدر: \(Int(drinkVM.caffeine)) ملغ")
                    Text("السعرات المقدرة: \(Int(drinkVM.calories))")
                }
                Spacer()
            }
            Button(action: { drinkVM.save(context: context) }) {
                Text("حفظ المشروب")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        .onChange(of: drinkVM.type) { _ in drinkVM.updateEstimates() }
        .onChange(of: drinkVM.amount) { _ in drinkVM.updateEstimates() }
    }

    private var SleepForm: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text("تسجيل نوم")
                .font(.title3).bold()
                .frame(maxWidth: .infinity, alignment: .trailing)
            DatePicker("البداية", selection: $sleepVM.startDate, displayedComponents: [.date, .hourAndMinute])
                .labelsHidden()
            DatePicker("النهاية", selection: $sleepVM.endDate, displayedComponents: [.date, .hourAndMinute])
                .labelsHidden()
            TextField("المدة (ساعات)", text: $sleepVM.duration)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
            Button(action: { sleepVM.save(context: context) }) {
                Text("حفظ النوم")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        .onChange(of: sleepVM.endDate) { _ in sleepVM.calculateDuration() }
        .onChange(of: sleepVM.startDate) { _ in sleepVM.calculateDuration() }
    }

    private var BowelForm: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text("تسجيل حركة أمعاء")
                .font(.title3).bold()
                .frame(maxWidth: .infinity, alignment: .trailing)
            DatePicker("التاريخ", selection: $bowelVM.date, displayedComponents: [.date, .hourAndMinute])
                .labelsHidden()
            Picker("نوع البراز", selection: $bowelVM.bristolType) {
                ForEach(1...7, id: \.self) { type in
                    Text("نوع \(type)").tag(type)
                }
            }
            .pickerStyle(.segmented)
            TextField("ملاحظات (اختياري)", text: $bowelVM.notes, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
            Stepper(value: $bowelVM.pain, in: 0...10) {
                Text("مستوى الألم: \(bowelVM.pain)")
            }
            Button(action: { bowelVM.save(context: context) }) {
                Text("حفظ الحركة")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct AddLogView_Previews: PreviewProvider {
    static var previews: some View {
        AddLogView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
