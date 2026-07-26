# 💰 Pillar 4: Monetization & SaaS Architecture

## 1. Paywall & Entitlement Architecture
- Implement clean entitlement verification via dedicated domain service (`EntitlementsService` / `RevenueCat` / custom IAP provider).
- Structure clear separation between Free Tier capabilities and Premium Entitlements (e.g., Free users read 5 daily tips; Premium users access unlimited tips, offline action plans, and AI Coach).

## 2. Subscription Lifecycle Management
- Handle graceful degradation when subscriptions expire or payments fail.
- Implement restore purchases functionality required by Apple App Store and Google Play Store guidelines.

## 3. Dynamic Pricing & A/B Testing Paywalls
- Architect UI paywall screens using remote-config-driven widgets to enable A/B testing of pricing tiers, trial durations, and promotional discounts without requiring app store re-submission.
