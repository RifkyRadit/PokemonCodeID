# CODE.ID Technical Test

Ini adalah proyek technical test untuk CODE.ID menggunakan **Swift** dan **UIKit**. Aplikasi ini menampilkan daftar Pokémon, mencari Pokémon, dan melihat detail kemampuan Pokémon. Aplikasi ini menggunakan arsitektur **MVVM**.

## Fitur
- Login
- Register
- Menampilkan list nama Pokémon
- Mencari Pokémon berdasarkan nama
- Melihat detail Pokémon (nama dan ability)
- Menamplikan list nama Pokémon ketika offline (jika sudah ada data di local database)

## Teknologi
- **Swift**
- **UIKit**
- Menggunakan API: [PokéAPI](https://pokeapi.co)

## Library
- Alamofire
- RxSwift
- KingFisher
- MBProgressHUD
- XLPagerTabStrip
- Realm Local Database

## Referensi Design
- [Login Mobile App – Figma](https://www.figma.com/design/wlpAYGCHZVz693oWZhRQlZ/Login-Mobile-App--Community-?node-id=0-1&t=fsxQyJGGj8FrNwyd-0)  
- [Empty States and Illustrations – Figma](https://www.figma.com/design/NHKLy6DMN5tB09VN8mypxu/Empty-States-and-Illustrations--Community-?node-id=22-331&t=XHbCxxOGfK8nEUPO-0)  
- [Login Screen Mobile App UI – Figma](https://www.figma.com/design/JsBFtP77eDdh9McMQOPnSl/18-Login-Screen-Mobile-App-UI--Community-?node-id=11-1831&t=pVLyByggbxYyhnap-0)  

## 📂 Struktur Folder

```bash
PokemonCodeid/
├── Core/                 
│   ├── Network/          # Networking layer
│   ├── MainTab/          # Tab bar & navigasi utama
│   └── Helper/           # Helper functions & utilities
│       ├── Extension/
│       ├── State/
│       └── Utility/
├── Views/                # Reusable views
│   └── TextField/
├── Modules/              # Fitur utama aplikasi
│   ├── Detail/
│   │   ├── Model/
│   │   ├── Repository/
│   │   ├── UseCase/
│   │   ├── ViewModel/
│   │   └── View/
│   │       └── Cell/
│   ├── Profile/
│   ├── Homepage/
│   ├── Register/
│   └── Login/
├── AppDelegate.swift
├── SceneDelegate.swift
├── Assets.xcassets       # Asset (icon, images, colors)
├── LaunchScreen.storyboard
├── Info.plist
└── Podfile               # Dependencies project
