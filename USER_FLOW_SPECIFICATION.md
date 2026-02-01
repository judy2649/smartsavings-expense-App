# Smart Savings App - User Data Input & Management Flow
## Professional Fintech UX Specification

---

## Table of Contents
1. [Overview](#overview)
2. [First-Time Setup Flow (Onboarding)](#first-time-setup-flow)
3. [Post-Setup Data Management](#post-setup-data-management)
4. [Settings & Account Management](#settings--account-management)
5. [UX Principles](#ux-principles)
6. [Design Specifications](#design-specifications)

---

## Overview

Smart Savings implements a **progressive disclosure** onboarding model where users set up core financial data in 5-7 guided screens, then manage their finances through contextual actions on the dashboard and settings panel.

### Key Principles
- **One Primary Action Per Screen** - Clear focus, no decision paralysis
- **Progressive Complexity** - Mandatory → Optional → Advanced features
- **Beginner-Friendly Language** - No financial jargon without explanation
- **Reassurance & Transparency** - Clear explanation of data usage and security

---

# PART 1: FIRST-TIME SETUP FLOW (ONBOARDING)

## Screen 1: Welcome & Permissions

### Layout
```
┌─────────────────────────────────┐
│  Smart Savings                  │
│  ╔════════════════════════════╗ │
│  ║   Smart, Secure           ║ │
│  ║   Spending Tracking       ║ │
│  ║   [Finance Hero Image]    ║ │
│  ╚════════════════════════════╝ │
│                                 │
│  "Manage your money with       │
│   confidence"                   │
│                                 │
│  ┌──────────────────────────┐  │
│  │ Get Started (Primary CTA)│  │
│  └──────────────────────────┘  │
│  ┌──────────────────────────┐  │
│  │ Already have account?    │  │
│  │ Sign In (Secondary CTA)  │  │
│  └──────────────────────────┘  │
└─────────────────────────────────┘
```

### Actions
- **Get Started** → Flow to Screen 2
- **Sign In** → Direct to login screen

### Copy Tone
- Friendly, professional, reassuring
- Emphasize control and simplicity
- No overwhelming features mentioned

---

## Screen 2: Profile Setup & Currency Selection

### Primary Action: Set Currency
### Layout
```
┌─────────────────────────────────┐
│ ⬅ Welcome                       │
├─────────────────────────────────┤
│                                 │
│ Step 1 of 5: Your Profile      │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━   │
│                                 │
│ What's your name?               │
│ ┌──────────────────────────┐   │
│ │ [First Name Input]       │   │
│ └──────────────────────────┘   │
│                                 │
│ Country/Currency                │
│ ┌──────────────────────────┐   │
│ │ 🇰🇪 Kenya - KES ▼      │   │
│ └──────────────────────────┘   │
│                                 │
│ 💡 We use this for accurate    │
│    local market insights       │
│                                 │
│                                 │
│ ┌──────────────────────────┐   │
│ │ Continue →               │   │
│ └──────────────────────────┘   │
└─────────────────────────────────┘
```

### Data Collection
- **First Name** (Required)
- **Country/Currency** (Required, default to user's locale)

### Validation
- Name: 2-50 characters, no special characters
- Currency: Auto-selected from device locale

### Reassurance Element
- Small info icon explaining why currency is needed
- "This helps us show prices in your local currency"

### Navigation
- **Continue** → Screen 3 (Account Setup)
- **Back** → Screen 1

---

## Screen 3: Account Connection Setup

### Primary Action: Add Accounts
### Layout
```
┌─────────────────────────────────┐
│ ⬅ Profile                       │
├─────────────────────────────────┤
│                                 │
│ Step 2 of 5: Your Accounts     │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━   │
│                                 │
│ Where do you keep your money?   │
│ (You can add more later)        │
│                                 │
│ ┌──────────────────────────┐   │
│ │ ☑ Primary Bank Account   │   │
│ │   Tap to connect         │   │
│ └──────────────────────────┘   │
│                                 │
│ ┌──────────────────────────┐   │
│ │ ☐ M-Pesa / Mobile Money  │   │
│ │   Tap to connect         │   │
│ └──────────────────────────┘   │
│                                 │
│ ┌──────────────────────────┐   │
│ │ ☐ Cash Wallet            │   │
│ │   Manual tracking only   │   │
│ └──────────────────────────┘   │
│                                 │
│ ┌──────────────────────────┐   │
│ │ Continue →               │   │
│ │ (Skip for now)           │   │
│ └──────────────────────────┘   │
└─────────────────────────────────┘
```

### Account Types Available
1. **Bank Account** (Tap to connect → OAuth flow)
2. **Mobile Money (M-Pesa)** (Tap to connect → SMS verification)
3. **Cash Wallet** (Manual entry only)

### Connection Flows

#### If User Selects "Bank Account"
```
Screen 3.1: Bank Connection
┌─────────────────────────────────┐
│ Select Your Bank                │
├─────────────────────────────────┤
│ Search for your bank...         │
│ ┌──────────────────────────┐   │
│ │ [Search Input]           │   │
│ └──────────────────────────┘   │
│                                 │
│ Popular Banks:                  │
│ • Equity Bank                   │
│ • KCB Bank                      │
│ • Safaricom M-Pesa              │
│ • Pesapal                       │
│ • Others                        │
│                                 │
│ [Tap bank] → OAuth Login        │
└─────────────────────────────────┘

Screen 3.2: Authorization
🔒 [Bank Name] Authorization
"Smart Savings requests permission to:"
✓ View your account balance
✓ View transaction history
✓ Read-only access (no changes)

[Authorize]  [Cancel]
```

#### If User Selects "M-Pesa"
```
Screen 3.1: M-Pesa Setup
┌─────────────────────────────────┐
│ Connect M-Pesa Account          │
├─────────────────────────────────┤
│ Enter your M-Pesa number:       │
│ ┌──────────────────────────┐   │
│ │ +254 |_|_|_|_|_|_|_|_|_ │   │
│ └──────────────────────────┘   │
│                                 │
│ 💡 We'll send a verification   │
│    SMS to confirm access       │
│                                 │
│ [Verify]  [Back]               │
└─────────────────────────────────┘

Screen 3.2: OTP Verification
Enter 4-digit code sent to:
+254 7** *** ***

[_][_][_][_]

Resend code in 45s
```

### Data Collection
- Optional account connections
- Support for 0-3 accounts at setup
- All account additions can be done later

### Skip Option
- "Continue" button with "(Skip for now)" subtitle
- Users not required to connect accounts

### Navigation
- **Bank Selected** → OAuth flow → Back to Screen 3 with account added
- **M-Pesa Selected** → Phone verification → Back to Screen 3
- **Continue** → Screen 4 (Budget Setup)
- **Back** → Screen 2

---

## Screen 4: Weekly Budget Setup

### Primary Action: Set Weekly Spending Limit
### Layout
```
┌─────────────────────────────────┐
│ ⬅ Accounts                      │
├─────────────────────────────────┤
│                                 │
│ Step 3 of 5: Weekly Budget     │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━   │
│                                 │
│ How much do you want to spend   │
│ per week?                       │
│                                 │
│ This helps you stay on track    │
│ and avoid overspending          │
│                                 │
│ ┌──────────────────────────┐   │
│ │ KES  [5000________]      │   │
│ │ ← Drag slider →          │   │
│ └──────────────────────────┘   │
│                                 │
│ 💡 Suggested: KES 3,500/week   │
│    (based on your category data)│
│                                 │
│ Smart Alerts:                   │
│ ☐ Notify me at 80% spent       │
│ ☐ Notify me at 100% spent      │
│                                 │
│ [Continue →]                    │
│ [Skip for now]                  │
└─────────────────────────────────┘
```

### Data Collection
- **Weekly Budget Amount** (Required, default suggestion based on user spending patterns)
- **Alert Thresholds** (Optional checkboxes)

### Input Method
- Slider (0 - 50,000 KES) for quick selection
- Input field to type exact amount
- Real-time visual indicator of spending pace

### Smart Suggestions
- Algorithm suggests budget based on:
  - User's average weekly spending
  - Industry benchmarks for user's region
  - Account balance (suggest 10-20% of balance)

### Validation
- Minimum: 500 KES
- Maximum: Balance available or 1,000,000 KES
- Real-time visual feedback

### Navigation
- **Continue** → Screen 5 (Monthly Budget)
- **Skip for now** → Screen 5
- **Back** → Screen 3

---

## Screen 5: Monthly Budget Setup

### Primary Action: Set Monthly Budget
### Layout
```
┌─────────────────────────────────┐
│ ⬅ Weekly Budget                 │
├─────────────────────────────────┤
│                                 │
│ Step 4 of 5: Monthly Budget    │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━   │
│                                 │
│ And for the whole month?        │
│                                 │
│ ┌──────────────────────────┐   │
│ │ KES  [20000_______]      │   │
│ │ ← Drag slider →          │   │
│ └──────────────────────────┘   │
│                                 │
│ 💡 That's ~4,620 per week      │
│    (Auto-calculated)            │
│                                 │
│ Smart Alerts:                   │
│ ☐ Weekly summary every Sunday  │
│ ☐ Monthly report on the 1st    │
│                                 │
│ [Continue →]                    │
│ [Skip for now]                  │
└─────────────────────────────────┘
```

### Data Collection
- **Monthly Budget Amount** (Required)
- **Notification Preferences** (Optional)

### Auto-Calculation
- Show weekly equivalent: Monthly ÷ 4.3
- If weekly budget set, suggest monthly = weekly × 4.3

### Validation
- Minimum: 1,000 KES
- Maximum: 10,000,000 KES
- Warn if monthly < weekly × 4

### Navigation
- **Continue** → Screen 6 (Savings Goals)
- **Skip for now** → Screen 6
- **Back** → Screen 4

---

## Screen 6: Savings Goals Setup

### Primary Action: Add First Savings Goal
### Layout
```
┌─────────────────────────────────┐
│ ⬅ Monthly Budget                │
├─────────────────────────────────┤
│                                 │
│ Step 5 of 5: Savings Goals     │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━   │
│                                 │
│ What are you saving for?        │
│ (Optional - add up to 5 goals)  │
│                                 │
│ Goal 1:                         │
│ ┌──────────────────────────┐   │
│ │ Emergency Fund (default) │   │
│ └──────────────────────────┘   │
│                                 │
│ Target Amount:                  │
│ ┌──────────────────────────┐   │
│ │ KES  [50000_______]      │   │
│ └──────────────────────────┘   │
│                                 │
│ Target Date:                    │
│ ┌──────────────────────────┐   │
│ │ 📅 Dec 31, 2026         │   │
│ └──────────────────────────┘   │
│                                 │
│ Monthly Contribution:           │
│ ┌──────────────────────────┐   │
│ │ KES  [2000_______]       │   │
│ │ (Auto-calculated)        │   │
│ └──────────────────────────┘   │
│                                 │
│ ┌──────────────────────────┐   │
│ │ + Add Another Goal       │   │
│ └──────────────────────────┘   │
│                                 │
│ [Continue →]                    │
│ [Skip goals for now]            │
└─────────────────────────────────┘
```

### Goal Templates
Pre-defined with icons:
1. 🚨 Emergency Fund (3-6 months expenses)
2. 🏠 Home Down Payment
3. 🎓 Education
4. 🚗 Car
5. 🎉 Vacation
6. Custom Goal

---

## PART 2: BUDGETING RULES ENGINE (DETAILED SPEC)

This section defines the algorithms, thresholds, and data models used by the app to produce budgets, detect overspending, recommend savings, and produce behavioral insights.

### Inputs
- Monthly income (net)
- Recurring monthly expenses (fixed): rent, loans, subscriptions
- Recurring yearly expenses (allocated monthly): insurance, taxes
- One-off expenses (historical transactions)
- Connected account balances and recent transactions
- User-defined budget categories and priorities
- Savings goals (amount, target date, priority)

### Core Models
- Transaction { id, date, amount, currency, merchant, rawDescription, category, source, accountId, status }
- Account { id, provider, accountNumberMasked, currency, balance, availableBalance }
- SavingsGoal { id, name, targetAmount, savedAmount, targetDate, monthlyContributionSuggested, priority }
- BudgetCategory { id, name, allocationPct, allocationAmount, spentMonthToDate, alerts }

### Monthly Budget Formula (suggestion)

Primary approach (default):
1. Compute fixedMonthly = sum(recurring monthly expenses) + monthlyPortion(yearlyExpenses)
2. disposable = max(0, income - fixedMonthly)
3. Apply allocation strategy (choose one):
   - Percent-based presets: 50/30/20 (Needs/ Wants / Savings) or 60/20/20 etc.
   - Category-proportional: use historical spend ratios to allocate disposable across categories
   - Custom user allocations: if user provided allocationPct for categories, honor them
4. For each category: allocationAmount = disposable * allocationPct (or computed by proportional approach)
5. Ensure allocations + fixedMonthly + suggestedSavings <= income. If exceed, scale allocations down proportionally and surface a warning.

Pseudocode:

```
fixedMonthly = sum(monthly_recurring) + sum(yearly_recurring)/12
disposable = max(0, income - fixedMonthly)
if userProvidedAllocations:
  for cat in categories: cat.allocationAmount = income * cat.allocationPct
else if preset == "50-30-20":
  needs = income * 0.5; wants = income * 0.3; savings = income * 0.2
  distribute needs/wants by category priorities
else:
  // proportional by historical spend
  ratios = historicalSpendLastNMonths / sum
  for cat: cat.allocationAmount = disposable * ratios[cat]
```

### Overspending Rules
- Thresholds: warn at 80% of category allocation (soft alert), alert at 100% (hard alert)
- Reactions:
  - Soft alert: push notification + in-app suggestion (reduce discretionary categories by X%, pause auto-save optional)
  - Hard alert: recommend reallocation of budget from lower-priority categories or reduce savings contribution until month-end
- Detect rapid spend velocity: if spend in a 7-day window > 50% of monthly allocation, generate immediate alert and suggested actions (freeze subscriptions, set temporary cap)

Detection pseudocode:

```
for cat in categories:
  pct = cat.spentMonthToDate / cat.allocationAmount
  if pct >= 1.0: emitAlert(type="hard", cat)
  else if pct >= 0.8: emitAlert(type="soft", cat)

// velocity
if sum(spendLast7Days, cat)/cat.allocationAmount > 0.5: emitAlert(type="velocity", cat)
```

### Saving Rules
- For each SavingsGoal:
  - monthsLeft = months_between(now, targetDate)
  - requiredMonthly = max(ceil((targetAmount - savedAmount) / monthsLeft), 0)
  - suggestedMonthly = min(requiredMonthly, floor(disposable * goalPriorityFactor))
- Auto-save trigger (optional): when availableBalance - projectedRemainingExpenses > autosaveThreshold, transfer suggestedMonthly
- Prioritization: higher-priority goals get a larger share of surplus funds; user can set auto-save ON/OFF per goal

### Alerts
- Monthly expense alerts: when category or total spending hits defined thresholds (e.g., 80%, 100%)
- Yearly expense alerts: for yearly recurring bills, notify N days before due (configurable)
- Large transaction alert: any single transaction > X% of monthly income (default 10%) triggers review
- Reconciliation alerts: missing transactions or failed aggregation attempts

### Behavioral Insights
- Trend detection per category: compute month-over-month % change; flag persistent increases (3+ months)
- Subscription detection: detect recurring payments by merchant name, frequency, and amount stability
- Recommendations: suggest cancelling low-usage subscriptions, suggest lowering wants category by Y% to hit savings target
- Confidence scoring: for each insight include confidence level based on transaction match quality and history length

### Exports & APIs
- Budget engine exposes endpoints (or internal service interfaces):
  - GET /budget/suggest?userId= : returns category allocations, suggested savings, warnings
  - POST /budget/reallocate : accepts user override, returns adjusted plan
  - GET /insights : returns behavior insights and suggestions

Security & Privacy notes: all calculations use encrypted stored balances/transactions; PII minimal in logs; follow local financial data regulations.

---

## PART 3: FINANCIAL AGGREGATOR SPEC (M-PESA & BANKS)

This defines the ingestion contract, normalized data model, deduplication, and security considerations for external financial sources.

### Supported Providers
- M-Pesa (Safaricom) via secure API / webhook / STK push
- Banks: OAuth2 / PSD2-like connectors, or partner APIs (bank-specific)

### Auth Patterns
- M-Pesa: API key + callback verification (or OAuth where available). Use short-lived tokens and rotate.
- Banks: OAuth2 where supported; else use tokenized partner connector. Consent scopes: read:accounts, read:transactions

### Normalized Transaction Schema
```
{
  "txId": "string",
  "source": "MPESA|BANK|MANUAL",
  "accountId": "string",
  "date": "ISO-8601",
  "postedDate": "ISO-8601|null",
  "amount": -1234.56,
  "currency": "KES",
  "merchant": "string|null",
  "rawDescription": "string",
  "category": "uncategorized|null",
  "type": "DEBIT|CREDIT|FEE|REFUND",
  "status": "PENDING|SETTLED",
  "metadata": { /* provider-specific */ }
}
```

### Ingestion & Reconciliation
- Polling cadence: initial full sync of last 12 months (if permitted), then incremental sync daily or via webhooks
- Webhook handling: accept transaction push, verify signature, enqueue for normalization
- Deduplication rules: match on (providerId, txId) OR (amount, date, maskedAccount, roundedAmount, similarity(rawDescription)) within time window
- Pending vs settled: treat pending transactions separately, update status on settlement

### Category Mapping
- Use merchant-name matching + ML fuzzy matching to suggest category
- Allow user overrides and learn mappings per-user
- Maintain global and user-specific merchant→category maps

### Error Handling & Retries
- On provider errors, exponential backoff with alerts to ops if repeated failures
- Queue failed items for manual review with reason codes

### Security
- Store provider credentials and tokens encrypted at rest (use platform key management)
- All API calls use TLS 1.2+ and certificate pinning where feasible
- Do not store full PANs or sensitive auth secrets; store masked identifiers only
- Audit logs for consent and access

---

## PART 4: EXAMPLE WORKFLOWS

1) New user connects M-Pesa and sets income and goals
   - On connect: fetch last 12 months transactions, normalize, compute initial category ratios
   - Suggest monthly budget using proportional allocation
   - Pre-fill suggested monthly contribution to Emergency Fund

2) Mid-month overspend on "Dining" category
   - Transaction ingestion marks Dining at 85% of allocation
   - Soft alert sent; in-app UI shows recommended reallocation: reduce "Entertainment" by 10% and move to "Dining"

3) Large yearly insurance premium upcoming
   - Yearly expense parsed into monthly allocation; app notifies 30 days ahead and shows impact on monthly disposable

---

## PART 5: NEXT IMPLEMENTATION STEPS
- Add core models to `lib/core/models` (Transaction, Account, BudgetCategory, SavingsGoal)
- Add skeleton services to `lib/core/services`:
  - `budget_engine_service.dart` (exposes suggestion APIs)
  - `aggregator_service.dart` (ingestion, normalization)
  - `category_mapper.dart` (merchant matching)
- Implement unit tests for budget calculation and overspending detection

---

*End of additions.*

### Data Collection Per Goal
- **Goal Name** (Required)
- **Target Amount** (Required)
- **Target Date** (Required)
- **Monthly Contribution** (Auto-calculated, editable)

### Auto-Calculation
- Monthly Contribution = (Target Amount) ÷ (Months until target)
- Example: 50,000 KES target, 24 months = 2,083/month

### Smart Suggestions
- Recommend at least one "Emergency Fund" goal
- Suggest amounts based on user's monthly spending

### Navigation
- **+ Add Another Goal** → New goal form
- **Continue** → Screen 7 (Completion)
- **Skip goals** → Screen 7
- **Back** → Screen 5

---

## Screen 7: Setup Complete & Dashboard Overview

### Layout
```
┌─────────────────────────────────┐
│                                 │
│         ✓ All Set Up!           │
│                                 │
│    Your Smart Savings account   │
│    is ready to use              │
│                                 │
│    📊 Profile: John Doe (KES)   │
│    💳 Accounts: 2 connected     │
│    📈 Weekly Budget: 5,000 KES  │
│    📅 Monthly Budget: 20,000    │
│    🎯 Savings Goals: 2 active   │
│                                 │
│    [View Dashboard]             │
│    [Take a Tour] (optional)     │
│                                 │
│ 🔒 All your data is encrypted  │
│    and secured by industry      │
│    standard encryption          │
│                                 │
└─────────────────────────────────┘
```

### Actions
- **View Dashboard** → Redirect to Dashboard Screen
- **Take a Tour** → Interactive tutorial (optional)

### Next Step
- User lands on professional dashboard with:
  - Total balance
  - Financial overview
  - Wallets display
  - Recent transactions
  - Quick action buttons

---

# PART 2: POST-SETUP DATA MANAGEMENT

## Daily Usage: Dashboard & Quick Actions

### Dashboard Features After Onboarding

```
┌──────────────────────────────────┐
│ Smart Savings                    │
│ [Profile Avatar]                 │
├──────────────────────────────────┤
│                                  │
│ 👋 Good Morning, John            │
│                                  │
│ ┌────────────────────────────┐  │
│ │ Total Balance              │  │
│ │ KES 127,450.50             │  │
│ │ ↑ 8.5% from last month     │  │
│ └────────────────────────────┘  │
│                                  │
│ 📊 Financial Overview            │
│ ┌──┬──┬──┬──┐                   │
│ │ Income  │ Expenses │          │
│ │ 5,200   │ 2,750    │          │
│ ├──┬──┬──┬──┤                   │
│ │ Balance │ Net      │          │
│ │ 2,450   │ 2,450    │          │
│ └──┴──┴──┴──┘                   │
│                                  │
│ 🏦 Wallets & Accounts            │
│ ┌────────────────────────────┐  │
│ │ 💳 Primary Bank: 8,000     │  │
│ │ 💰 Savings: 4,450.50       │  │
│ │ [+ Add Account]            │  │
│ └────────────────────────────┘  │
│                                  │
│ 📈 Recent Transactions (Last 5)  │
│ • 🍔 Food: -45.50 (Today)       │
│ • 🚗 Gas: -52.00 (Today)        │
│ • 💼 Salary: +2,000 (Today)     │
│ [View All]                       │
│                                  │
│ ┌──┬─────────────┬──┐            │
│ │📊│📝 Budgets│🎯│           │
│ └──┴─────────────┴──┘            │
└──────────────────────────────────┘
```

---

## Manual Expense Entry

### Method 1: Quick Action Button (Dashboard)

```
User clicks "Add Expense" or 
floating action button in top-right

┌──────────────────────────────────┐
│ Quick Add Expense                │
├──────────────────────────────────┤
│                                  │
│ Amount (KES):                    │
│ ┌────────────────────────────┐  │
│ │ [5000_________________]    │  │
│ └────────────────────────────┘  │
│                                  │
│ Category:                        │
│ ┌────────────────────────────┐  │
│ │ 🍔 Food ▼                 │  │
│ │ (Recently used)            │  │
│ └────────────────────────────┘  │
│                                  │
│ From Account:                    │
│ ┌────────────────────────────┐  │
│ │ 💳 Primary Bank ▼         │  │
│ │ (Default account)          │  │
│ └────────────────────────────┘  │
│                                  │
│ Date: [📅 Today]                 │
│ Notes: [Optional notes...]       │
│                                  │
│ [Add Expense]  [More Options]    │
└──────────────────────────────────┘
```

### Method 2: Detailed Expense Entry

Accessed via "More Options" or dedicated Expenses screen:

```
┌──────────────────────────────────┐
│ ⬅ Expenses                       │
│ Add Expense                      │
├──────────────────────────────────┤
│                                  │
│ Amount (KES):                    │
│ ┌────────────────────────────┐  │
│ │ [5000_________________]    │  │
│ └────────────────────────────┘  │
│                                  │
│ Category:                        │
│ ┌────────────────────────────┐  │
│ │ Select Category ▼          │  │
│ │ • Food & Dining            │  │
│ │ • Transport                │  │
│ │ • Entertainment            │  │
│ │ • Utilities                │  │
│ │ • Healthcare               │  │
│ │ • Shopping                 │  │
│ │ • Other                    │  │
│ └────────────────────────────┘  │
│                                  │
│ Description:                     │
│ ┌────────────────────────────┐  │
│ │ Lunch at cafe [____]       │  │
│ └────────────────────────────┘  │
│                                  │
│ From Account:                    │
│ ┌────────────────────────────┐  │
│ │ 💳 Primary Bank ▼         │  │
│ │ 💰 Savings Account         │  │
│ │ 📱 M-Pesa                  │  │
│ │ 💵 Cash Wallet             │  │
│ └────────────────────────────┘  │
│                                  │
│ Date & Time:                     │
│ ┌────────────────────────────┐  │
│ │ 📅 Today  ⏰ 12:45 PM     │  │
│ └────────────────────────────┘  │
│                                  │
│ Receipt/Attachment:              │
│ [📷 Add Photo]  [📎 Attach File] │
│                                  │
│ Tags (Optional):                 │
│ [#work]  [#personal]  [+ Add]    │
│                                  │
│ Recurring:                       │
│ ☐ This is a recurring expense   │
│   └ Frequency: [Weekly ▼]        │
│                                  │
│ [Save Expense]  [Cancel]         │
└──────────────────────────────────┘
```

### Data Validation
- **Amount**: Required, 0.01 - 99,999,999 KES
- **Category**: Required dropdown
- **Account**: Required dropdown (defaults to primary)
- **Date**: Auto-filled with today, user can change
- **Description**: Optional (50-250 chars)

### After Adding Expense
- Confirmation: "✓ Expense added successfully"
- Expense appears in:
  - Dashboard Recent Transactions
  - Expenses dashboard
  - Financial overview updates
  - Budget tracking updates
  - Category breakdown updates

---

## Automatic Transaction Syncing (From Connected Accounts)

### How Syncing Works

```
Timeline:
┌─────────────────────────────────┐
│ User connects bank account      │
│ ├─ OAuth authorization         │
│ ├─ Smart Savings gains access   │
│ └─ Sync initiates               │
│                                 │
│ INITIAL SYNC:                   │
│ Smart Savings retrieves:        │
│ • Last 90 days of transactions  │
│ • Current balance               │
│ • Account metadata              │
│                                 │
│ BACKGROUND SYNC:                │
│ • Daily (2 AM user's time)      │
│ • On-demand (Settings)          │
│ • When user opens app           │
│                                 │
│ DISPLAY:                        │
│ • Transactions appear in list   │
│ • Auto-categorized (ML-based)   │
│ • Marked as "Auto-synced"       │
│ • User can edit/recategorize    │
└─────────────────────────────────┘
```

### Auto-Sync Status Indicator

```
Dashboard Top:
┌──────────────────────────────────┐
│ ⟳ Syncing accounts... (0%)      │
│ Last synced: 2 hours ago        │
│ [⟳ Sync Now]                    │
└──────────────────────────────────┘

Accounts Screen:
┌──────────────────────────────────┐
│ Connected Accounts               │
├──────────────────────────────────┤
│ 💳 Primary Bank                  │
│    ✓ Connected (Auto-sync)      │
│    Last update: 2 hours ago     │
│    Balance: 8,000 KES            │
│    [⟳ Manual Sync] [Settings]    │
│                                  │
│ 📱 M-Pesa                        │
│    ✓ Connected (Auto-sync)      │
│    Last update: 1 hour ago      │
│    Balance: 4,450 KES            │
│    [⟳ Manual Sync] [Settings]    │
│                                  │
│ 💰 Cash Wallet                   │
│    ○ Manual tracking only       │
│    Balance: 2,000 KES (Manual)   │
│    [Edit Balance]                │
└──────────────────────────────────┘
```

### Handling Synced Transactions

```
After sync completes:

📍 In Transactions List:
┌──────────────────────────────────┐
│ • 🚗 Gas Pump -52 (2pm)        │
│   Auto-synced from Primary Bank  │
│   📌 Category: Transport         │
│   [Edit] [Recategorize]          │
│                                  │
│ • 🛒 Supermarket -145 (11am)   │
│   Auto-synced from Primary Bank  │
│   📌 Category: Shopping          │
│   [Edit] [Recategorize]          │
│                                  │
│ • 🍔 Cafe -45 (8am)            │
│   Manual entry                   │
│   📌 Category: Food              │
│   [Edit]                         │
└──────────────────────────────────┘

User can:
✓ View auto-categorized amounts
✓ Recategorize if wrong
✓ Add notes/tags
✓ Merge duplicate entries
✓ Mark as excluded (non-personal)
✓ Edit transaction details
```

### Sync Errors & Retry Logic

```
If sync fails:

┌──────────────────────────────────┐
│ ⚠ Sync Failed                   │
├──────────────────────────────────┤
│                                  │
│ We couldn't connect to          │
│ Primary Bank account.            │
│                                  │
│ Possible reasons:                │
│ • Bank temporarily unavailable   │
│ • Authentication expired         │
│ • Network connection issue       │
│                                  │
│ [Retry Now] [Re-authorize]       │
│                                  │
│ Last successful sync:            │
│ Yesterday at 2:15 AM             │
└──────────────────────────────────┘

Auto-retry:
• Retry in 30 minutes
• Retry again in 2 hours
• Notify user if critical
```

---

## Editing & Managing Expenses

### Edit Existing Expense

```
User clicks transaction → Details popup:

┌──────────────────────────────────┐
│ Transaction Details              │
├──────────────────────────────────┤
│                                  │
│ 🚗 Gas Pump                      │
│ Amount: KES 52.00                │
│ Date: Jan 28, 2:15 PM            │
│ Category: Transport              │
│ Account: Primary Bank            │
│ Status: Auto-synced              │
│ Reference: #BNK2847392           │
│                                  │
│ [Edit Transaction] [Delete]      │
│ [View Receipt] [Add Note]        │
│                                  │
│ 💡 Suggest for bulk edit:       │
│    Edit similar transactions     │
└──────────────────────────────────┘

Tap "Edit Transaction":

┌──────────────────────────────────┐
│ Edit Transaction                 │
├──────────────────────────────────┤
│ Amount: [52________]             │
│ Category: [Transport ▼]          │
│ Description: [Gas pump___]       │
│ Date: [📅 Jan 28]                │
│ Notes: [________________]        │
│                                  │
│ [Save Changes]  [Cancel]         │
└──────────────────────────────────┘
```

### Delete Expense

```
Confirmation dialog:

┌──────────────────────────────────┐
│ Delete Transaction?              │
├──────────────────────────────────┤
│                                  │
│ 🚗 Gas Pump - KES 52.00         │
│ Jan 28 at 2:15 PM                │
│                                  │
│ This action cannot be undone.    │
│                                  │
│ [Delete]  [Cancel]               │
└──────────────────────────────────┘
```

### Bulk Edit & Recategorization

```
Expenses Dashboard:

┌──────────────────────────────────┐
│ [Filter] [Sort] [⋯ More]         │
├──────────────────────────────────┤
│                                  │
│ ☐ 🚗 Gas -52 (Today)           │
│ ☐ 🍔 Food -45 (Today)          │
│ ☐ 📱 Utilities -85 (Today)      │
│ ☐ 🛍️ Shopping -120 (Today)      │
│                                  │
│ [Selected: 0]                    │
│ [Recategorize] [Delete] [Export]│
└──────────────────────────────────┘
```

---

# PART 3: SETTINGS & ACCOUNT MANAGEMENT

## Settings Architecture

```
┌──────────────────────────────────┐
│ Settings (Gear Icon)             │
├──────────────────────────────────┤
│                                  │
│ PROFILE & GENERAL                │
│ • Profile Settings               │
│ • Currency Settings              │
│ • Language                       │
│ • Time Zone                      │
│                                  │
│ ACCOUNTS & SYNC                  │
│ • Connected Accounts             │
│ • Manual Account Sync            │
│ • Bank Authorization             │
│ • M-Pesa Connection              │
│                                  │
│ BUDGET & GOALS                   │
│ • Update Weekly Budget           │
│ • Update Monthly Budget          │
│ • Edit Savings Goals             │
│ • Add New Goals                  │
│                                  │
│ NOTIFICATIONS                    │
│ • Budget Alerts                  │
│ • Goal Progress                  │
│ • Transaction Notifications      │
│ • Weekly Reports                 │
│                                  │
│ SECURITY & PRIVACY               │
│ • Change Password                │
│ • Two-Factor Authentication      │
│ • Privacy Policy                 │
│ • Data Export                    │
│ • Delete Account                 │
│                                  │
│ ABOUT                            │
│ • App Version                    │
│ • Help & Support                 │
│ • Feedback                       │
│ • Terms of Service               │
└──────────────────────────────────┘
```

---

## 3.1 Accounts Management Screen

### Layout & Features

```
┌──────────────────────────────────┐
│ ⬅ Settings                       │
│ Accounts                         │
├──────────────────────────────────┤
│                                  │
│ CONNECTED ACCOUNTS               │
│ (Auto-synced daily)              │
│                                  │
│ 💳 Primary Bank                  │
│    Balance: 8,000 KES            │
│    Last sync: 2 hours ago        │
│    ✓ Auto-sync enabled           │
│    [⟳ Sync Now] [⋯]             │
│                                  │
│ 📱 M-Pesa                        │
│    Balance: 4,450 KES            │
│    Last sync: 1 hour ago         │
│    ✓ Auto-sync enabled           │
│    [⟳ Sync Now] [⋯]             │
│                                  │
│ ────────────────────────────────  │
│                                  │
│ MANUAL ACCOUNTS                  │
│ (No auto-sync)                   │
│                                  │
│ 💰 Cash Wallet                   │
│    Balance: 2,000 KES (Manual)   │
│    Last updated: Today at 10am   │
│    [Edit Balance] [⋯]            │
│                                  │
│ ────────────────────────────────  │
│                                  │
│ [+ Add New Account]              │
│   • Connect Bank                 │
│   • Connect M-Pesa               │
│   • Manual Account               │
│                                  │
│ 🔐 Your accounts are encrypted   │
│    and secured                   │
└──────────────────────────────────┘
```

### Account Options Menu

```
Tap [⋯] on any account:

┌──────────────────────────────────┐
│ Primary Bank Options             │
├──────────────────────────────────┤
│ ⟳ Manual Sync Now                │
│ 🔐 Re-authorize Account          │
│ ✎ Edit Account Name              │
│ ⚙ Sync Settings                  │
│ 🚫 Disconnect Account            │
│ ℹ View Account Details           │
└──────────────────────────────────┘

"Disconnect Account" confirmation:
┌──────────────────────────────────┐
│ Disconnect Primary Bank?         │
├──────────────────────────────────┤
│ • Previous transactions retained │
│ • Auto-sync will stop            │
│ • Can reconnect anytime          │
│                                  │
│ [Disconnect]  [Cancel]           │
└──────────────────────────────────┘
```

### Add New Account Flow

```
Screen 1: Account Type Selection
┌──────────────────────────────────┐
│ Add Account                      │
├──────────────────────────────────┤
│                                  │
│ What type of account?            │
│                                  │
│ ☐ 💳 Bank Account                │
│   (OAuth connection)             │
│   ✓ Auto-sync available          │
│                                  │
│ ☐ 📱 Mobile Money (M-Pesa)       │
│   (Phone verification)           │
│   ✓ Auto-sync available          │
│                                  │
│ ☐ 💰 Cash / Manual Account       │
│   (Manual entry only)            │
│   ○ No auto-sync                 │
│                                  │
│ ☐ 💳 Credit Card                 │
│   (Manual entry)                 │
│   ○ No auto-sync                 │
│                                  │
│ ☐ 🏦 Savings Account              │
│   (Manual or connected)          │
│   ✓ Auto-sync if connected       │
└──────────────────────────────────┘

Screen 2: Connection (varies by type)
[Follows same flows as Onboarding Screen 3]
```

---

## 3.2 Budget Management

### Edit Weekly Budget

```
Settings → Budget & Goals
         → Edit Weekly Budget

┌──────────────────────────────────┐
│ Weekly Budget                    │
├──────────────────────────────────┤
│                                  │
│ Current Budget: KES 5,000        │
│ Weekly Spending Pace:            │
│                                  │
│ ┌────────────────────────────┐  │
│ │ Mon Tue Wed Thu Fri Sat Sun│  │
│ │ 500 600 800 700 600 400   0 │  │
│ │ Avg: ~670/day              │  │
│ └────────────────────────────┘  │
│                                  │
│ Suggested New Budget:            │
│ KES 4,500 (based on 4-week avg) │
│                                  │
│ Set New Budget:                  │
│ ┌────────────────────────────┐  │
│ │ [5000__________]           │  │
│ └────────────────────────────┘  │
│                                  │
│ Alerts:                          │
│ ☑ Notify at 80% spent           │
│ ☑ Notify at 100% spent          │
│                                  │
│ [Save Changes] [Reset to 5000]   │
└──────────────────────────────────┘
```

### Edit Monthly Budget

```
Settings → Budget & Goals
         → Edit Monthly Budget

┌──────────────────────────────────┐
│ Monthly Budget                   │
├──────────────────────────────────┤
│                                  │
│ Current Budget: KES 20,000       │
│ Monthly Spending Pattern:        │
│                                  │
│ ┌────────────────────────────┐  │
│ │ Week 1: 4,500 (90%)        │  │
│ │ Week 2: 5,200 (104%)       │  │
│ │ Week 3: 4,800 (96%)        │  │
│ │ Week 4: 5,100 (102%)       │  │
│ │ Month: 19,600 (98%) ✓      │  │
│ └────────────────────────────┘  │
│                                  │
│ Set New Budget:                  │
│ ┌────────────────────────────┐  │
│ │ [20000_________]           │  │
│ │ ~4,651 per week            │  │
│ └────────────────────────────┘  │
│                                  │
│ Alerts:                          │
│ ☑ Weekly summary (Sundays)      │
│ ☑ Monthly report (1st of month) │
│                                  │
│ [Save Changes]                   │
└──────────────────────────────────┘
```

---

## 3.3 Savings Goals Management

### View & Edit Goals

```
Settings → Budget & Goals
         → Savings Goals

┌──────────────────────────────────┐
│ Savings Goals                    │
├──────────────────────────────────┤
│                                  │
│ Goal 1: 🚨 Emergency Fund       │
│ Target: KES 50,000               │
│ Current: KES 12,500 (25%)        │
│ Target Date: Dec 31, 2026        │
│ Monthly Contribution: KES 2,000  │
│ Progress: ████░░░░░░            │
│ [Edit] [Pause] [Delete]          │
│                                  │
│ Goal 2: 🏠 Home Down Payment    │
│ Target: KES 500,000              │
│ Current: KES 45,000 (9%)         │
│ Target Date: Mar 31, 2027        │
│ Monthly Contribution: KES 12,500 │
│ Progress: █░░░░░░░░░            │
│ [Edit] [Pause] [Delete]          │
│                                  │
│ [+ Add New Goal]                 │
│                                  │
│ 💡 On track! Keep it up! 🎉     │
└──────────────────────────────────┘

Tap "Edit" on goal:

┌──────────────────────────────────┐
│ Edit Goal                        │
├──────────────────────────────────┤
│                                  │
│ Goal Name: [Emergency Fund__]    │
│                                  │
│ Icon: [🚨 ▼] (Change icon)      │
│                                  │
│ Target Amount: [50000______]    │
│                                  │
│ Target Date: [📅 Dec 31, 2026]  │
│                                  │
│ Monthly Contribution:            │
│ [2000__________] (Auto-calc)    │
│                                  │
│ Priority: [Medium ▼]             │
│ (Affects notification frequency) │
│                                  │
│ [Save Changes] [Cancel]          │
└──────────────────────────────────┘
```

### Goal Progress Tracking

```
Goal Details Screen:

┌──────────────────────────────────┐
│ 🚨 Emergency Fund                │
├──────────────────────────────────┤
│                                  │
│ KES 12,500 / 50,000 (25%)        │
│ ████░░░░░░░░░░░░░░░░           │
│                                  │
│ Still need: KES 37,500           │
│ Months left: 18 months           │
│ Monthly target: KES 2,083        │
│                                  │
│ Timeline:                        │
│ • Created: Jan 1, 2025           │
│ • Months active: 1 month         │
│ • Progress: On track (100%)      │
│ • Next checkpoint: Feb 1         │
│                                  │
│ Recent Contributions:            │
│ • Jan 28: +2,000 (Manual)        │
│ • Jan 21: +2,000 (Manual)        │
│ • Jan 14: +2,000 (Manual)        │
│ • Jan 7: +2,500 (Manual)         │
│ • Jan 1: +4,000 (Manual)         │
│                                  │
│ [Edit Goal] [Pause] [Delete]     │
│ [Contribute Now] [View History]  │
└──────────────────────────────────┘
```

### Add New Goal

```
Settings → Budget & Goals → Add Goal

┌──────────────────────────────────┐
│ Create Savings Goal              │
├──────────────────────────────────┤
│                                  │
│ Goal Template:                   │
│ ☐ 🚨 Emergency Fund              │
│ ☐ 🏠 Home Down Payment           │
│ ☐ 🎓 Education                   │
│ ☐ 🚗 Car                         │
│ ☐ 🎉 Vacation                    │
│ ⦿ ✨ Custom Goal                 │
│                                  │
│ Goal Name:                       │
│ [New Goal____________]           │
│                                  │
│ Icon: [✨ ▼]                     │
│                                  │
│ Target Amount (KES):             │
│ [________________]               │
│                                  │
│ Target Date:                     │
│ [📅 Select date]                 │
│                                  │
│ Auto-calculate Monthly Amount?   │
│ ☑ Yes (recommended)              │
│ ○ Set manually                   │
│   Monthly: [________________]    │
│                                  │
│ [Create Goal] [Cancel]           │
└──────────────────────────────────┘
```

---

# PART 4: UX PRINCIPLES & BEST PRACTICES

## Core UX Principles

### 1. Progressive Disclosure
✓ Show only what's necessary at each stage
✓ Optional features available but not forced
✓ Advanced options in Settings, not main flow
✓ Beginner → Intermediate → Advanced features

### 2. One Primary Action Per Screen
✓ Clear, obvious CTA (button)
✓ Secondary CTAs de-emphasized
✓ Skip options for non-critical steps
✓ No more than 2 major input sections per screen

### 3. Reassurance & Transparency
✓ Explain why we need information
✓ Show data is encrypted/secure
✓ Display clear confirmation after actions
✓ Provide rollback/undo options

### 4. Beginner-Friendly Language
✓ No financial jargon without explanation
✓ Use metaphors and analogies
✓ Include helpful tooltips (💡 icons)
✓ Avoid technical terms

### 5. Smart Suggestions
✓ Pre-fill with sensible defaults
✓ Show calculations in real-time
✓ Suggest based on user data
✓ Allow manual override

### 6. Visual Hierarchy
✓ Primary action: Bold, bright color (Purple #7C3AED)
✓ Secondary action: Outline style
✓ Tertiary: Text links or small buttons
✓ Disabled: Gray, reduced opacity

---

## Design Specifications

### Color Coding
```
Financial Status:
✓ Income/Positive: Green (#10B981)
✗ Expense/Negative: Red (#EF5350) or Orange (#FF6B35)
⚠ Warning/Budget exceeded: Orange (#FF6B35)
ℹ Information: Blue (#3B82F6)
● Primary action: Purple (#7C3AED)
● Secondary: Pink (#EC4899)

Budget Status:
0-50% spent: Green ✓
50-80% spent: Yellow ⚠
80-100% spent: Orange ⚠
100%+ spent: Red ✗
```

### Typography Hierarchy
```
Title/Hero: 24px, Bold (Font weight 800)
Subheading: 18px, Bold (Font weight 700)
Body text: 14px, Regular (Font weight 500)
Small text: 12px, Regular (Font weight 400)
Caption: 11px, Regular (Font weight 400)

Input fields: 14px, Medium, with placeholder text
Buttons: 16px, Bold, all-caps or sentence case
```

### Spacing & Padding
```
Screen margins: 16-24px
Section spacing: 24-32px
Component spacing: 12-16px
Input field height: 48-52px
Button height: 48-56px
Border radius: 8-12px (rounded)
```

### Interactive Elements
```
Buttons:
Primary: Full-width, purple background, white text, 48px height
Secondary: Full-width outline, purple border, purple text, 48px height
Tertiary: Text link, no background, underline on hover

Inputs:
Height: 48px
Padding: 12px horizontal
Border: 1px solid #E5E7EB
Focus: 2px border #7C3AED, shadow
Filled background: #F5F5FB

Sliders:
Track: 4px height
Thumb: 24px diameter, purple
Range: Visual feedback on drag
```

---

## Mobile-First Responsive Design

### Breakpoints
```
Mobile: < 600px
Tablet: 600px - 1024px
Desktop: > 1024px

Mobile Layout:
- Single column
- Full-width buttons
- Bottom sheet for modals
- Hamburger menu for settings

Tablet Layout:
- Two columns where appropriate
- Wider content area
- Side navigation possible

Desktop Layout:
- Multi-column dashboard
- Sidebar navigation
- Expanded forms
```

---

## Accessibility Standards

✓ WCAG 2.1 Level AA compliance
✓ Minimum color contrast ratio: 4.5:1
✓ Touch targets: Minimum 44x44px
✓ Keyboard navigation support
✓ Screen reader compatible (alt text for all images)
✓ Clear focus indicators
✓ Semantic HTML structure

---

## Error Handling & Validation

### Input Validation
```
Real-time validation:
✓ Show error icon when invalid
✓ Display error message below input
✓ Enable button only when form valid
✓ Clear error when user corrects

Error message tone:
- Helpful, not accusatory
- Explain what's wrong
- Suggest how to fix it
- Example: "Amount must be at least KES 100"
```

### Network Errors
```
Offline:
✓ Show offline banner at top
✓ Allow offline features (local entry)
✓ Queue actions for sync when online
✓ Sync notification when reconnected

API Errors:
✓ Show friendly error message
✓ Provide retry option
✓ Log technical details for support
✓ Offer contact support link
```

---

# PART 5: NOTIFICATION STRATEGY

## Notification Types & Frequency

### Budget Alerts (Opt-in)
```
80% Budget Reached:
"You've spent KES 4,000 of your KES 5,000
weekly budget. Slow down to stay on track! 💡"
[View Budget] [Dismiss]

100% Budget Reached:
"You've reached your KES 5,000 weekly
budget. Do you want to adjust it or continue
tracking overspending?"
[Adjust Budget] [Continue] [Dismiss]
```

### Goal Progress (Opt-in)
```
Weekly Reminder:
"Great! You're on track with your Emergency
Fund goal. KES 12,500 saved so far. 
Keep it up! 🎯"
[View Goal] [Dismiss]

Milestone Achieved:
"Congratulations! 🎉 You've reached 50%
of your Emergency Fund goal (KES 25,000).
You're halfway there!"
[View Goal] [Share] [Dismiss]
```

### Account Sync (System)
```
Sync Complete:
"✓ Your accounts were synced successfully.
KES 2,450 in new transactions added."
[View Transactions] [Dismiss]

Sync Failed:
"⚠ We couldn't sync your Primary Bank
account. Tap to re-authorize."
[Re-authorize] [Later]
```

### Weekly/Monthly Reports (Opt-in)
```
Weekly Summary (Every Sunday 9 AM):
"📊 Your Weekly Summary:
Total Spending: KES 4,800
Budget Used: 96%
Categories: Food (45%), Transport (30%)
[View Full Report]"

Monthly Report (1st of Month):
"📈 Your January Summary:
Income: KES 20,000
Expenses: KES 18,500
Savings: KES 1,500 ✓
Goals Progress: On Track 🎯
[View Full Report]"
```

---

# PART 6: DATA SECURITY & PRIVACY

## Security Measures

### During Setup
✓ All connections use OAuth 2.0 (bank account)
✓ M-Pesa verification via SMS OTP
✓ No passwords transmitted to our servers
✓ Data encrypted in transit (TLS 1.3)

### After Setup
✓ All user data encrypted at rest (AES-256)
✓ Regular security audits
✓ Compliance with local data protection laws
✓ No data shared with 3rd parties without consent
✓ User can delete account and all data anytime

### User Controls
```
Settings → Security & Privacy

┌──────────────────────────────────┐
│ Security & Privacy               │
├──────────────────────────────────┤
│                                  │
│ AUTHENTICATION                   │
│ • Change Password                │
│ • Two-Factor Authentication      │
│   ☑ Enabled                      │
│   └ ⟳ Re-setup 2FA               │
│ • Sign out all devices           │
│ • View active sessions           │
│                                  │
│ PRIVACY                          │
│ • View your data                 │
│ • Export data as CSV/JSON        │
│ • Privacy policy                 │
│ • Terms of service               │
│                                  │
│ DATA MANAGEMENT                  │
│ • Delete specific transactions   │
│ • Clear sync history             │
│ • Factory reset app data         │
│                                  │
│ DANGER ZONE                      │
│ • Delete account permanently     │
│   (All data removed in 30 days)  │
│                                  │
└──────────────────────────────────┘
```

---

# PART 7: IMPLEMENTATION CHECKLIST

## Onboarding Implementation
- [ ] Welcome screen with Sign In/Sign Up
- [ ] Profile setup (Name, Currency)
- [ ] Account connection flow (Bank, M-Pesa, Cash)
- [ ] Weekly budget setup with slider
- [ ] Monthly budget setup
- [ ] Savings goals creation
- [ ] Setup completion screen
- [ ] Progress indicators (Step X of 5)
- [ ] Skip options for optional screens
- [ ] Input validation and error handling
- [ ] Confirmation dialogs for critical actions

## Dashboard Implementation
- [ ] Load user profile and preferences
- [ ] Display total balance
- [ ] Financial overview (4-card grid)
- [ ] Wallets/accounts section
- [ ] Recent transactions list
- [ ] Budget progress indicator
- [ ] Quick action buttons
- [ ] Navigation tabs

## Expense Management
- [ ] Quick add expense modal
- [ ] Detailed expense form
- [ ] Category selection dropdown
- [ ] Account selection dropdown
- [ ] Date/time picker
- [ ] Receipt attachment
- [ ] Edit expense functionality
- [ ] Delete expense with confirmation
- [ ] Bulk edit operations
- [ ] Duplicate detection

## Auto-Sync Implementation
- [ ] OAuth integration for banks
- [ ] M-Pesa SMS verification
- [ ] Background sync service
- [ ] Transaction categorization (ML)
- [ ] Duplicate transaction detection
- [ ] Balance reconciliation
- [ ] Sync status indicators
- [ ] Manual sync trigger
- [ ] Error handling and retry logic

## Settings Implementation
- [ ] Profile settings screen
- [ ] Accounts management
- [ ] Budget adjustment
- [ ] Savings goals CRUD
- [ ] Notification preferences
- [ ] Security settings
- [ ] Data export/import
- [ ] Account deletion flow

## Testing Checklist
- [ ] Unit tests for validation logic
- [ ] Integration tests for API calls
- [ ] End-to-end tests for onboarding flow
- [ ] Performance testing (load times)
- [ ] Accessibility testing (WCAG 2.1 AA)
- [ ] Mobile responsiveness testing
- [ ] Offline functionality testing
- [ ] Security penetration testing
- [ ] User acceptance testing (UAT)

---

# CONCLUSION

This specification defines a **progressive, beginner-friendly financial data input and management flow** that:

✓ Guides new users through essential setup in 5-7 screens
✓ Avoids overwhelming users with too many options
✓ Provides smart defaults and suggestions
✓ Enables manual and automatic data entry
✓ Maintains flexibility through post-setup management
✓ Follows professional fintech UX best practices
✓ Meets App Store requirements and standards
✓ Prioritizes security and privacy
✓ Delivers a seamless, reassuring user experience

The flow balances **simplicity with functionality**, ensuring users can quickly get started while retaining full control over their financial data.
