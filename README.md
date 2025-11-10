# Hustle

A SwiftUI reference implementation of a Gen Z-focused peer-to-peer marketplace for goods, services, and digital drops. The project captures the refreshed Hustle brand experience with modern onboarding, social-proof driven discovery, AI-assisted search, a TikTok-inspired feed, and creator-friendly wallet + analytics flows.

## Highlights

- **SwiftUI-first UI kit**: Authentication flow, category discovery grid, personalized feed, explore search, wallet, and analytics views aligned to the updated Hustle visual language.
- **AI-inspired search**: `SemanticSearchService` delivers lightweight semantic ranking with cosine similarity token scoring for natural language queries.
- **Hybrid recommendations**: `HybridRecommendationEngine` blends quality, recency, engagement, tag affinity, and featured boosts to emulate TikTok-style personalization.
- **Wallet orchestration**: `WalletViewModel` and `DefaultWalletService` manage deposits, withdrawals, and transaction history while syncing with the shared user session.
- **Creator analytics**: Performance snapshots power revenue progress bars, growth indicators, and metric cards to gamify sales momentum.

## Getting started

1. Open the repository in Xcode (iOS 16+ target).
2. Create a new SwiftUI app project or use the existing one and add this package as a local dependency via **File → Add Packages…**.
3. Set `HustleRootView()` as the root view of your app scene.

## Next steps

- Replace preview data with live API integration for listings, transactions, and analytics.
- Connect `UserSession` to real authentication and payment providers (e.g., Sign in with Apple, Stripe Connect).
- Expand the recommendation/search engines with server-side machine learning models once telemetry is available.
- Add unit tests for ranking, wallet arithmetic, and analytics growth calculations.
