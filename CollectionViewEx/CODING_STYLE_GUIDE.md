# DBZ CollectionView iOS Coding Style Guide

> **For New iOS Developers Onboarding to This Project**
>
> This guide documents the coding conventions, patterns, and best practices used in this project. Following these guidelines ensures consistency across the codebase.

---

## Table of Contents

1. [Project Architecture](#project-architecture)
2. [Folder Structure](#folder-structure)
3. [Naming Conventions](#naming-conventions)
4. [File Organization](#file-organization)
5. [Swift Style Guidelines](#swift-style-guidelines)
6. [UIKit Patterns](#uikit-patterns)
7. [Networking Layer](#networking-layer)
8. [MVVM Architecture](#mvvm-architecture)
9. [Error Handling](#error-handling)
10. [Asynchronous Programming](#asynchronous-programming)
11. [Code Examples](#code-examples)

---

## Project Architecture

This project follows the **MVVM (Model-View-ViewModel)** architectural pattern:

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│      View       │ ◄── │   ViewModel     │ ◄── │     Model       │
│ (UIViewController)│    │ (Business Logic)│     │  (Data Struct)  │
└─────────────────┘     └─────────────────┘     └─────────────────┘
                               │
                               ▼
                        ┌─────────────────┐
                        │  NetworkManager │
                        │   (API Layer)   │
                        └─────────────────┘
```

---

## Folder Structure

Organize files by their role in the architecture:

```
CollectionViewEx/
├── Models/              # Data structures (Decodable structs)
├── ViewModels/          # Business logic and data transformation
├── Views/               # Custom UIView subclasses
├── ViewControllers/     # UIViewController subclasses
├── Networking/          # API endpoints and network manager
├── Assets.xcassets/     # Images, colors, and other assets
└── Base.lproj/          # Storyboards and localization
```

**Guidelines:**
- Place each file in its appropriate folder based on responsibility
- Keep related files together (e.g., `DBZModel.swift` and `DBZWorlds.swift` in Models)
- Custom reusable cells can live at the root level or in a `Cells/` folder

---

## Naming Conventions

### Prefix Convention

Use the **`DBZ`** prefix for project-specific classes to avoid naming conflicts and clearly identify custom types:

```swift
// ✅ Good - Uses project prefix
class DBZCharactersCollectionViewController: UIViewController
class DBZDetailView: UIView
struct DBZModel: Decodable

// ❌ Avoid - Generic names without prefix
class CharactersViewController: UIViewController
```

### Type Naming (PascalCase)

```swift
// Classes, Structs, Enums, Protocols
class DBZCharactersViewModel { }
struct Item: Decodable { }
enum NetworkingError: Error { }
protocol Networking { }
```

### Property & Method Naming (camelCase)

```swift
// Properties
var dbzCharacters = DBZModel(items: [])
let backgroundImage: UIImageView

// Methods
func getDBZCharacters() { }
func setupConstraints() { }
func downloadImage(from url: String) { }
```

### Static Identifiers

Use `description()` for cell reuse identifiers:

```swift
class DBZReusableCollectionViewCell: UICollectionViewCell {
    static let identifier = DBZReusableCollectionViewCell.description()
}
```

### Boolean Naming

Use `is`, `has`, `should` prefixes for boolean properties:

```swift
var isDestroyed: Bool
var isScrollEnabled: Bool
```

---

## File Organization

### File Header

Every Swift file includes the standard header:

```swift
//
//  FileName.swift
//  CollectionViewEx
//
//  Created by Developer Name on MM/DD/YY.
//
```

### MARK Comments

Use `// MARK: -` to organize code sections:

```swift
// MARK: - Properties

// MARK: - Configuration

// MARK: - Initialization

// MARK: - Lifecycle

// MARK: - Setup

// MARK: - Data Fetching

// MARK: - UICollectionViewDataSource
```

### Code Order in Classes

Organize class members in this order:

1. **Static properties**
2. **Instance properties**
3. **UI Components** (as lazy closures)
4. **Initializers**
5. **Lifecycle methods** (`viewDidLoad`, `viewWillAppear`, etc.)
6. **Setup methods**
7. **Action methods**
8. **Helper methods**

---

## Swift Style Guidelines

### Access Control

Use appropriate access modifiers:

```swift
// Use 'final' for classes not meant to be subclassed
final class NetworkManager: Networking { }
final class ImageCache { }

// Use 'private' for implementation details
private let session: URLSession
private let decoder: JSONDecoder

// Use 'private' for nested types that are internal
private enum Configuration {
    static let timeoutInterval: TimeInterval = 15.0
}
```

### Optionals and Guard Statements

Prefer `guard` for early returns:

```swift
// ✅ Good - Early exit with guard
func getDBZCharacters() {
    guard let url = URL(string: ApiEndpoints.characterURL) else {
        return
    }
    // Continue with valid URL
}

// ✅ Good - Unwrapping with guard let
guard let self else { return }
guard let data else { return }
guard let httpResponse = response as? HTTPURLResponse else { return }
```

### Closure Syntax

Use trailing closure syntax and shorthand arguments where clear:

```swift
// Property initialization closure
let backgroundImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "CloudImage")
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
}()

// Lazy properties
lazy var kiLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}()
```

### Enums for Type-Safe Constants

```swift
// API Endpoints
enum ApiEndpoints {
    private static let baseURL = "https://dragonball-api.com/api"
    
    enum Characters {
        static let defaultLimit = 78
        static func list(page: Int = 0, limit: Int = defaultLimit) -> String {
            "\(baseURL)/characters?page=\(page)&limit=\(limit)"
        }
    }
}

// Detail Types
enum DetailType {
    case character
    case world
}

// Error Types
enum NetworkingError: Error, LocalizedError {
    case urlError
    case serverError
    case dataError
    // ...
}
```

---

## UIKit Patterns

### Programmatic UI

All UI is created programmatically (no Interface Builder for views):

```swift
let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 125, height: 125)
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(
        DBZReusableCollectionViewCell.self,
        forCellWithReuseIdentifier: DBZReusableCollectionViewCell.identifier
    )
    return collectionView
}()
```

### Auto Layout

Always use `NSLayoutConstraint.activate()` for constraints:

```swift
func setupConstraints() {
    view.addSubview(backgroundImage)
    view.addSubview(collectionView)
    
    NSLayoutConstraint.activate([
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor),
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
}
```

**Important:** Always set `translatesAutoresizingMaskIntoConstraints = false` for views using Auto Layout.

### UICollectionView Setup

```swift
// Registration
collectionView.register(
    DBZReusableCollectionViewCell.self,
    forCellWithReuseIdentifier: DBZReusableCollectionViewCell.identifier
)

// Dequeue
let cell = collectionView.dequeueReusableCell(
    withReuseIdentifier: DBZReusableCollectionViewCell.identifier,
    for: indexPath
) as! DBZReusableCollectionViewCell
```

### Protocol Conformance in Extensions

Separate protocol conformance into extensions:

```swift
class DBZCharactersCollectionViewController: UIViewController {
    // Main class implementation
}

extension DBZCharactersCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getCharacterCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // ...
    }
}
```

### Cell Reuse

Always implement `prepareForReuse()` to reset cell state:

```swift
override func prepareForReuse() {
    super.prepareForReuse()
    dbzImageView.image = nil
    nameLabel.text = ""
}
```

---

## Networking Layer

### Protocol-Based Design

Define networking behavior through protocols:

```swift
protocol Networking {
    func getDataFromNetworkingLayer<T: Decodable>(url: URL, modelType: T.Type) async throws -> T
    func makeRequest(url: URL) -> URLRequest
    func fetchData<T: Decodable>(url: URL, modelType: T.Type, completion: @escaping ((Result<T, NetworkingError>) -> Void))
}
```

### Network Manager Structure

```swift
final class NetworkManager: Networking {
    
    // MARK: - Properties
    private let session: URLSession
    private let decoder: JSONDecoder
    private let imageCache: ImageCache
    
    // MARK: - Configuration
    private enum Configuration {
        static let timeoutInterval: TimeInterval = 15.0
        static let httpMethod = "GET"
    }
    
    // MARK: - Initialization
    init(session: URLSession = .shared, imageCache: ImageCache = .shared) {
        self.session = session
        self.imageCache = imageCache
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
}
```

### Image Caching

Use a singleton `ImageCache` with `NSCache`:

```swift
final class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSURL, UIImage>()
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
    }
    
    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    func setImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}
```

---

## MVVM Architecture

### Models

Keep models simple and focused on data representation:

```swift
struct DBZModel: Decodable {
    var items: [Item]
}

struct Item: Decodable {
    var id: Int
    var name: String
    var ki: String
    var maxKi: String
    var race: String
    var gender: String
    var description: String
    var image: String
    var affiliation: String
}
```

### ViewModels

ViewModels handle business logic and network calls:

```swift
class DBZCharactersViewModel {
    
    var dbzCharacters = DBZModel(items: [Item]())
    
    let network: NetworkManager
    
    init(network: NetworkManager = NetworkManager()) {
        self.network = network
    }
    
    func getDBZCharacters() {
        guard let url = URL(string: ApiEndpoints.characterURL) else {
            return
        }
        network.fetchData(url: url, modelType: DBZModel.self) { result in
            switch result {
            case .success(let characters):
                self.dbzCharacters = characters
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getCharacterCount() -> Int {
        dbzCharacters.items.count
    }
}
```

### Dependency Injection

Use initializer injection with default values:

```swift
init(network: NetworkManager = NetworkManager()) {
    self.network = network
}
```

---

## Error Handling

### Custom Error Types

Define errors that conform to `LocalizedError`:

```swift
enum NetworkingError: Error, LocalizedError {
    case urlError
    case serverError
    case dataError
    case parsingError
    case other
    
    var errorDescription: String? {
        switch self {
        case .urlError:
            return "Invalid URL"
        case .serverError:
            return "Server returned an error"
        case .dataError:
            return "No data received"
        case .parsingError:
            return "Failed to parse response"
        case .other:
            return "An unexpected error occurred"
        }
    }
}
```

### Result Type

Use Swift's `Result` type for completion handlers:

```swift
func fetchData<T: Decodable>(
    url: URL,
    modelType: T.Type,
    completion: @escaping ((Result<T, NetworkingError>) -> Void)
)
```

---

## Asynchronous Programming

### Async/Await (Preferred for new code)

```swift
@MainActor
func getDBZWorlds() async {
    guard let url = URL(string: ApiEndpoints.planetURL) else {
        return
    }
    do {
        let worlds = try await network.getDataFromNetworkingLayer(url: url, modelType: DBZWorlds.self)
        self.dbzWorlds = worlds
    } catch {
        print(error.localizedDescription)
    }
}
```

### Completion Handlers (Legacy support)

```swift
func fetchData<T: Decodable>(
    url: URL,
    modelType: T.Type,
    completion: @escaping ((Result<T, NetworkingError>) -> Void)
) {
    session.dataTask(with: request) { [weak self] data, response, error in
        // Handle response
    }.resume()
}
```

### Main Thread Updates

Always dispatch UI updates to the main thread:

```swift
DispatchQueue.main.async {
    self.collectionView.reloadData()
}

// Or with MainActor
@MainActor
func updateUI() {
    collectionView.reloadData()
}
```

### Weak Self in Closures

Use `[weak self]` to prevent retain cycles:

```swift
session.dataTask(with: url) { [weak self] data, response, error in
    guard let self = self else { return }
    // Use self safely
}.resume()
```

---

## Code Examples

### Creating a New ViewController

```swift
//
//  DBZNewFeatureViewController.swift
//  CollectionViewEx
//
//  Created by Your Name on MM/DD/YY.
//

import UIKit

class DBZNewFeatureViewController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel = DBZNewFeatureViewModel()
    
    // MARK: - UI Components
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CloudImage")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        viewModel.fetchData()
    }
    
    // MARK: - Setup
    
    private func setupConstraints() {
        view.addSubview(backgroundImage)
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
```

### Creating a New Model

```swift
//
//  DBZNewModel.swift
//  CollectionViewEx
//
//  Created by Your Name on MM/DD/YY.
//

import Foundation

struct DBZNewModel: Decodable {
    var items: [NewItem]
}

struct NewItem: Decodable {
    var id: Int
    var name: String
    var description: String
    var imageURL: String
}
```

### Creating a New ViewModel

```swift
//
//  DBZNewFeatureViewModel.swift
//  CollectionViewEx
//
//  Created by Your Name on MM/DD/YY.
//

import Foundation

class DBZNewFeatureViewModel {
    
    // MARK: - Properties
    
    var data = DBZNewModel(items: [])
    
    private let network: NetworkManager
    
    // MARK: - Initialization
    
    init(network: NetworkManager = NetworkManager()) {
        self.network = network
    }
    
    // MARK: - Data Fetching
    
    func fetchData() {
        guard let url = URL(string: ApiEndpoints.newEndpoint) else {
            return
        }
        
        network.fetchData(url: url, modelType: DBZNewModel.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.data = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Helpers
    
    func getItemCount() -> Int {
        data.items.count
    }
}
```

---

## Quick Reference Checklist

Before submitting code, verify:

- [ ] File header includes author and creation date
- [ ] Classes use `DBZ` prefix where appropriate
- [ ] `translatesAutoresizingMaskIntoConstraints = false` is set for Auto Layout views
- [ ] MARK comments organize code sections
- [ ] Protocol conformance is in extensions
- [ ] `[weak self]` is used in closures to prevent retain cycles
- [ ] UI updates are dispatched to main thread
- [ ] `prepareForReuse()` is implemented in custom cells
- [ ] Errors conform to `LocalizedError` with descriptions
- [ ] Guard statements handle optionals with early return
- [ ] New async code uses async/await pattern

---

## Additional Resources

- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Ray Wenderlich Swift Style Guide](https://github.com/raywenderlich/swift-style-guide)

---

*Last updated: January 2026*
