import SwiftUI
import MapKit

struct DiscoveryView: View {
    let photographer: Photographer
    @State private var searchText = ""
    @State private var isMapMode = true
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var showFilter = false
    @State private var showPhotographerCard = false
    @State private var selectedPhotographer: Photographer?
    @State private var dragOffset: CGFloat = 0
    @State private var selectedSortOption: SortOption = .proximity
    
    // User location (mock - San Francisco downtown, slightly offset from photographers)
    private let userLocation = CLLocationCoordinate2D(latitude: 37.7889, longitude: -122.4085)
    
    enum SortOption: String, CaseIterable {
        case proximity = "Proximity"
        case rating = "Rating"
        case price = "Price"
        case availability = "Availability"
        
        var icon: String {
            switch self {
            case .proximity: return "location.fill"
            case .rating: return "star.fill"
            case .price: return "dollarsign.circle"
            case .availability: return "calendar"
            }
        }
    }
    
    // All photographers on the map
    private let allPhotographers: [Photographer] = [
        .sharatPhotography,
        .p3Productions,
        .lensAndLight
    ]
    
    private var sortedPhotographers: [Photographer] {
        var photographers = [photographer] + allPhotographers
        
        switch selectedSortOption {
        case .proximity:
            return photographers.sorted { getDistance($0) < getDistance($1) }
        case .rating:
            return photographers.sorted { $0.rating > $1.rating }
        case .price:
            return photographers.sorted { extractPrice($0.rate) < extractPrice($1.rate) }
        case .availability:
            return photographers.sorted { $0.availability.count > $1.availability.count }
        }
    }
    
    private func getDistance(_ photographer: Photographer) -> Double {
        let distances: [String: Double] = [
            "Sophia Carter": 0.8,
            "Sharat Photography": 0.5,
            "P3 Productions": 1.2,
            "Lens & Light Studio": 2.5
        ]
        return distances[photographer.name] ?? 3.0
    }
    
    private func extractPrice(_ rateString: String) -> Int {
        let digits = rateString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return Int(digits) ?? 0
    }
    
    var body: some View {
        ZStack {
            if isMapMode {
                mapView
            } else {
                listView
            }
            
            VStack(spacing: 0) {
                searchBar
                    .padding(.horizontal)
                    .padding(.top)
                
                viewToggle
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                Spacer()
            }
            
            // GPS Button - Bottom Right
            if isMapMode {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                cameraPosition = .region(MKCoordinateRegion(
                                    center: userLocation,
                                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                                ))
                            }
                        } label: {
                            Image(systemName: "location.fill")
                                .font(.title3)
                                .foregroundStyle(.blue)
                                .frame(width: 50, height: 50)
                                .background(.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 2)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20) // Just above tab bar
                    }
                }
            }
            
            // Photographer card sheet
            if showPhotographerCard, let selectedPhotographer = selectedPhotographer {
                VStack {
                    Spacer()
                    DiscoveryCard(photographer: selectedPhotographer)
                        .offset(y: dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if value.translation.height > 0 {
                                        dragOffset = value.translation.height
                                    }
                                }
                                .onEnded { value in
                                    if value.translation.height > 100 {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            showPhotographerCard = false
                                            dragOffset = 0
                                        }
                                    } else {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            dragOffset = 0
                                        }
                                    }
                                }
                        )
                        .transition(.move(edge: .bottom))
                        .padding()
                }
                .background(
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showPhotographerCard = false
                                dragOffset = 0
                            }
                        }
                )
            }
        }
        .sheet(isPresented: $showFilter) {
            FilterView()
        }
    }
    
    private var mapView: some View {
        Map(position: $cameraPosition) {
                // User Location Pin
                Annotation("Your Location", coordinate: userLocation) {
                    ZStack {
                        Circle()
                            .fill(.blue.opacity(0.2))
                            .frame(width: 40, height: 40)
                        Circle()
                            .fill(.blue)
                            .frame(width: 16, height: 16)
                            .overlay(
                                Circle()
                                    .stroke(.white, lineWidth: 3)
                            )
                    }
                }
                
                // Main photographer
                Annotation(photographer.name, coordinate: photographer.location) {
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedPhotographer = photographer
                            showPhotographerCard = true
                        }
                    } label: {
                        VStack {
                            Image(systemName: "camera.fill")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(Circle().fill(.blue))
                            Text("$50/hr")
                                .font(.caption2.bold())
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Capsule().fill(.white))
                                .shadow(radius: 2)
                        }
                    }
                }
                
                // Additional photographers
                ForEach(allPhotographers) { photographerItem in
                    Annotation(photographerItem.name, coordinate: photographerItem.location) {
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedPhotographer = photographerItem
                                showPhotographerCard = true
                            }
                        } label: {
                            VStack {
                                Image(systemName: "camera.fill")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .padding(8)
                                    .background(Circle().fill(.blue))
                                Text(photographerItem.rate)
                                    .font(.caption2.bold())
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Capsule().fill(.white))
                                    .shadow(radius: 2)
                            }
                        }
                    }
                }
            }
            .mapControls {
                MapCompass()
                MapPitchToggle()
            }
            .onAppear {
                // Center map on San Francisco to show all photographers
                cameraPosition = .region(
                    MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094),
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                )
            }
            .ignoresSafeArea()
    }
    
    private var listView: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Sort Options
                sortOptionsBar
                
                LazyVStack(spacing: 16) {
                    // Sorted photographers
                    ForEach(sortedPhotographers) { photographerItem in
                        PhotographerListCard(photographer: photographerItem, distance: getDistance(photographerItem)) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedPhotographer = photographerItem
                                showPhotographerCard = true
                            }
                        }
                    }
                }
                .padding()
            }
            .padding(.top, 110) // Space for search bar and toggle
        }
        .background(Color(red: 0.95, green: 0.95, blue: 0.97))
    }
    
    private var sortOptionsBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedSortOption = option
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: option.icon)
                                .font(.caption)
                            Text(option.rawValue)
                                .font(.subheadline)
                        }
                        .foregroundColor(selectedSortOption == option ? .white : .primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedSortOption == option ? Color.blue : Color.white)
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .background(Color(red: 0.95, green: 0.95, blue: 0.97))
    }
    
    private var viewToggle: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isMapMode = true
                }
            } label: {
                Text("Map")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(isMapMode ? .white : .primary)
                    .frame(width: 60)
                    .padding(.vertical, 6)
            }
            
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isMapMode = false
                }
            } label: {
                Text("List")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(isMapMode ? .primary : .white)
                    .frame(width: 60)
                    .padding(.vertical, 6)
            }
        }
        .background {
            GeometryReader { geometry in
                Capsule()
                    .fill(Color.blue)
                    .frame(width: geometry.size.width / 2)
                    .offset(x: isMapMode ? 0 : geometry.size.width / 2)
            }
        }
        .background(.thickMaterial)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 5)
        .frame(width: 120)
    }
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search by photographer, location, style", text: $searchText)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(.thickMaterial, in: Capsule())
            .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 5)
            
            Button {
                showFilter = true
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .padding(12)
                    .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 5)
            }
        }
    }
}

private struct DiscoveryCard: View {
    let photographer: Photographer
    @State private var showFullProfile = false
    @State private var showBookingForm = false
    
    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 40, height: 4)
                .padding(.top, 8)
            
            HStack(alignment: .top, spacing: 16) {
                Group {
                    if ["sharat", "p3", "lens", "sophia", "kalyan", "jessica"].contains(photographer.avatar.lowercased()) {
                        Image(photographer.avatar)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(systemName: photographer.avatar)
                            .font(.system(size: 44))
                    }
                }
                .frame(width: 70, height: 70)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(photographer.name)
                        .font(.title3.bold())
                    Text(photographer.specialties)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text("\(photographer.rating, specifier: "%.1f")")
                            .bold()
                        Text("(\(photographer.reviewsCount) reviews)")
                            .foregroundStyle(.secondary)
                    }
                    Text(photographer.rate)
                        .font(.title3.bold())
                        .padding(.top, 8)
                }
                Spacer()
            }
            
            HStack(spacing: 12) {
                Button("View Profile") {
                    showFullProfile = true
                }
                .buttonStyle(PillButtonStyle(background: .blue))
                
                Button("Book") {
                    showBookingForm = true
                }
                .buttonStyle(PillButtonStyle(background: .black))
            }
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 32))
        .shadow(color: .black.opacity(0.2), radius: 40, x: 0, y: 10)
        .fullScreenCover(isPresented: $showFullProfile) {
            PhotographerPublicProfileView(photographer: photographer)
        }
        .fullScreenCover(isPresented: $showBookingForm) {
            BookingFormView(photographer: photographer)
        }
    }
}

private struct PhotographerListCard: View {
    let photographer: Photographer
    let distance: Double
    let action: () -> Void
    @State private var showFullProfile = false
    
    var body: some View {
        Button {
            showFullProfile = true
        } label: {
            HStack(spacing: 16) {
                Group {
                    if ["sharat", "p3", "lens", "sophia", "kalyan", "jessica"].contains(photographer.avatar.lowercased()) {
                        Image(photographer.avatar)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(systemName: photographer.avatar)
                            .font(.system(size: 36))
                    }
                }
                .frame(width: 80, height: 80)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(photographer.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        Text(photographer.rate)
                            .font(.headline)
                            .foregroundStyle(.blue)
                    }
                    
                    Text(photographer.specialties)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundStyle(.yellow)
                        Text(String(format: "%.1f", photographer.rating))
                            .font(.subheadline.bold())
                            .foregroundStyle(.primary)
                        Text("(\(photographer.reviewsCount))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text(String(format: "%.1f mi away", distance))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 2)
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(.white, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .fullScreenCover(isPresented: $showFullProfile) {
            PhotographerPublicProfileView(photographer: photographer)
        }
    }
}
