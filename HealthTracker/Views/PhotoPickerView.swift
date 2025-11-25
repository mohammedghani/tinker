import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @Binding var imageData: Data?
    @State private var pickerItem: PhotosPickerItem?

    var body: some View {
        PhotosPicker(selection: $pickerItem, matching: .images, photoLibrary: .shared()) {
            Text("اختيار صورة")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onChange(of: pickerItem) { newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self) {
                    await MainActor.run { imageData = data }
                }
            }
        }
    }
}
