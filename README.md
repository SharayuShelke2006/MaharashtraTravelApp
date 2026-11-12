# 🌿 Maharashtra Travel Community App

> Discover beyond the famous destinations. Explore the hidden gems, share your experiences, and travel together.

A cross-platform travel community application built using **Flutter**, designed to help travelers explore Maharashtra beyond its popular tourist attractions.

The idea behind this project is simple: whenever we visit a new place, local people often recommend nearby destinations that aren't very popular among tourists. These places are frequently overlooked because travelers usually focus on the main attractions.

This application aims to bridge that gap by creating a community where travelers can discover popular destinations, explore lesser-known places, share travel experiences, and contribute their own hidden gems.

---

## 📌 Table of Contents

- [About the Project](#-about-the-project)
- [Motivation](#-motivation)
- [Key Features](#-key-features)
- [Application Modules](#-application-modules)
- [Technology Stack](#-technology-stack)
- [Application Architecture](#-application-architecture)
- [Firebase Integration](#-firebase-integration)
- [Third-Party Integrations](#-third-party-integrations)
- [Cross-Platform Development](#-cross-platform-development)
- [Getting Started](#-getting-started)
- [Environment Configuration](#-environment-configuration)
- [Challenges and Learnings](#-challenges-and-learnings)
- [Future Enhancements](#-future-enhancements)
- [Contributing](#-contributing)
- [Author](#-author)

---

## 🌍 About the Project

The Maharashtra Travel Community App is a Flutter-based travel discovery and blogging platform that connects travelers through shared experiences.

Instead of limiting travel discovery to famous tourist destinations, the application encourages users to explore the lesser-known places around them.

The platform currently focuses on Maharashtra and provides features for:

- Discovering popular tourist destinations.
- Exploring hidden gems contributed by travelers.
- Writing and publishing travel blogs.
- Interacting with other travelers through likes and comments.
- Saving interesting destinations for future visits.
- Checking current weather conditions.
- Viewing location information and calculating distances.

The application is designed for both **mobile and web platforms**, with a responsive interface that adapts to different screen sizes.

---

## 💡 Motivation

I love travelling, and one thing I have noticed during my trips is that local communities often know about amazing places that aren't necessarily popular tourist destinations.

Whenever I visit somewhere new, I try asking locals about nearby places worth exploring.

And guess what? Many of these recommendations turn out to be incredible hidden gems that most tourists don't even know exist!

This made me think:

**What if travelers could share these discoveries with everyone instead of keeping them limited to personal recommendations?**

That thought became the foundation of this project.

I wanted to create a community-driven platform where people could discover places through real travel experiences rather than relying only on mainstream tourist recommendations.

---

## ✨ Key Features

### 1. 🗺️ Explore Tourist Destinations

- Browse popular tourist attractions across Maharashtra.
- Explore destinations through visually appealing place cards.
- View destination details and location information.
- Search for destinations.
- Filter places based on categories.

### 2. 💎 Hidden Gems Discovery

One of the core features of this application.

- Discover lesser-known destinations.
- Explore places contributed by other travelers.
- Allow users to add new hidden gems.
- Encourage community-driven travel discovery.

### 3. ✍️ Travel Blogging

A dedicated blogging system that allows travelers to document their experiences.

Features include:

- Create and publish travel blogs.
- Add blog titles and cover images.
- Associate blogs with relevant tourist destinations.
- Categorize travel experiences.
- Rich-text editing using Flutter Quill.
- Insert images directly into blog content.
- Edit previously published blogs.
- Save blogs as drafts.
- Display published blogs in a dedicated section.

### 4. ❤️ Community Engagement

Travel is better when experiences are shared.

- Like travel blogs.
- Comment on published blogs.
- Explore content shared by other travelers.
- Interact with the travel community.

### 5. 🔖 Saved Places

- Save interesting destinations.
- Remove destinations from saved places.
- Access saved destinations through a dedicated profile section.
- Keep track of places to visit in the future.

### 6. 👤 User Profiles

Every traveler gets a personalized profile.

- Upload and update profile pictures.
- Add and edit profile cover images.
- Write and update a personal bio.
- View personal travel blogs.
- Access saved places.
- View liked blogs.
- Explore contributed hidden gems.

### 7. 🌦️ Weather Updates

Weather information is integrated into the travel experience using a Weather API.

- Retrieve current weather information.
- Help travelers understand weather conditions before visiting a destination.
- Provide useful weather context while planning trips.

### 8. 📍 Location Services and Distance Calculation

Location-based functionality is integrated using Google Maps services.

- Access geographical location information.
- Calculate distances between locations.
- Support location-aware travel discovery.
- Provide geographical context for destinations.

---

## 🛠 Technology Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform application development |
| Dart | Primary programming language |
| Firebase Authentication | User authentication |
| Cloud Firestore | Cloud database and real-time data |
| Cloudinary | Image and media uploads |
| Flutter Quill | Rich-text blog editor |
| Google Maps APIs | Maps and location-based functionality |
| Weather API | Current weather information |
| UUID | Unique identifier generation |
| GoRouter | Application navigation |
| Image Picker | Selecting images from devices |

---

## 🏗 Application Architecture

The application follows a modular Flutter project structure to keep screens, reusable widgets, models, and services organized.

An example of the project organization:

```text
lib/
│
├── core/
│   ├── routes/
│   │   └── app_router.dart
│   │
│   └── services/
│       ├── cloudinary_service.dart
│       ├── blog_service.dart
│       └── draft_service.dart
│
├── models/
│   └── blog_model.dart
│
├── screens/
│   ├── home/
│   ├── explore/
│   ├── hidden_gems/
│   ├── blogs/
│   ├── profile/
│   ├── saved_places/
│   └── my_blogs/
│
├── widgets/
│   ├── responsive_scaffold.dart
│   └── reusable_widgets.dart
│
└── main.dart
```

*The structure above is illustrative; actual folder names may differ depending on the current implementation.*

### Application Flow

1. Users authenticate through Firebase Authentication.
2. Tourist destinations and community content are retrieved from Cloud Firestore.
3. Users interact with destinations and blogs.
4. Images are uploaded to Cloudinary.
5. Blog content is managed using Flutter Quill.
6. Weather and location information are retrieved through external APIs.
7. Data is synchronized through Firebase services.

---

## 🔥 Firebase Integration

Firebase is used as the primary backend infrastructure.

### Firebase Authentication

Handles user authentication and identity management.

### Cloud Firestore

Stores application data, including:

- User profile information.
- Tourist destinations.
- Hidden gems.
- Travel blogs.
- Blog engagement information.
- Saved places.
- Draft-related information.

Firestore real-time streams are used where live updates are required.

---

## ☁️ Third-Party Integrations

### Cloudinary

Cloudinary handles image uploads and image hosting.

It is integrated to support both mobile and web uploads.

- Mobile: Image upload using file paths.
- Web: Image upload using in-memory bytes (`Uint8List`).

This approach avoids relying on `dart:io` file handling for web uploads.

### Flutter Quill

Flutter Quill provides the rich-text editing experience for travel blogs.

It supports formatted text, lists, alignment, and image embeds, allowing users to create more engaging travel stories.

### Google Maps

Used for location-based functionality and geographical distance calculations.

### Weather API

Used to retrieve current weather information to make travel planning more informative.

---

## 📱 Cross-Platform Development

One of the major goals was to develop a single Flutter codebase that works across mobile and web.

The application includes:

- Responsive layouts.
- Adaptive UI components.
- Mobile and web-compatible image uploads.
- Reusable widgets.
- Platform-aware file handling.

The interface is designed to provide a consistent experience across different screen sizes.

---

## 🚀 Getting Started

Follow these steps to run the project locally.

### Prerequisites

Make sure you have:

- Flutter SDK installed.
- Dart SDK.
- Android Studio or VS Code.
- Firebase project.
- Cloudinary account.
- Google Maps API credentials.
- Weather API credentials.

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
```

### 2. Navigate to the Project

```bash
cd YOUR_REPOSITORY
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Configure Firebase

Create a Firebase project and configure Firebase for your required platforms.

Use FlutterFire CLI if needed:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Make sure Firebase Authentication and Cloud Firestore are enabled.

### 5. Configure Environment Variables

Create a `.env` file in the project root and add your API credentials.

Example:

```env
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_UPLOAD_PRESET=your_upload_preset

WEATHER_API_KEY=your_weather_api_key
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
```

Use the exact environment variable names expected by your implementation.

**Important:** Never commit actual API secrets, private credentials, or production configuration files to a public repository.

### 6. Run the Application

For mobile:

```bash
flutter run
```

For web:

```bash
flutter run -d chrome
```

---

## 🧠 Challenges and Learnings

Building this project was a valuable learning experience, especially because it involved developing a complete application rather than just individual Flutter screens.

Some of the major challenges and learning areas included:

**1. Cross-platform compatibility**

Handling differences between mobile and web, particularly image selection and uploading, required platform-specific logic.

**2. Responsive UI development**

Designing layouts that adapt properly to mobile, tablet, and desktop screen sizes helped me understand responsive Flutter development better.

**3. Rich-text editing**

Integrating Flutter Quill and handling formatted blog content, image embeds, and previously saved content introduced me to document-based editing.

**4. Firebase data management**

Structuring Firestore data for users, blogs, places, hidden gems, and saved destinations helped me understand cloud database design and real-time data synchronization.

**5. External API integration**

Integrating weather and Google Maps services helped me understand how third-party APIs can improve the functionality of a real-world application.

**6. Scalable and maintainable code**

Organizing the project into reusable widgets, models, services, and separate screens helped me understand the importance of maintainable application architecture.

---

## 🔮 Future Enhancements

Some features I would love to introduce in future iterations:

- Personalized destination recommendations.
- AI-powered travel itinerary generation.
- Interactive maps displaying hidden gems nearby.
- Multi-day trip planning.
- Advanced destination filtering.
- Travel groups and community discussions.
- Bookmarking and sharing complete travel itineraries.
- More regional destinations beyond Maharashtra.
- Multilingual support for local travelers.

---

## 🤝 Contributing

Contributions, suggestions, and feedback are welcome!

If you have ideas for improving travel discovery or making the platform more useful for travelers, feel free to open an issue or submit a pull request.

1. Fork the repository.
2. Create a feature branch.
3. Make your changes.
4. Commit your changes.
5. Open a pull request.

---

## 👩‍💻 Author

**Sharayu Shelke**

B.Tech – Artificial Intelligence and Data Science

Interested in Flutter Development, Full Stack Development, and AI-powered applications.

- GitHub: [Your GitHub Profile](https://github.com/YOUR_USERNAME)
- LinkedIn: [Your LinkedIn Profile](https://www.linkedin.com/in/YOUR_PROFILE/)

---

## 💚 A Little Thought Behind the Project

> Every destination has a story, and sometimes the most beautiful stories are found beyond the popular tourist spots.

Built with Flutter, curiosity, and a love for travelling.

**Happy Exploring! 🌍**
