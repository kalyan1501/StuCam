import SwiftUI

struct ActivityView: View {
    let items: [ActivityItem]
    
    var body: some View {
        List {
            ForEach(items) { item in
                ActivityRow(item: item)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Activity")
    }
}

struct ActivityRow: View {
    let item: ActivityItem
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: item.icon)
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(item.color, in: RoundedRectangle(cornerRadius: 16))
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(item.timeAgo)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 6)
    }
}

