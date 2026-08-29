# Help A Prisoner Mobile

A Flutter mobile application dedicated to supporting the rehabilitation, education, and opportunity of prisoners through community-driven campaigns. 

This app connects donors with active campaigns, tracks the impact of the ministry, and provides a seamless donation experience.

## 🚀 Features

- **Home Dashboard:** View featured campaigns, active campaigns, and real-time impact statistics.
- **Campaign Management:** Browse detailed campaign information and donate directly.
- **Powerful Branding:** Integrated logos for Help A Prisoner, Golden Heart Foundation, and Dominion City Prison Ministry.
- **Impact Tracking:** View total raised funds and the number of people supported, trained, and facilities impacted.
- **Secure Payments:** Built-in integration with Paystack for secure, reliable transactions.

## 🛠️ Tech Stack

- **Framework:** Flutter (Dart)
- **State Management:** flutter_riverpod
- **Payment Gateway:** Paystack 
- **Platforms:** Android, iOS, Web, Linux, macOS, Windows

## 📂 Project Structure

```text
mobile/ (Flutter App)
├── assets/           # Local assets (Logos, Images)
├── lib/              # Main source code
│   ├── models/       # Data models (Campaigns, Impact Stats)
│   ├── widgets/      # Reusable UI components
│   ├── screens/      # App screens
│   └── ...
├── test/             # Unit and widget tests
├── pubspec.yaml      # Dependencies and assets config
└── README.md         # This file

🔧 Getting Started
Prerequisites
Flutter SDK installed on your machine

An editor (VS Code, Android Studio, etc.)

A Paystack account and API keys (for live donations)

Installation
Clone the repository:

bash
git clone https://github.com/Ebeli1/help-a-prisoner.git
cd help-a-prisoner/mobile
Install dependencies:

bash
flutter pub get
Configure Paystack:
The web build includes the configured Paystack test public key. You can override it at build or run time.

For a production build or mobile setup, ensure your Paystack API keys are correctly set in your environment variables or config files.

Run the app:

bash
flutter run
🖼️ Changing Images & Assets
To change any existing placeholder images or logos:

Place your new image files in the assets/logos/ or assets/images/ directories.

Open pubspec.yaml and ensure your new assets are declared under flutter: assets:.

Update the Image.asset() paths in the corresponding Dart files (e.g., lib/screens/home_screen.dart).

🤝 Contributing
Contributions are welcome! If you'd like to improve the app or add new features, please fork the repository and submit a pull request.

📄 License
This project is proprietary and owned by Dominion City Prison Ministry.
