//
//  URLImage.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 04.03.2021.
//

import Foundation
import SwiftUI
import Combine

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set}
}

struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()

    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
    }
}

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self]}
        set { self[ImageCacheKey.self] = newValue }
    }
}

class RemoteImage: ObservableObject {
    private var cancellable: AnyCancellable?
    private var cache: ImageCache?
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    @Published var loadingState: LoadingState = .initial
    let url: URL?
    enum LoadingState {
        case initial
        case inProgress
        case success(_ image: Image)
        case failure
    }
    
    init(url: URL?, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    func load() {
        loadingState = .inProgress
        guard let url = url else {
            loadingState = .success(Image("news"))
            return
        }
        
        if let uiImage = cache?[url] {
            loadingState = .success(Image(uiImage: uiImage))
            return
        }
        cancellable = URLSession(configuration: .default)
            .dataTaskPublisher(for: url)
            .subscribe(on: Self.imageProcessingQueue)
            .map {
                guard let value = UIImage(data: $0.data) else {
                    return .failure
                }
                self.cache(value)
                return .success(Image(uiImage: value))
            }
            .catch { _ in
                Just(.failure)
            }
            .receive(on: RunLoop.main)
            .assign(to: \.loadingState, on: self)
    }
    
    private func cache(_ image: UIImage?) {
        guard let url = url else { return}
        image.map { cache?[url] = $0}
    }
}

struct URLImage: View {
    @ObservedObject private var remoteImage: RemoteImage
    
    init(url: URL?) {
        _remoteImage = ObservedObject(wrappedValue: RemoteImage(url: url, cache: Environment(\.imageCache).wrappedValue))
        remoteImage.load()
    }
    
    var body: some View {
        ZStack {
            switch remoteImage.loadingState {
            case .initial:
                EmptyView()
            case .inProgress:
//                ProgressView()
//                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                ActivityIndicator()
            case .success(let image):
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure:
                Image("news")
                    .resizable()
                        .aspectRatio(contentMode: .fill)
            }
        }
    }
}
