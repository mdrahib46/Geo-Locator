# Google Maps Geolocation Tracker

This Flutter project is a **Google Maps Geolocation Tracker** that demonstrates real-time location tracking and mapping using the **Google Maps API**, **Geolocator** package, and Flutter's widget tree. It dynamically displays the user's current location on the map with an interactive polyline path.

---

## 🚀 Features

1. **Google Map Integration**:
   - Shows a Google Map centered at an initial location.
   - Satellite view enabled by default for better visualization.

2. **Real-Time Location Tracking**:
   - Updates user's current location in real-time on the map.
   - Displays a marker indicating the current position.
   - Continuously plots a polyline to track movement.

3. **Interactive Markers**:
   - The current location marker displays latitude and longitude details in an **info window**.
   - Marker can be repositioned by dragging (customizable behavior).

4. **PolyLine Visualization**:
   - Draws a connected path (polyline) based on movement.

5. **User-Friendly Controls**:
   - Floating Action Button to center the map on the current location.
   - Graceful handling of location permissions and GPS settings.

---

## 📸 Screenshots
![WhatsApp Image 2024-12-09 at 22 41 35_39864e77](https://github.com/user-attachments/assets/1520f542-6058-42e6-977b-939c0e79f5a7)
![WhatsApp Image 2024-12-09 at 22 41 35_bdcdbe63](https://github.com/user-attachments/assets/ab498f04-160c-45aa-956b-34a700e01c16)
![WhatsApp Image 2024-12-09 at 22 41 35_5faf3fc5](https://github.com/user-attachments/assets/61f82978-9d17-4944-8c35-6e0ac750956a)


---

## 🛠️ Installation Guide

### Prerequisites
- Flutter installed on your system. [Get Flutter](https://flutter.dev/docs/get-started/install)
- Android/iOS emulator or a physical device.
- Google Maps API key. [Generate API Key](https://developers.google.com/maps/gmp-get-started)

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo-url/google-maps-geolocation-tracker.git
   cd google-maps-geolocation-tracker
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Add your Google Maps API Key:
   - Open `android/app/src/main/AndroidManifest.xml`.
   - Replace `<YOUR_API_KEY>` with your actual API key in:
     ```xml
     <meta-data
         android:name="com.google.android.geo.API_KEY"
         android:value="YOUR_API_KEY"/>
     ```
4. Run the app:
   ```bash
   flutter run
   ```

---

## 🧩 How It Works

1. **Initialization**:
   - The app requests location permissions on startup.
   - If denied, prompts are shown to enable permissions or settings.

2. **Real-Time Updates**:
   - Listens for position updates using `Geolocator.getPositionStream`.
   - Updates map markers and polyline path dynamically.

3. **Interactive Map**:
   - Users can explore the map or tap the FAB to recenter on their current location.

---

## 🔧 Key Code Components

### Location Tracking
```dart
Geolocator.getPositionStream(
  locationSettings: LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
  ),
).listen((position) {
  // Update position and polyline
});
```

### Dynamic Polyline
```dart
polyLines.add(
  Polyline(
    polylineId: PolylineId('tracking-polyline'),
    points: polylineCoordinates,
    color: Colors.blue,
    width: 6,
  ),
);
```

### Marker Info Window
```dart
Marker(
  markerId: MarkerId('user-marker'),
  position: LatLng(currentPosition.latitude, currentPosition.longitude),
  infoWindow: InfoWindow(
    title: 'My Current Location',
    snippet: 'Lat: ${currentPosition.latitude}, Lng: ${currentPosition.longitude}',
  ),
);
```

---

## 📦 Packages Used

- **[google_maps_flutter](https://pub.dev/packages/google_maps_flutter)**: For Google Map integration.
- **[geolocator](https://pub.dev/packages/geolocator)**: For location services and permission handling.

---

## 🌟 Future Improvements

- Add user-friendly animations for map movement.
- Implement offline mode with cached maps.
- Enable more marker customization and path styling.

---

## 🙌 Contribution

Feel free to fork this repository and submit pull requests. For major changes, please open an issue first to discuss what you would like to change.

---

Enjoy tracking with **Google Maps Geolocation Tracker**! 🚗📍
