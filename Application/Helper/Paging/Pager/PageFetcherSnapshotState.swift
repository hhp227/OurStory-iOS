//
//  PageFetcherSnapshotState.swift
//  Application
//
//  Created by 홍희표 on 2022/06/28.
//

import Combine
import Foundation

internal class PageFetcherSnapshotState<Key: Any, Value: Any> {
    private let config: PagingConfig
    
    private var _pages = [PagingSource<Key, Value>.LoadResult<Key, Value>.Page<Key, Value>]()
    
    internal var pages: [PagingSource<Key, Value>.LoadResult<Key, Value>.Page<Key, Value>] {
        return _pages
    }
    
    private(set) internal var initialPageIndex = 0
    
    internal var storageCount: Int {
        return pages.reduce(0) { $1.data.count }
    }
    
    private var _placeholdersBefore = 0
    
    internal var placeholdersBefore: Int {
        get {
            return config.enablePlaceholders ? _placeholdersBefore : 0
        }
        set {
            switch newValue {
            case .min:
                _placeholdersBefore = 0
            default:
                _placeholdersBefore = newValue
            }
        }
    }
    
    private var _placeholdersAfter = 0
    
    internal var placeholdersAfter: Int {
        get {
            return config.enablePlaceholders ? _placeholdersAfter : 0
        }
        set {
            switch newValue {
            case .min:
                _placeholdersAfter = 0
            default:
                _placeholdersAfter = newValue
            }
        }
    }
    
    private var prependGenerationId = 0
    
    private var appendGenerationId = 0
    
    private let prependGenerationIdCurrentValueSubject: CurrentValueSubject<Int, Never>
    
    private let appendGenerationIdCurrentValueSubject: CurrentValueSubject<Int, Never>
    
    internal func generationId(_ loadType: LoadType) -> Int {
        switch loadType {
        case .REFRESH:
            fatalError("Cannot get loadId for loadType: REFRESH")
        case .PREPEND:
            return prependGenerationId
        case .APPEND:
            return appendGenerationId
        }
    }
    
    internal var failedHintsByLoadType = [LoadType: ViewportHint]()
    
    private(set) internal var sourceLoadStates: MutableLoadStateCollection = {
        var sourceLoadStates = MutableLoadStateCollection()
        
        sourceLoadStates.set(LoadType.REFRESH, LoadState.Loading.instance)
        return sourceLoadStates
    }()
    
    func consumePrependGenerationIdAsPublisher() -> AnyPublisher<Int, Never> {
        return prependGenerationIdCurrentValueSubject
            .handleEvents(receiveSubscription: { _ in self.prependGenerationIdCurrentValueSubject.send(self.prependGenerationId) })
            .eraseToAnyPublisher()
    }
    
    func consumeAppendGenerationIdAsPublisher() -> AnyPublisher<Int, Never> {
        return appendGenerationIdCurrentValueSubject
            .handleEvents(receiveSubscription: { _ in self.appendGenerationIdCurrentValueSubject.send(self.appendGenerationId) })
            .eraseToAnyPublisher()
    }
    
    internal func toPageEvent(_ loadType: LoadType, _ page: PagingSource<Key, Value>.LoadResult<Key, Value>.Page<Key, Value>) -> PageEvent<Value> {
        let sourcePageIndex: Int
        switch loadType {
        case .REFRESH:
            sourcePageIndex = 0
        case .PREPEND:
            sourcePageIndex = 0 - initialPageIndex
        case .APPEND:
            sourcePageIndex = pages.count - initialPageIndex - 1
        }
        let pages = [TransformablePage(originalPageOffset: sourcePageIndex, data: page.data)]
        
        switch loadType {
        case .REFRESH:
            return PageEvent<Value>.Insert.Refresh(
                pages: pages,
                placeholdersBefore: placeholdersBefore,
                placeholdersAfter: placeholdersAfter,
                sourceLoadStates: sourceLoadStates.snapshot(),
                mediatorLoadStates: nil
            )
        case .PREPEND:
            return PageEvent<Value>.Insert.Prepend(
                pages: pages,
                placeholdersBefore: placeholdersBefore,
                sourceLoadStates: sourceLoadStates.snapshot(),
                mediatorLoadStates: nil
            )
        case .APPEND:
            return PageEvent<Value>.Insert.Append(
                pages: pages,
                placeholdersAfter: placeholdersAfter,
                sourceLoadStates: sourceLoadStates.snapshot(),
                mediatorLoadStates: nil
            )
        }
    }
    
    func insert(_ loadId: Int, _ loadType: LoadType, page: PagingSource<Key, Value>.LoadResult<Key, Value>.Page<Key, Value>) -> Bool {
        switch loadType {
        case .REFRESH:
            guard pages.isEmpty else {
                fatalError("cannot receive multiple init calls")
            }
            guard loadId == 0 else {
                fatalError("init loadId must be the initial value, 0")
            }
            
            _pages.append(page)
            initialPageIndex = 0
            placeholdersAfter = page.itemsAfter
            placeholdersBefore = page.itemsBefore
        case .PREPEND:
            guard !pages.isEmpty else {
                fatalError("should've receive an init before prepend")
            }
            if loadId != prependGenerationId {
                return false
            }
            
            _pages.insert(page, at: 0)
            initialPageIndex += 1
            placeholdersBefore = page.itemsBefore == Int.min ? max(placeholdersBefore - page.data.count, 0) : page.itemsBefore
            failedHintsByLoadType.removeValue(forKey: .PREPEND)
        case .APPEND:
            guard !pages.isEmpty else {
                fatalError("should've receive an init before append")
            }
            if loadId != appendGenerationId {
                return false
            }
            
            _pages.append(page)
            placeholdersAfter = page.itemsAfter == Int.min ? max(placeholdersAfter - page.data.count, 0) : page.itemsAfter
            failedHintsByLoadType.removeValue(forKey: .APPEND)
        }
        return true
    }
    
    func drop(_ event: PageEvent<Value>.Drop<Value>) {
        assert(event.pageCount <= pages.count, "invalid drop count. have \(pages.count) but wanted to drop \(event.pageCount)")
        failedHintsByLoadType.removeValue(forKey: event.loadType)
        sourceLoadStates.set(event.loadType, .NotLoading(false))
        
        switch event.loadType {
        case .PREPEND:
            _pages.removeFirst(event.pageCount)
            initialPageIndex -= event.pageCount
            placeholdersBefore = event.placeholdersRemaining
            prependGenerationId += 1
            prependGenerationIdCurrentValueSubject.send(prependGenerationId)
        case .APPEND:
            _pages.removeLast(event.pageCount)
            placeholdersAfter = event.placeholdersRemaining
            appendGenerationId += 1
            appendGenerationIdCurrentValueSubject.send(appendGenerationId)
        case .REFRESH:
            fatalError("cannot drop \(event.loadType)")
        }
    }
    
    func dropEventOrNil(_ loadType: LoadType, _ hint: ViewportHint) -> PageEvent<Value>.Drop<Value>? {
        if config.maxSize == Int.max {
            return nil
        }
        if pages.count <= 2 {
            return nil
        }
        if storageCount <= config.maxSize {
            return nil
        }
        assert(loadType != .REFRESH, "Drop LoadType must be prepend or append, but got \(loadType)")
        var pagesToDrop = 0
        var itemsToDrop = 0
        
        while pagesToDrop < pages.count && storageCount - itemsToDrop > config.maxSize {
            let pageCount: Int
            
            switch loadType {
            case .PREPEND:
                pageCount = pages[pagesToDrop].data.count
            default:
                pageCount = pages[pages.count - 1 - pagesToDrop].data.count
            }
            let itemAfterDrop: Int
            switch loadType {
            case .PREPEND:
                itemAfterDrop = hint.presentedItemsBefore - itemsToDrop - pageCount
            default:
                itemAfterDrop = hint.presentedItemsAfter - itemsToDrop - pageCount
            }
            if itemAfterDrop < config.prefetchDistance {
                break
            }
            itemsToDrop += pageCount
            pagesToDrop += 1
        }
        switch pagesToDrop {
        case 0:
            return nil
        default:
            return PageEvent<Value>.Drop<Value>(
                loadType: loadType,
                minPageOffset: loadType == .PREPEND ? -initialPageIndex : (pages.endIndex - 1) - initialPageIndex - (pagesToDrop - 1),
                maxPageOffset: loadType == .PREPEND ? (pagesToDrop - 1) - initialPageIndex : (pages.endIndex - 1) - initialPageIndex,
                placeholdersRemaining: !config.enablePlaceholders ? 0 : loadType == .PREPEND ? placeholdersBefore + itemsToDrop : placeholdersAfter + itemsToDrop
            )
        }
    }
    
    internal func currentPagingState(viewportHint: ViewportHint.Access?) -> PagingState<Key, Value> {
        return PagingState(
            pages: pages,
            anchorPosition: {
                if let hint = viewportHint {
                    var anchorPosition = placeholdersBefore
                    let fetcherPageOffsetFirst = -initialPageIndex
                    let fetcherPageOffsetLast = pages.endIndex - 1 - initialPageIndex
                    
                    for pageOffset in fetcherPageOffsetFirst..<hint.pageOffset {
                        anchorPosition += pageOffset > fetcherPageOffsetLast ? config.pageSize : pages[pageOffset + initialPageIndex].data.count
                    }
                    anchorPosition += hint.indexInPage
                    
                    if hint.pageOffset < fetcherPageOffsetFirst {
                        anchorPosition -= config.pageSize
                    }
                    return anchorPosition
                } else {
                    return nil
                }
            }(),
            config: config,
            leadingPlaceholderCount: placeholdersBefore
        )
    }
    
    private init(_ config: PagingConfig) {
        self.config = config
        self.prependGenerationIdCurrentValueSubject = CurrentValueSubject<Int, Never>(-1)
        self.appendGenerationIdCurrentValueSubject = CurrentValueSubject<Int, Never>(-1)
    }
    
    class Holder<Key: Any, Value: Any> {
        private let lock = NSLock()
        
        private let state: PageFetcherSnapshotState<Key, Value>
        
        @inline(__always) func withLock<T>(block: (PageFetcherSnapshotState<Key, Value>) -> T) -> T {
            return lock.withLock {
                block(state)
            }
        }
        
        init(config: PagingConfig) {
            state = PageFetcherSnapshotState<Key, Value>(config)
        }
    }
}
