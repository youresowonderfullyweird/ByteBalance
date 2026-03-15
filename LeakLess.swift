import SwiftUI
import Combine

// MARK: - Color Extension
extension Color {
    static let emerald = Color(red: 16/255, green: 185/255, blue: 129/255)
    static let darkBg = Color(red: 10/255, green: 10/255, blue: 12/255)
}

// MARK: - Data Model
struct Subscription: Identifiable {
    let id = UUID()
    var name: String
    var category: String
    var cost: Double
    var lastUsedDays: Int
    var autoRenew: Bool
    var icon: String
}

// MARK: - Leakage Engine Logic
struct LeakageAnalysis {
    var monthlyTotal: Double = 0
    var monthlyLeakage: Double = 0
    var annualSavings: Double = 0
    var alerts: [LeakAlert] = []
    
    struct LeakAlert: Identifiable {
        let id = UUID()
        let type: AlertType
        let message: String
        
        enum AlertType {
            case danger, warning
        }
    }
}

// MARK: - Main ViewModel
class SubscriptionViewModel: ObservableObject {
    @Published var subscriptions: [Subscription] = [
        Subscription(name: "Netflix", category: "OTT", cost: 499, lastUsedDays: 45, autoRenew: true, icon: "🎬"),
        Subscription(name: "Prime Video", category: "OTT", cost: 149, lastUsedDays: 2, autoRenew: true, icon: "📦"),
        Subscription(name: "Disney+", category: "OTT", cost: 299, lastUsedDays: 60, autoRenew: true, icon: "🏰"),
        Subscription(name: "ChatGPT Plus", category: "AI", cost: 1650, lastUsedDays: 1, autoRenew: true, icon: "🤖"),
        Subscription(name: "Adobe CC", category: "Design", cost: 4000, lastUsedDays: 20, autoRenew: false, icon: "🎨"),
        Subscription(name: "Gym", category: "Health", cost: 1500, lastUsedDays: 35, autoRenew: true, icon: "🏋️")
    ]
    
    var analysis: LeakageAnalysis {
        var result = LeakageAnalysis()
        var categoryCounts: [String: Int] = [:]
        
        for sub in subscriptions {
            result.monthlyTotal += sub.cost
            categoryCounts[sub.category, default: 0] += 1
            
            // Logic: Inactive > 30 days
            if sub.lastUsedDays > 30 {
                result.monthlyLeakage += sub.cost
                result.alerts.append(.init(type: .danger, message: "Flagged: \(sub.name) hasn't been used in \(sub.lastUsedDays) days."))
            }
        }
        
        // Logic: OTT Overlap
        if let ottCount = categoryCounts["OTT"], ottCount > 2 {
            result.alerts.append(.init(type: .warning, message: "Optimization: You have \(ottCount) OTT services active. Consider consolidating."))
        }
        
        result.annualSavings = result.monthlyLeakage * 12
        return result
    }
    
    func deleteSubscription(at offsets: IndexSet) {
        subscriptions.remove(atOffsets: offsets)
    }
    
    func addSubscription(_ sub: Subscription) {
        subscriptions.append(sub)
    }
}

// MARK: - Main View
struct ContentView: View {
    @StateObject var vm = SubscriptionViewModel()
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.darkBg.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        headerStatsView
                        
                        if !vm.analysis.alerts.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Label("AI Intelligence", systemImage: "bolt.fill")
                                    .font(.headline)
                                    .foregroundColor(.emerald)
                                
                                ForEach(vm.analysis.alerts) { alert in
                                    alertCard(alert: alert)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Label("Subscriptions", systemImage: "creditcard.fill")
                                    .font(.headline)
                                Spacer()
                                Text("\(vm.subscriptions.count) items")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                            
                            VStack(spacing: 1) {
                                ForEach(vm.subscriptions) { sub in
                                    subscriptionRow(sub: sub)
                                }
                            }
                            .background(Color(white: 0.12))
                            .cornerRadius(20)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("LeakLess")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.emerald)
                    }
                }
            }
            .preferredColorScheme(.dark)
            .sheet(isPresented: $showingAddSheet) {
                AddSubscriptionView(vm: vm)
            }
        }
    }
    
    var headerStatsView: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                VStack(alignment: .leading) {
                    Text("MONTHLY")
                        .font(.caption2.bold())
                        .foregroundColor(.gray)
                    Text("₹\(Int(vm.analysis.monthlyTotal))")
                        .font(.title2.bold())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(white: 0.1))
                .cornerRadius(16)
                
                VStack(alignment: .leading) {
                    Text("LEAKAGE")
                        .font(.caption2.bold())
                        .foregroundColor(.red.opacity(0.8))
                    Text("₹\(Int(vm.analysis.monthlyLeakage))")
                        .font(.title2.bold())
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.red.opacity(0.2), lineWidth: 1))
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("ANNUAL SAVINGS POTENTIAL")
                        .font(.caption2.bold())
                        .foregroundColor(.black.opacity(0.6))
                    Text("₹\(Int(vm.analysis.annualSavings))")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundColor(.black)
                }
                Spacer()
                Image(systemName: "zap.fill")
                    .font(.largeTitle)
                    .foregroundColor(.black.opacity(0.2))
            }
            .padding(24)
            .background(Color.emerald)
            .cornerRadius(24)
            .shadow(color: Color.emerald.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal)
    }
    
    func alertCard(alert: LeakageAnalysis.LeakAlert) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(alert.type == .danger ? .red : .yellow)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(alert.message)
                    .font(.footnote.bold())
                    .lineLimit(2)
                
                Button("Auto-Cancel") { }
                    .font(.caption2.bold())
                    .foregroundColor(.emerald)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(alert.type == .danger ? Color.red.opacity(0.05) : Color.yellow.opacity(0.05))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(alert.type == .danger ? Color.red.opacity(0.1) : Color.yellow.opacity(0.1), lineWidth: 1))
    }
    
    func subscriptionRow(sub: Subscription) -> some View {
        HStack(spacing: 16) {
            Text(sub.icon)
                .font(.title2)
                .frame(width: 44, height: 44)
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(sub.name)
                    .font(.system(size: 16, weight: .bold))
                Text(sub.category)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("₹\(Int(sub.cost))")
                    .font(.system(size: 16, weight: .black))
                Text("\(sub.lastUsedDays)d ago")
                    .font(.caption2)
                    .foregroundColor(sub.lastUsedDays > 30 ? .red : .emerald)
            }
        }
        .padding()
    }
}

struct AddSubscriptionView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: SubscriptionViewModel
    
    @State private var name = ""
    @State private var cost = ""
    @State private var category = "OTT"
    @State private var autoRenew = true
    
    let categories = ["OTT", "AI", "Health", "Design", "Learning"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Service Details")) {
                    TextField("Service Name", text: $name)
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat)
                        }
                    }
                    TextField("Monthly Cost", text: $cost)
                        .keyboardType(.decimalPad)
                }
                
                Section {
                    Toggle("Auto-Renewal Enabled", isOn: $autoRenew)
                }
                
                Section {
                    Button("Start Tracking") {
                        let newSub = Subscription(
                            name: name,
                            category: category,
                            cost: Double(cost) ?? 0,
                            lastUsedDays: 0,
                            autoRenew: autoRenew,
                            icon: "💳"
                        )
                        vm.addSubscription(newSub)
                        dismiss()
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.emerald)
                }
            }
            .navigationTitle("New Service")
            .navigationBarItems(leading: Button("Cancel") { dismiss() })
        }
    }
}