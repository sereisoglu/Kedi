//
//  CacheAsyncImage.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/5/24.
//

import SwiftUI

// This is a temporary solution. There are a few problems, for example: If you request an image with the same url at the same time, the cache will not work. Currently, this structure is used only in one place in the project. If necessary, the Nuke library can be added. It was made using the structure in this video: https://www.youtube.com/watch?v=KhGyiOk3Yzk
struct CacheAsyncImage<Content, Placeholder>: View where Content: View, Placeholder: View {
    
    private let url: URL
    private let scale: CGFloat
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    
    init(
        url: URL,
        scale: CGFloat = 1.0,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.scale = scale
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        if let cached = ImageCache[url] {
//            let _ = print("cached: \(url.absoluteString)")
            content(cached)
        } else {
//            let _ = print("request: \(url.absoluteString)")
            AsyncImage(
                url: url,
                scale: scale,
                content: { image in
                    let _ = ImageCache[url] = image
                    content(image)
                },
                placeholder: placeholder
            )
        }
    }
}

fileprivate final class ImageCache{

    static private var cache: [URL: Image] = [:]

    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}
