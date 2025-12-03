# J‑Station 🎧🇯🇵

**Stream Japanese radio stations and podcasts with background playback**

J‑Station is a feature‑rich Flutter MVP for discovering and playing Japanese radio stations and podcasts. Built with clean architecture, Riverpod state management, and robust background audio support using `audio_service` and `just_audio`.

---

## ✨ Features

- 🔴 **Live Japanese Radio Stations** – Browse and stream 50+ stations via Radio Browser API  
- 🎙 **Japanese Podcasts** – Discover popular podcasts from iTunes Search API  
- 📻 **RSS Episode Parsing** – View and play the latest episodes from podcast feeds using `webfeed_plus`  
- 🔊 **Background Audio Playback** – Robust playback with lock‑screen and notification controls  
- 📱 **Mini & Full Players** – Quick control mini player + detailed full player screen  
- 🎨 **Clean UI** – Minimal, intuitive interface with tab navigation  
- 💰 **Ad Integration Ready** – AdMob banner placeholders for future monetization  

---

## 🛠 Tech Stack

| Component | Technology |
|-----------|------------|
| Framework | Flutter (Dart, latest stable) |
| State Management | Riverpod 3.0+ |
| Audio Playback | `just_audio` + `audio_service` |
| Networking | `http` |
| Feed Parsing | `webfeed_plus` |
| Monetization | `google_mobile_ads` |

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** (latest stable version)  
- **Android SDK** (API 35+, required for Google Play)  
- **Android Studio** or **VS Code** with Flutter/Dart plugins  
- **Git** for version control  

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/j-station.git
   cd j-station
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Android (for signed builds):**
   - Create `android/key.properties` (for release signing):
     ```properties
     storePassword=YOUR_STORE_PASSWORD
     keyPassword=YOUR_KEY_PASSWORD
     keyAlias=upload
     storeFile=../jstation-upload-keystore.jks
     ```
   - Update package name in `android/app/build.gradle`:
     ```gradle
     applicationId = "com.yourname.jstation"
     ```

4. **Configure AdMob (optional):**
   - Add your AdMob App ID in `android/app/src/main/AndroidManifest.xml`:
     ```xml
     <meta-data
         android:name="com.google.android.gms.ads.APPLICATION_ID"
         android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy" />
     ```

5. **Run the app:**
   ```bash
   flutter run
   ```

---

## 📂 Project Structure

```
j-station/
├── lib/
│   ├── main.dart              # App entry point & navigation
│   ├── services/
│   │   ├── audio_handler.dart # Audio service handler for background playback
│   │   ├── api_service.dart   # API calls (Radio Browser, iTunes)
│   │   └── models.dart        # Data models (Station, Podcast, Episode)
│   ├── providers/             # Riverpod state providers
│   ├── screens/
│   │   ├── home_page.dart
│   │   ├── full_player_screen.dart
│   ├── widgets/
│   │   ├── mini_player.dart
│   │   ├── radio_list.dart
│   │   └── podcast_grid.dart
│   └── constants/
├── android/                   # Android-specific configuration
├── pubspec.yaml               # Project dependencies
├── README.md                  # This file
└── LICENSE                    # MIT License
```

---

## ⚙️ Configuration

### Audio Service Setup
- Background playback is handled by `AudioHandler` from `audio_service`
- Connect `just_audio` to manage playback state, metadata updates, and notification controls
- Permissions (`INTERNET`, `WAKE_LOCK`, `FOREGROUND_SERVICE`) are set in `AndroidManifest.xml`

### API Configuration
- **Radio Stations:** Fetched from Radio Browser API endpoint (Japan)
  ```
  https://de1.api.radio-browser.info/json/stations/bycountrycodeexact/JP
  ```
- **Podcasts:** Fetched from iTunes Search API
  ```
  https://itunes.apple.com/search?term=podcast&country=JP&media=podcast&limit=50
  ```
- **Podcast Episodes:** RSS feeds are parsed using `webfeed_plus`

### Monetization
- Banner ad placeholders are included on the radio list and full player screen
- Replace test Ad Unit IDs with your own AdMob IDs before production release

---

## 📋 Building for Release

### 1. Generate a signed keystore (one-time)
```bash
keytool -genkey -v -keystore jstation-upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### 2. Build a signed Android App Bundle
```bash
flutter clean
flutter pub get
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app.aab`

### 3. Upload to Google Play Console
- Create a new release in Play Console
- Upload the `.aab` file
- Fill out store listing (description, screenshots, icon, etc.)
- Complete data safety form
- Submit for review

---

## 🔒 Privacy & Data Safety

- **No user accounts required** – J‑Station does not request or store login credentials
- **Minimal data collection** – Only AdMob SDK collects device identifiers for ad serving
- **Privacy policy** – Hosted on your domain; link provided in Play Console listing
- **User data deletion** – Contact email in privacy policy for data deletion requests

See `PRIVACY_POLICY.md` for full details.

---

## 🗺️ Roadmap

- [x] Live radio streaming with background playback
- [x] Podcast discovery and RSS parsing
- [x] Mini & full player UI
- [x] AdMob integration
- [ ] iOS support
- [ ] Favorites / bookmarked stations & episodes
- [ ] Offline / download playback
- [ ] Search and filtering
- [ ] Dark mode refinements
- [ ] Notifications for new episodes

---

## 🐛 Troubleshooting

**Background audio not working?**
- Ensure `android/app/src/main/AndroidManifest.xml` includes `FOREGROUND_SERVICE` and `FOREGROUND_SERVICE_MEDIA_PLAYBACK` permissions
- Test on a real device; emulators may have limited audio support

**API calls failing?**
- Check internet connection and HTTPS endpoints
- Verify that `http` package is properly configured in `pubspec.yaml`

**AdMob test ads not showing?**
- Use test Ad Unit IDs during development
- Ensure `MobileAds.instance.initialize()` is called in `main()`
- Check AdMob console for any app verification issues

---

## 📝 License

This project is licensed under the **MIT License** – see the [LICENSE](LICENSE) file for details.

---

## ⚖️ Disclaimer

- Radio streams and podcast content are provided by third‑party services and may change or become unavailable at any time
- Respect copyright and terms of service for all content providers
- This is an unofficial app; J‑Station is not affiliated with any radio station or podcast provider

---

## 🤝 Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/YourFeature`)
3. Commit your changes (`git commit -m "Add YourFeature"`)
4. Push to the branch (`git push origin feature/YourFeature`)
5. Open a Pull Request

---

## 📞 Support

For questions, issues, or suggestions:
- Open an **Issue** on GitHub
- Email: [spawner.dev@gmail.com]
- Visit: [https://vedantdalvi.in]

---

## 🙏 Acknowledgments

- [Radio Browser API](https://www.radio-browser.info/) for radio station data
- [iTunes Search API](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/) for podcast data
- [Flutter](https://flutter.dev) and the amazing open-source community

---

**Enjoy streaming Japanese radio and podcasts! 🎧🇯🇵**
