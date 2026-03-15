# 💸 LeakLess — Stop Silent Money Leaks

**LeakLess** is a smart, AI-driven subscription leakage detector built for iOS. It helps users regain control of their finances by identifying unused services, duplicate subscriptions, and "silent leaks" caused by forgotten auto-renewals.

---

## 🚀 The Problem
In the digital era, users are overwhelmed with recurring charges—OTT platforms, AI tools, gym memberships, and SaaS products.
* **Silent Leaks:** People forget to cancel trials or active subscriptions.
* **Financial Drain:** A student paying for multiple OTT platforms can unknowingly lose **₹24,000+ per year** on services they rarely use.
* **Lack of Awareness:** Most banking apps show spending but don't flag "waste."

## ✨ Key Features
- **Smart Dashboard:** Real-time tracking of monthly spending and annual projections.
- **AI Leakage Engine:** Logic-based intelligence that flags services not used in over 30 days.
- **Optimization Alerts:** Identifies category overlaps (e.g., having 3+ OTT apps) and suggests consolidation.
- **Annual Savings Counter:** High-impact visual feedback showing exactly how much money can be recovered.
- **Native iOS Experience:** A high-fidelity, fintech-themed UI built entirely with **SwiftUI**.

## 🧠 The "AI" Leakage Engine
The core of LeakLess is a rule-based intelligence engine that evaluates the "ROI" of your digital life:
1. **Inactivity Flag:** If `lastUsedDays > 30`, the service is moved to the "Leakage" total.
2. **Category Overlap:** If the user has more than 2 services in the same category (e.g., OTT), the system triggers a "Consolidation Warning."
3. **Auto-Renew Risk:** Prioritizes alerts for services with auto-renewal enabled.

## 🛠 Tech Stack
- **Language:** Swift 5.10
- **Framework:** SwiftUI
- **Reactive Programming:** Combine (for State Management)
- **Architecture:** MVVM (Model-View-ViewModel)
- **Icons:** Apple SF Symbols

## 📱 Installation & Setup
1. Clone this repository.
2. Open the project in **Xcode 15+**.
3. Select an iPhone Simulator (iOS 17+ recommended).
4. Build and Run (`Cmd + R`).
5. Copy the contents of `ContentView.swift` into your project's main view file.

## 🗺 Future Roadmap
- [ ] **Bank API Integration:** Automatic transaction syncing.
- [ ] **Email Scanning:** OCR for scanning digital receipts from Gmail/Outlook.
- [ ] **One-Click Cancellation:** Deep links to service cancellation pages.
- [ ] **Family Plan Optimizer:** Suggesting shared plans to split costs.

## 👥 Team: ByteBalance
- **Nithilan** - Lead iOS Developer & Logic Architect

---

*“In a world of auto-renewals, LeakLess gives users control.”* 💸
