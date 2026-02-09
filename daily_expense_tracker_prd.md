# PRODUCT REQUIREMENTS DOCUMENT
# Daily Expense Tracker

**Version 1.0** | **Date: January 28, 2026**

---

## 📋 EXECUTIVE SUMMARY

### Product Overview
Daily Expense Tracker is a privacy-first, offline-only expense logging app designed for maximum daily engagement and ads-based monetization. The app enables users to log expenses in under 3 seconds without any signup, login, or internet connection. This is part of a 50-app portfolio strategy targeting aggregate DAU and ad revenue.

**Core Value Proposition:**
- Log expenses faster than opening a notes app
- 100% offline, 100% private (no cloud, no accounts)
- Habit-forming daily streaks and gentle reminders
- Multi-language, multi-currency for global reach

### Key Success Metrics
- **DAU/MAU ratio:** > 35%
- **Expense logging time:** < 3 seconds (from app open to saved)
- **App launch time:** < 2 seconds cold start
- **App size:** < 10 MB
- **Crash-free sessions:** > 99.5%
- **Ad retention impact:** Ads must NOT degrade D1/D7/D30 retention by >5%

### Target Persona (SINGLE, FOCUSED)
**Daily cash-spending individual who values privacy and simplicity**

Examples:
- Students tracking daily spending
- Gig workers managing cash flow
- Small shop owners logging transactions
- Users in cash-heavy economies
- Privacy-conscious users avoiding bank-linked apps

**Age range:** 18–45  
**Geography:** Global (not region-specific)

---

## 🎯 PRODUCT PHILOSOPHY & CONSTRAINTS

### What This App IS
✅ Daily habit tracker for expenses  
✅ Offline-first, privacy-first  
✅ Fast, boring, reliable  
✅ Ads-monetized utility tool  
✅ Portfolio component (not standalone hero app)

### What This App IS NOT
❌ Premium finance app  
❌ Budgeting tool  
❌ Wealth tracker  
❌ Bank-synced app  
❌ Social or collaborative tool

### Explicitly Excluded Features
**DO NOT ADD:**
- Budgets or spending limits
- Bank sync or account linking
- Login / user profiles
- Cloud backup or sync
- Advanced charts or visualizations
- AI insights or predictions
- Subscriptions
- Receipt scanning
- Bill reminders
- Debt tracking

---

## 💰 MONETIZATION STRATEGY (LOCKED)

### Primary Revenue
1. **Banner Ads** (baseline revenue)
   - Allowed on: Today, History, Insights screens
   - NOT allowed on: Add Expense screen
   
2. **Rewarded Video Ads** (main revenue driver)
   - Monthly Summary: unlock detailed breakdown
   - Export CSV/PDF: reward unlock
   - High-intent, user-initiated only

### Secondary Revenue
3. **One-Time Purchase: "Remove Ads + Convenience"** ($2.99–$4.99)
   - Removes all banner ads
   - Unlocks unlimited exports
   - Unlocks Monthly Summary permanently
   - NO recurring subscription

### Monetization Rules
- Ads must NEVER block core actions (adding expenses)
- Rewarded ads = user choice, not forced
- Free tier must remain genuinely useful
- Ad load times must not impact performance metrics

---

## 📱 SCREEN-BY-SCREEN SPECIFICATIONS

### Screen 1: TODAY (Home Screen)

**Purpose:**  
Primary landing screen. Shows today's spending at a glance, quick expense/income toggle, recent transaction history, and primary CTAs to add new entries.

**Layout Structure:**
```
┌─────────────────────────────────┐
│  App Bar: "Today" + Settings   │
├─────────────────────────────────┤
│  Toggle: [Expense] | Income     │
├─────────────────────────────────┤
│  TODAY'S TOTAL CARD             │
│  ┌───────────────────────────┐  │
│  │ $247.50                   │  │
│  │ 8 expenses                │  │
│  │ ↑ $15 more than yesterday │  │
│  └───────────────────────────┘  │
├─────────────────────────────────┤
│  RECENT TRANSACTIONS            │
│  ┌─────────────────────────┐    │
│  │ Coffee • $4.50 • 9:30am │    │
│  │ Lunch • $12.00 • 1:15pm │    │
│  │ Groceries • $45 • 6:20pm│    │
│  └─────────────────────────┘    │
│                                 │
│  [View All History →]           │
├─────────────────────────────────┤
│  BANNER AD (optional)           │
├─────────────────────────────────┤
│  FLOATING ACTION BUTTON (+)     │
└─────────────────────────────────┘
```

**Components:**
- **App Bar:** Fixed top, elevation 2, logo + "Today" title + settings icon
- **Expense/Income Toggle:** Segmented control, smooth animation
- **Today's Total Card:**
  - Large monospace amount display (SF Mono, 32pt)
  - Expense count subtitle
  - Yesterday comparison (with ↑↓ indicator, green/red tint)
  - Tap → Navigate to Monthly Summary (free preview)
- **Recent Transactions List:**
  - Show last 5 entries
  - Each row: Category icon + name • amount • time
  - Tap row → Edit expense bottom sheet
- **View All History CTA:** Secondary button
- **Banner Ad:** 50pt height, bottom-aligned (above FAB), skippable after 5s
- **FAB (Floating Action Button):** 56pt diameter, `#2A9D8F`, "+" icon, bottom-right corner

**User Actions:**
1. Tap "+" FAB → Navigate to Add Expense screen
2. Tap expense row → Open Edit Expense bottom sheet
3. Tap "View All History" → Navigate to Expense History screen
4. Tap Today's Total Card → Navigate to Monthly Summary screen (preview/paywall)
5. Toggle Expense/Income → Switch view (animated)
6. Tap Settings icon → Navigate to Settings screen

**Navigation:**
- From: App launch (default screen)
- To: Add Expense, History, Monthly Summary, Settings

**States:**
- **Empty State (Day 1):**
  - Show friendly onboarding: "Start logging your first expense!"
  - Illustration: Simple coin/wallet icon
  - CTA: "Add Your First Expense"
- **Loading State:** Skeleton UI for cards (200ms)
- **Error State:** Rare (offline app), only if DB corruption

**Edge Cases:**
- No expenses today → Show $0.00, "0 expenses"
- Income-only day → Show income total
- Midnight rollover → Refresh "today" automatically
- First-time user → Show brief tooltip on FAB ("Tap here to add expense")

**AI Screen Generation Prompt:**
```
Create a mobile app screen for an offline expense tracker called "Today" (home screen). 

Design Style: Clean, calming, premium aesthetic inspired by Apple and Airbnb. Use a soft cream background (#F4F1E8) with deep blue (#1E3A5F) and teal (#2A9D8F) accents.

Layout:
- Top app bar with "Today" title (SF Pro Display Bold 24pt) and a settings gear icon (top-right)
- Below app bar: Segmented toggle "Expense | Income" (Expense selected, teal background)
- Main card (16pt border radius, subtle shadow): Display today's total spend "$247.50" in large monospace font (SF Mono Bold 32pt, deep blue). Below it: "8 expenses" (caption, gray), and "↑ $15 more than yesterday" (small text with red up arrow)
- Section header "Recent" (SF Pro Semibold 18pt, charcoal)
- List of 3 recent transactions, each row: Category icon (24x24) + "Coffee • $4.50 • 9:30am" (Inter 16pt), rows have 12pt padding
- Text button "View All History →" (teal text)
- Bottom: 50pt tall placeholder for banner ad (light gray box)
- Bottom-right: Floating circular teal button (56pt) with white "+" icon

Typography: Use Inter for body text, SF Pro Display for headers, SF Mono for amounts. Ensure visual hierarchy with font size and weight.

Colors: Cream background, deep blue text, teal accents, soft gray for secondary text. Portrait mobile screen (375x812pt). Add subtle micro-interactions like button press states.
```

---

### Screen 2: ADD EXPENSE

**Purpose:**  
Fastest possible expense entry. User should be able to log an expense in under 3 seconds (amount, category, save). This is the CORE interaction—must be frictionless.

**Layout Structure:**
```
┌─────────────────────────────────┐
│  ← Back • "Add Expense"         │
├─────────────────────────────────┤
│                                 │
│  AMOUNT INPUT (auto-focus)      │
│  ┌─────────────────────────┐    │
│  │  $  [___________]       │    │
│  └─────────────────────────┘    │
│                                 │
│  CATEGORY SELECTOR              │
│  ┌─┬─┬─┬─┬─┬─┐                  │
│  │🍔│🚗│🏠│🎮│💊│➕│              │
│  └─┴─┴─┴─┴─┴─┘                  │
│  Food, Transport, Home, etc.    │
│                                 │
│  OPTIONAL NOTE                  │
│  ┌─────────────────────────┐    │
│  │ Add note (optional)     │    │
│  └─────────────────────────┘    │
│                                 │
│  [Save Expense] (full-width)    │
│                                 │
│  ❌ NO ADS ON THIS SCREEN       │
└─────────────────────────────────┘
```

**Components:**
- **App Bar:** Back button + "Add Expense" title
- **Amount Input:**
  - Large text field, currency symbol prefix (based on settings)
  - Numeric keyboard auto-opens
  - Monospace font (SF Mono, 28pt)
  - Placeholder: "0.00"
  - Auto-focus on screen load
- **Category Selector:**
  - Horizontal scrollable grid (2 rows if needed)
  - Default 6 categories: Food, Transport, Home, Entertainment, Health, Other
  - Each: 56x56pt circular button, emoji icon, label below (12pt)
  - Selected state: teal border + scale 1.1
  - "+" button to add custom category
- **Optional Note Field:**
  - Single-line text input
  - Placeholder: "Add note (optional)"
  - Not required, minimize friction
- **Save Button:**
  - Primary button (full-width)
  - Text: "Save Expense"
  - Enabled only when amount > 0 and category selected

**User Actions:**
1. Enter amount → Numeric keyboard
2. Select category → Tap icon
3. (Optional) Add note → Tap field, type
4. Tap "Save Expense" → Save to local DB, show success toast, navigate back to Today screen
5. Tap "+" on category row → Open "Add Custom Category" bottom sheet

**Navigation:**
- From: Today screen (FAB), History screen (edit), Quick Action
- To: Today screen (after save)

**States:**
- **Default:** Amount input focused, keyboard open
- **Validation Error:** "Amount must be greater than 0" (red text below input)
- **Saving:** Button shows spinner (200ms)
- **Success:** Toast: "Expense saved ✓", navigate back

**Edge Cases:**
- User taps Save without amount → Show validation error
- User taps Save without category → Auto-select "Other"
- User exits without saving → Show "Discard expense?" confirmation dialog
- Duplicate rapid saves → Debounce save button (prevent double-tap)

**Performance Requirements:**
- Screen render: < 200ms
- Save action: < 100ms (local DB write)
- Keyboard open: < 150ms

**AI Screen Generation Prompt:**
```
Create a mobile app screen for "Add Expense" in an offline expense tracker.

Design Style: Ultra-clean, minimal, fast. Cream background (#F4F1E8), teal accents (#2A9D8F).

Layout:
- Top bar: Back arrow (left) + "Add Expense" (SF Pro Display Semibold 20pt)
- Large amount input field centered near top: "$" prefix (gray) + input box (SF Mono 28pt, deep blue text, teal border when focused), placeholder "0.00"
- Below input: "Category" label (SF Pro Medium 14pt, gray)
- Horizontal row of 6 circular category buttons (56x56pt each): 🍔 Food, 🚗 Transport, 🏠 Home, 🎮 Fun, 💊 Health, ➕ Add. Each has icon (24pt emoji) and label below (Inter 12pt). Selected category has teal border (2pt) and slight scale.
- Below categories: Optional note input (single-line, 48pt height, light border, placeholder "Add note (optional)")
- Bottom: Full-width primary button "Save Expense" (teal background, white text, 48pt height, 12pt border radius)

Typography: SF Mono for amount, Inter for body, SF Pro Display for headers.
Colors: Cream bg, deep blue text, teal accents, soft gray for placeholders.
Portrait mobile (375x812pt). Ensure numeric keyboard overlays bottom half (simulate in design).
```

---

### Screen 3: EXPENSE HISTORY

**Purpose:**  
Chronological list of all logged expenses and income. Users can search, filter by category, edit, or delete entries. This is the "ledger" view.

**Layout Structure:**
```
┌─────────────────────────────────┐
│  ← Back • "History"             │
├─────────────────────────────────┤
│  [Search...] 🔍  [Filter] 🎛️   │
├─────────────────────────────────┤
│  TODAY                          │
│  ┌─────────────────────────┐    │
│  │ 🍔 Lunch  $12.00  1:15pm│    │
│  │ ☕ Coffee  $4.50  9:30am │    │
│  └─────────────────────────┘    │
│  YESTERDAY                      │
│  ┌─────────────────────────┐    │
│  │ 🚗 Uber  $18.00  7:45pm │    │
│  └─────────────────────────┘    │
│  ...                            │
├─────────────────────────────────┤
│  BANNER AD (bottom)             │
└─────────────────────────────────┘
```

**Components:**
- **App Bar:** Back + "History" title + optional "Export" icon
- **Search Bar:** Magnifying glass icon, placeholder "Search expenses...", real-time filter
- **Filter Button:** Opens bottom sheet with category checkboxes
- **Grouped List:**
  - Grouped by date (Today, Yesterday, Jan 27, Jan 26, etc.)
  - Each entry: Category icon + name + amount (right-aligned) + time (caption)
  - Swipe-to-delete gesture (iOS style)
  - Tap row → Open Edit bottom sheet
- **Banner Ad:** 50pt height, bottom-pinned

**User Actions:**
1. Tap search bar → Focus, show keyboard, filter list in real-time
2. Tap filter icon → Open category filter bottom sheet
3. Tap expense row → Open Edit Expense bottom sheet
4. Swipe left on row → Reveal "Delete" button (red)
5. Tap "Delete" → Confirm dialog → Delete from DB, remove from list

**Navigation:**
- From: Today screen ("View All History"), Bottom nav
- To: Edit Expense (bottom sheet), Add Expense (FAB)

**States:**
- **Empty State:** "No expenses yet. Start by tapping the + button!"
- **Search No Results:** "No expenses match your search"
- **Loading:** Skeleton list items (first render)

**Edge Cases:**
- 1000+ entries → Lazy load (paginate, load 50 at a time)
- Filter returns 0 results → "No expenses in selected categories"
- Delete last expense of a day → Remove date header

**AI Screen Generation Prompt:**
```
Create a mobile app screen for "Expense History" in an offline expense tracker.

Design Style: Clean list view, Apple Reminders style. Cream background (#F4F1E8).

Layout:
- Top bar: Back arrow + "History" title (SF Pro Display Semibold 20pt)
- Below bar: Search input (48pt height, rounded 8pt, light border, magnifying glass icon left, placeholder "Search expenses...") + Filter button (icon 🎛️, 48x48pt)
- Main content: Scrollable list grouped by date
  - Date headers: "TODAY" (SF Pro Semibold 14pt, uppercase, gray, 8pt top margin)
  - Expense rows: Card style (white bg, 12pt padding, 8pt border radius, 4pt margin between)
    - Row layout: Category emoji icon (32pt) + "Lunch" (Inter 16pt, charcoal) + "$12.00" (SF Mono 16pt, right-aligned, deep blue) + "1:15pm" (Inter 12pt, gray, below name)
  - Repeat for "YESTERDAY", "JAN 27", etc.
- Bottom: 50pt gray placeholder for banner ad

Colors: Cream bg, white cards, deep blue for amounts, teal for icons, soft gray for time.
Typography: SF Pro Display for headers, Inter for text, SF Mono for amounts.
Portrait mobile (375x812pt). Show 5-6 expense rows with realistic data. Add subtle swipe-to-delete hint (red delete icon on edge when swiped left).
```

---

### Screen 4: MONTHLY SUMMARY

**Purpose:**  
Premium insights screen. Free users see monthly total + top category. Rewarded ad unlock reveals detailed breakdown, daily average, and highest spend day. **Major monetization surface.**

**Layout Structure (Free Tier):**
```
┌─────────────────────────────────┐
│  ← Back • "January 2026"        │
├─────────────────────────────────┤
│  MONTHLY TOTAL                  │
│  ┌─────────────────────────┐    │
│  │  $1,847.50              │    │
│  │  64 expenses            │    │
│  │  Top category: 🍔 Food  │    │
│  └─────────────────────────┘    │
├─────────────────────────────────┤
│  🔒 UNLOCK FULL BREAKDOWN       │
│  ┌─────────────────────────┐    │
│  │  • Category breakdown   │    │
│  │  • Daily average        │    │
│  │  • Highest spend day    │    │
│  │                         │    │
│  │  [Watch Ad to Unlock]   │    │
│  │  or                     │    │
│  │  [Remove Ads - $3.99]   │    │
│  └─────────────────────────┘    │
└─────────────────────────────────┘
```

**Layout Structure (Unlocked/Premium):**
```
┌─────────────────────────────────┐
│  ← Back • "January 2026"        │
├─────────────────────────────────┤
│  MONTHLY TOTAL                  │
│  ┌─────────────────────────┐    │
│  │  $1,847.50              │    │
│  │  64 expenses            │    │
│  └─────────────────────────┘    │
├─────────────────────────────────┤
│  CATEGORY BREAKDOWN             │
│  ┌─────────────────────────┐    │
│  │ 🍔 Food      $720  39%  │    │
│  │ 🚗 Transport $450  24%  │    │
│  │ 🏠 Home      $380  21%  │    │
│  │ ...                     │    │
│  └─────────────────────────┘    │
├─────────────────────────────────┤
│  INSIGHTS                       │
│  ┌─────────────────────────┐    │
│  │ Daily Avg: $61.58       │    │
│  │ Highest Day: Jan 15 ($145) │
│  └─────────────────────────┘    │
├─────────────────────────────────┤
│  DATE-WISE LOG                  │
│  [Filter: All | Expense | Income]
│  ┌─────────────────────────┐    │
│  │ Jan 28 • $87.50 • 5 items│   │
│  │ Jan 27 • $45.20 • 3 items│   │
│  │ ...                     │    │
│  └─────────────────────────┘    │
└─────────────────────────────────┘
```

**Components:**
- **App Bar:** Back + Month selector (dropdown: "January 2026")
- **Monthly Total Card:** Large amount, expense count
- **Free Tier: Paywall Card:**
  - Lock icon
  - Feature list (bullets)
  - Primary CTA: "Watch Ad to Unlock" (rewarded video)
  - Secondary CTA: "Remove Ads - $3.99" (IAP)
- **Unlocked: Category Breakdown:**
  - Bar chart (horizontal bars, teal fill)
  - List: Icon + Category + Amount + Percentage
  - Sorted by highest spend
- **Insights Card:**
  - Daily average (monthly total / days elapsed)
  - Highest spend day (date + amount)
- **Date-Wise Log:**
  - Filter toggle: All | Expense | Income
  - Grouped list by date (descending)
  - Each row: Date + Total + Item count
  - Tap row → Navigate to History filtered by that date

**User Actions:**
1. Change month → Tap dropdown, select month/year
2. **Free:** Tap "Watch Ad to Unlock" → Play rewarded video → Unlock monthly data (ephemeral, resets next month)
3. **Free:** Tap "Remove Ads - $3.99" → IAP flow → Permanent unlock
4. Tap category in breakdown → Navigate to History filtered by that category
5. Tap date in log → Navigate to History filtered by that date
6. Toggle Expense/Income filter → Update list

**Navigation:**
- From: Today screen (tap total card), Bottom nav
- To: History (filtered), Settings (IAP)

**States:**
- **Free (Locked):** Show paywall card
- **Unlocked (Ad Reward):** Show full breakdown, note "Unlocked for this month"
- **Unlocked (Premium IAP):** Show full breakdown permanently
- **Empty Month:** "No expenses this month"

**Edge Cases:**
- User watches ad but closes before completion → No unlock
- User watches ad mid-month → Unlock persists until month end
- User switches to past month → Paywall again (reward is monthly)
- Current month with <7 days data → Note "More data coming as month progresses"

**Monetization Logic:**
- Rewarded ad unlock: Valid for current month only
- Next month: User must watch ad again OR purchase IAP
- IAP removes ads + unlocks all monthly summaries permanently

**AI Screen Generation Prompt (Free Tier):**
```
Create a mobile app screen for "Monthly Summary" (free tier, locked state) in an offline expense tracker.

Design Style: Premium, clean, Apple-inspired. Cream background (#F4F1E8).

Layout:
- Top bar: Back arrow + "January 2026" (SF Pro Display Semibold 20pt, teal dropdown arrow)
- Large card (white, rounded 16pt, shadow): "Monthly Total" header (SF Pro Medium 14pt, gray) + "$1,847.50" (SF Mono Bold 32pt, deep blue) + "64 expenses" (Inter 14pt, gray)
- Below: Section header "Details" (SF Pro Semibold 18pt)
- Paywall card (white, rounded 16pt, lock icon 🔒 top-center):
  - "Unlock Full Breakdown" (SF Pro Semibold 18pt, deep blue)
  - Bullet list (Inter 16pt, charcoal): "• Category breakdown", "• Daily average spend", "• Highest spend day"
  - Primary button "Watch Ad to Unlock" (teal, 48pt height, 12pt radius, white text)
  - Divider text "or" (gray, 12pt)
  - Text button "Remove Ads - $3.99" (deep blue, underline)

Colors: Cream bg, white cards, deep blue text, teal accents, soft gray for secondary.
Typography: SF Pro Display for headers, Inter for body, SF Mono for amounts.
Portrait mobile (375x812pt). Add subtle lock icon shimmer effect.
```

**AI Screen Generation Prompt (Unlocked):**
```
Create a mobile app screen for "Monthly Summary" (unlocked state) in an offline expense tracker.

Design Style: Premium insights, Mint/YNAB style. Cream background (#F4F1E8).

Layout:
- Top bar: Back arrow + "January 2026" dropdown
- Monthly Total card (same as free tier): "$1,847.50" + "64 expenses"
- Section: "Category Breakdown" (SF Pro Semibold 18pt)
  - Horizontal bar chart card (white, rounded 16pt):
    - Row 1: 🍔 "Food" + "$720" (right) + teal progress bar (39% width) + "39%" (caption)
    - Row 2: 🚗 "Transport" + "$450" + bar (24%) + "24%"
    - Row 3: 🏠 "Home" + "$380" + bar (21%) + "21%"
    - Row 4: "..." (3 more categories, smaller bars)
- Section: "Insights" (SF Pro Semibold 18pt)
  - Card: "Daily Avg: $61.58" (left) + "Highest Day: Jan 15 ($145)" (right)
- Section: "Date-Wise Log" (SF Pro Semibold 18pt) + filter toggle [All|Expense|Income]
  - List: "Jan 28 • $87.50 • 5 items" (white card, rounded 12pt, tap affordance)

Colors: Teal bars, deep blue text, cream bg, white cards.
Typography: SF Pro Display headers, Inter body, SF Mono amounts.
Portrait mobile (375x812pt). Show 5 date rows in log.
```

---

### Screen 5: INSIGHTS / STREAKS

**Purpose:**  
Gamification and habit reinforcement. Show logging streak (consecutive days), weekly frequency, and lightweight text insights. Optional native ad placement.

**Layout Structure:**
```
┌─────────────────────────────────┐
│  ← Back • "Insights"            │
├─────────────────────────────────┤
│  🔥 LOGGING STREAK              │
│  ┌─────────────────────────┐    │
│  │      🔥 12 Days         │    │
│  │  Keep it going!         │    │
│  │  ▓▓▓▓▓▓▓░░░░░░░ (12/30)│    │
│  └─────────────────────────┘    │
├─────────────────────────────────┤
│  📊 WEEKLY ACTIVITY             │
│  ┌─────────────────────────┐    │
│  │  M  T  W  T  F  S  S    │    │
│  │  ✓  ✓  ✓  ○  ✓  ✓  ✓    │    │
│  │  6 of 7 days logged    │    │
│  └─────────────────────────┘    │
├─────────────────────────────────┤
│  💡 INSIGHTS                    │
│  ┌─────────────────────────┐    │
│  │ You're spending 15% more│    │
│  │ on weekends than weekdays│   │
│  └─────────────────────────┘    │
├─────────────────────────────────┤
│  NATIVE AD (optional)           │
└─────────────────────────────────┘
```

**Components:**
- **App Bar:** Back + "Insights" title
- **Streak Card:**
  - Large flame emoji + number of consecutive days
  - Encouragement text: "Keep it going!" / "You're on fire!" / "Almost there!"
  - Progress bar to next milestone (5, 10, 30, 100 days)
- **Weekly Activity Card:**
  - Visual calendar (Mon-Sun, checkmarks for logged days)
  - Text: "X of 7 days logged"
- **Insights Card:**
  - 1-2 lightweight text insights (no charts)
  - Examples:
    - "You're spending 15% more on weekends"
    - "Coffee is your most frequent expense"
    - "You logged expenses 23 days this month"
- **Native Ad:** Optional, bottom card, clearly labeled "Ad"

**User Actions:**
1. View streak → Visual reinforcement, dopamine hit
2. Tap milestone → Show "What's Next?" tooltip (e.g., "5 more days to reach 15!")
3. Scroll → Passive consumption, no heavy interaction

**Navigation:**
- From: Today screen (swipe), Bottom nav
- To: None (read-only screen)

**States:**
- **No Streak (Day 1):** "Start your streak! Log an expense today."
- **Streak Active:** Show days + progress
- **Streak Broken:** "Streak reset. Start again today!" (gentle, non-judgmental)

**Edge Cases:**
- User logs at 11:59pm → Counts for that day
- User misses one day → Streak resets to 0
- Timezone changes → Use device timezone consistently

**Gamification Notes:**
- Milestones: 5, 10, 15, 30, 60, 100 days
- No shaming for broken streaks (positive reinforcement only)
- Consider push notification: "You're on a 7-day streak! Don't break it."

**AI Screen Generation Prompt:**
```
Create a mobile app screen for "Insights / Streaks" in an offline expense tracker.

Design Style: Playful yet calming, Duolingo-style streaks. Cream background (#F4F1E8).

Layout:
- Top bar: Back arrow + "Insights" (SF Pro Display Semibold 20pt)
- Large card (white, rounded 16pt, centered):
  - "🔥 Logging Streak" header (SF Pro Semibold 18pt, charcoal)
  - Giant flame emoji "🔥" (64pt) + "12 Days" (SF Pro Display Bold 32pt, deep blue)
  - Subtext "Keep it going!" (Inter 14pt, teal)
  - Progress bar: filled segment (teal, 12/30), empty segment (light gray), labels "12" and "30" at ends
- Card below: "📊 Weekly Activity" (SF Pro Semibold 18pt)
  - Row of 7 circles (32pt diameter each, 4pt margin): M T W T F S S (labels above)
  - Checkmarks ✓ in 6 circles (teal fill), 1 empty circle (light gray)
  - Text "6 of 7 days logged" (Inter 14pt, gray)
- Card below: "💡 Insights" (SF Pro Semibold 18pt)
  - Text "You're spending 15% more on weekends than weekdays" (Inter 16pt, charcoal, 16pt padding)
- Bottom: Placeholder "Ad" (light gray box, 100pt height, rounded 8pt)

Colors: Cream bg, white cards, teal accents, deep blue for numbers, soft gray for inactive.
Typography: SF Pro Display for headers, Inter for body.
Portrait mobile (375x812pt). Add confetti particles around flame emoji.
```

---

### Screen 6: SETTINGS

**Purpose:**  
Manage app preferences: language, currency, daily reminders, data export, and remove ads purchase. Minimal, utilitarian design.

**Layout Structure:**
```
┌─────────────────────────────────┐
│  ← Back • "Settings"            │
├─────────────────────────────────┤
│  PREFERENCES                    │
│  ┌─────────────────────────┐    │
│  │ Language     English ›  │    │
│  │ Currency     USD ($) ›  │    │
│  │ Daily Reminder   [Toggle]│   │
│  └─────────────────────────┘    │
├─────────────────────────────────┤
│  DATA                           │
│  ┌─────────────────────────┐    │
│  │ Export CSV       [Reward]│   │
│  │ Export PDF       [Reward]│   │
│  └─────────────────────────┘    │
├─────────────────────────────────┤
│  PREMIUM                        │
│  ┌─────────────────────────┐    │
│  │ Remove Ads - $3.99      │    │
│  └─────────────────────────┘    │
├─────────────────────────────────┤
│  ABOUT                          │
│  ┌─────────────────────────┐    │
│  │ Privacy Policy       ›  │    │
│  │ Terms of Service     ›  │    │
│  │ Version 1.0.0           │    │
│  └─────────────────────────┘    │
└─────────────────────────────────┘
```

**Components:**
- **App Bar:** Back + "Settings" title
- **Grouped List (iOS style):**
  - **Preferences Section:**
    - Language: Tap → Bottom sheet with language list (7-8 major languages)
    - Currency: Tap → Bottom sheet with currency list + search
    - Daily Reminder: Toggle switch + time picker (default 8:00 PM)
  - **Data Section:**
    - Export CSV: Tap → Watch rewarded ad OR use IAP, then generate CSV
    - Export PDF: Tap → Watch rewarded ad OR use IAP, then generate PDF
  - **Premium Section:**
    - Remove Ads button → IAP flow ($3.99)
    - If already purchased: Show "Premium ✓"
  - **About Section:**
    - Privacy Policy: Tap → Open in-app browser
    - Terms of Service: Tap → Open in-app browser
    - Version number (read-only)

**User Actions:**
1. Change language → Select from list, app restarts with new locale
2. Change currency → Select from list, update display symbol
3. Toggle reminder → Enable/disable local notification, pick time
4. Export CSV → Watch ad OR use premium → Download file
5. Export PDF → Watch ad OR use premium → Download file
6. Remove Ads → IAP purchase → Permanent ad-free

**Navigation:**
- From: Today screen (app bar icon), Insights screen
- To: Language picker, Currency picker, IAP flow, Web view (legal docs)

**States:**
- **Default:** All options visible
- **Premium User:** "Remove Ads" shows "Premium ✓" (non-interactive)
- **Export Loading:** Show spinner on export buttons

**Edge Cases:**
- User cancels IAP → Return to settings, no change
- Export fails (no storage permission) → Show error toast, request permission
- Reminder permission denied → Show explainer dialog, deep link to system settings

**Technical Details:**
- Languages: English, Spanish, French, German, Portuguese, Hindi, Arabic, Mandarin (top 8)
- Currencies: USD, EUR, GBP, INR, JPY, CNY, BRL, etc. (top 20 + search)
- Local notifications: iOS/Android native, no server required
- Export format:
  - CSV: Date, Category, Amount, Note, Currency
  - PDF: Formatted table with app branding

**AI Screen Generation Prompt:**
```
Create a mobile app screen for "Settings" in an offline expense tracker.

Design Style: iOS Settings app style. Cream background (#F4F1E8).

Layout:
- Top bar: Back arrow + "Settings" (SF Pro Display Semibold 20pt)
- Section header "Preferences" (SF Pro Medium 12pt, uppercase, gray, left-aligned)
- Grouped card (white, rounded 12pt):
  - Row 1: "Language" (Inter 16pt, charcoal) + "English" (Inter 16pt, gray, right) + chevron ›
  - Divider (1pt gray line)
  - Row 2: "Currency" + "USD ($)" + chevron ›
  - Divider
  - Row 3: "Daily Reminder" + toggle switch (right, teal when on)
- Section header "Data"
- Grouped card:
  - Row 1: "Export CSV" + "Watch Ad" badge (teal pill, 12pt)
  - Divider
  - Row 2: "Export PDF" + "Watch Ad" badge
- Section header "Premium"
- Card:
  - Row: "Remove Ads - $3.99" (center-aligned, teal text, bold)
- Section header "About"
- Grouped card:
  - Row 1: "Privacy Policy" + chevron ›
  - Divider
  - Row 2: "Terms of Service" + chevron ›
  - Divider
  - Row 3: "Version 1.0.0" (center-aligned, gray, no chevron)

Colors: Cream bg, white cards, charcoal text, teal accents, gray dividers.
Typography: SF Pro Display for headers, Inter for body.
Portrait mobile (375x812pt). Each row 52pt height, 16pt horizontal padding.
```

---

## 🎉 STREAK MILESTONE MODAL

**Purpose:**  
Celebrate user achievements when they hit streak milestones (5, 10, 15, 30 days). Reinforce habit formation, encourage continued usage.

**Trigger:**
- When user logs expense and hits milestone day (5th, 10th, etc.)
- Show immediately after "Expense saved" toast

**Modal Design:**
```
┌─────────────────────────────────┐
│                                 │
│     🎉🔥 STREAK ACHIEVED! 🔥🎉   │
│                                 │
│         5 Days Logged!          │
│                                 │
│     [Confetti Animation]        │
│                                 │
│    Keep it going! You're        │
│    building a great habit.      │
│                                 │
│         [Continue]              │
│                                 │
└─────────────────────────────────┘
```

**Components:**
- **Full-screen overlay:** Semi-transparent dark backdrop (rgba(0,0,0,0.7))
- **Modal card:**
  - Centered, rounded 24pt
  - Background: White (light mode) / Dark navy (dark mode)
  - Confetti/fire animation (Lottie or CSS particles)
  - Title: "🔥 Streak Achieved! 🔥" (SF Pro Display Bold 24pt)
  - Subtitle: "5 Days Logged!" (SF Pro Display Semibold 32pt, teal)
  - Body text: Encouragement message (Inter 16pt)
  - Primary button: "Continue" (teal, 48pt height)
- **Animation:**
  - Confetti particles falling from top
  - Fire emoji pulse/glow effect
  - Modal slide-in from bottom with bounce

**Milestone Messages:**
- 5 days: "You're on fire! Keep it going!"
- 10 days: "Incredible! You're building a solid habit."
- 15 days: "Halfway to 30! You're unstoppable!"
- 30 days: "Legend! 30 days logged straight."
- 60 days: "Wow! 60 days of consistency!"
- 100 days: "Elite! 100-day streak achieved!"

**User Actions:**
1. Tap "Continue" → Dismiss modal, return to Today screen
2. Tap outside modal (backdrop) → Dismiss modal

**Technical Details:**
- Trigger only once per milestone (don't re-show if user backtracks)
- Store milestone_5, milestone_10, etc. flags in local DB
- Animation library: Lottie (or CSS keyframes for lightweight)
- Modal auto-dismisses after 5 seconds (passive UX)

**AI Screen Generation Prompt:**
```
Create a mobile app modal overlay for "Streak Milestone" in an offline expense tracker.

Design Style: Celebratory, Duolingo/Headspace style. Full-screen dark overlay (70% opacity).

Layout:
- Centered white card (320pt width, rounded 24pt, shadow)
- Top: Animated confetti particles (JSON animation or CSS) falling from top
- Center: Giant fire emoji "🔥" (64pt) with glow effect
- Title: "STREAK ACHIEVED!" (SF Pro Display Bold 24pt, deep blue, uppercase)
- Number: "5 Days Logged!" (SF Pro Display Bold 36pt, teal, next line)
- Subtext: "Keep it going! You're building a great habit." (Inter 16pt, charcoal, 16pt top margin)
- Bottom: Primary button "Continue" (teal, 48pt height, 12pt radius, white text, full-width within card padding)

Colors: White card, dark overlay, teal accents, deep blue text, confetti multi-color.
Typography: SF Pro Display for headers, Inter for body.
Portrait mobile modal (375x812pt screen). Add subtle pulse animation to fire emoji. Ensure tap-outside-to-dismiss affordance (visible backdrop).
```

---

## 🔐 TECHNICAL ARCHITECTURE

### Tech Stack
- **Framework:** Flutter (Dart)
- **State Management:** Provider (or Riverpod for scalability)
- **Local Database:** Hive (NoSQL, offline-first) or SQLite (relational)
- **Ads SDK:** Google AdMob (banner + rewarded video)
- **Analytics:** Firebase Analytics (lightweight, no backend)
- **Crash Reporting:** Firebase Crashlytics
- **Notifications:** flutter_local_notifications (no server)
- **In-App Purchases:** in_app_purchase (Flutter official plugin)
- **Localization:** flutter_localizations + intl package
- **Export:** csv + pdf packages

### Data Architecture (Local Hive/SQLite)

**Expenses Collection:**
```dart
{
  id: String (UUID),
  amount: double,
  currency: String, // USD, EUR, etc.
  category: String, // Food, Transport, etc.
  note: String?, // Optional
  type: String, // "expense" or "income"
  timestamp: DateTime,
  createdAt: DateTime,
  updatedAt: DateTime
}
```

**Settings Collection:**
```dart
{
  language: String, // "en", "es", "fr", etc.
  currency: String, // "USD", "EUR", etc.
  reminderEnabled: bool,
  reminderTime: String, // "20:00"
  premiumPurchased: bool,
  monthlyUnlocks: Map<String, bool>, // {"2026-01": true, "2026-02": false}
  streakData: {
    currentStreak: int,
    lastLoggedDate: String, // ISO date
    milestones: List<int> // [5, 10, 15]
  }
}
```

**Categories Collection:**
```dart
{
  id: String,
  name: String,
  icon: String, // Emoji or icon code
  isDefault: bool, // System vs user-added
  createdAt: DateTime
}
```

### Security Implementation
- **No server, no API keys exposed**
- **Local DB encryption:** Hive encryption (optional, for paranoid users)
- **IAP verification:** Google Play / App Store server-side validation (handled by platform)
- **Ads SDK:** AdMob keys in environment variables, not hardcoded

### Offline-First Strategy
- **All features work offline by design**
- No sync, no cloud backup (by design choice)
- Local notifications only (no push server)
- User data never leaves device (privacy promise)

---

## 📊 MONETIZATION IMPLEMENTATION

### Banner Ads
- **Placement:** Today (bottom), History (bottom), Insights (bottom)
- **Format:** 320x50 standard banner
- **Frequency:** Static, always visible (not auto-refresh)
- **Rules:**
  - Never cover FAB or primary CTAs
  - Must be dismissible after 5 seconds (optional)
  - Load asynchronously, don't block UI
- **Fallback:** If ad fails to load, collapse banner space (don't show blank)

### Rewarded Video Ads
- **Trigger Points:**
  1. Monthly Summary: "Watch Ad to Unlock" button
  2. Export CSV: "Watch Ad to Export" button
  3. Export PDF: "Watch Ad to Export" button
- **User Flow:**
  1. User taps CTA
  2. Show loading spinner (1-2s)
  3. Play 15-30s video ad (skippable after 5s)
  4. On completion → Grant reward (unlock/export)
  5. On skip/close → No reward, return to previous screen
- **Reward Logic:**
  - Monthly unlock: Valid until end of current month
  - Export: One-time, file downloads immediately
- **Fallback:** If no ad available, show "No ads available. Try again later." toast

### In-App Purchase (IAP)
- **Product:** "Remove Ads + Premium Features"
- **Price:** $3.99 USD (localized)
- **Benefits:**
  - Remove all banner ads permanently
  - Unlock Monthly Summary permanently (all months)
  - Unlimited exports (CSV/PDF) without ads
- **Purchase Flow:**
  1. User taps "Remove Ads - $3.99"
  2. Show native IAP dialog (Google/Apple)
  3. User confirms purchase
  4. On success → Update local flag `premiumPurchased: true`
  5. Show toast: "Premium activated! ✓"
  6. Reload screens to hide ads, unlock features
- **Restore Purchases:** Settings → "Restore Purchases" button (for device transfers)

### Monetization Tracking
- Track via Firebase Analytics:
  - `banner_ad_impression`
  - `rewarded_ad_started`
  - `rewarded_ad_completed`
  - `iap_purchase_initiated`
  - `iap_purchase_completed`
  - `monthly_unlock_rewarded` (ad-based)
  - `export_csv_rewarded` (ad-based)

---

## ✅ COMPREHENSIVE QA TEST CASES

### 10.1 Functional Testing - Core Features

**Expense Logging:**
- [ ] Add expense with amount, category, note → Saves successfully
- [ ] Add expense with amount only (no note) → Saves successfully
- [ ] Add expense with $0 amount → Shows validation error
- [ ] Add expense without selecting category → Auto-selects "Other"
- [ ] Edit existing expense → Updates correctly in DB and UI
- [ ] Delete expense via swipe → Removes from list and DB
- [ ] Delete expense via edit sheet → Removes correctly
- [ ] Add income entry → Logs as income type, appears in income view

**Data Persistence:**
- [ ] Log expense, force-close app, reopen → Expense persists
- [ ] Log 100 expenses → All load correctly in History
- [ ] Delete expense, force-close, reopen → Deletion persists
- [ ] Change currency in Settings → All amounts update with new symbol

### 10.2 UI/UX Testing

**Responsiveness:**
- [ ] App works on iPhone SE (smallest screen, 375x667)
- [ ] App works on iPhone 15 Pro Max (largest, 430x932)
- [ ] App works on Android tablets (landscape + portrait)
- [ ] No pixel overflow on any screen size
- [ ] Bottom navigation respects safe area (notch, home indicator)

**Visual Affordances:**
- [ ] All buttons have visible tap states (scale/color change)
- [ ] Cards that are tappable have subtle shadows/borders
- [ ] Non-interactive text does NOT look like buttons
- [ ] FAB pulses/bounces on first-time user screen (tooltip)
- [ ] Loading states show spinners (< 200ms threshold)

**Interactions:**
- [ ] Add Expense screen auto-focuses amount input
- [ ] Numeric keyboard opens immediately on Add Expense
- [ ] Back button dismisses keyboard before navigating back
- [ ] Swipe-to-delete on History rows works smoothly (iOS)
- [ ] Pull-to-refresh on History reloads data (if implemented)
- [ ] Modal dismisses on backdrop tap
- [ ] Streak modal auto-dismisses after 5 seconds

**Feedback:**
- [ ] Expense saved → Toast: "Expense saved ✓"
- [ ] Expense deleted → Toast: "Expense deleted"
- [ ] Export CSV → Toast: "CSV downloaded"
- [ ] IAP purchased → Toast: "Premium activated! ✓"
- [ ] Ad failed to load → Collapse banner space, no blank area

### 10.3 Input Validation

**Amount Field:**
- [ ] Empty amount → Error: "Amount must be greater than 0"
- [ ] Negative amount → Error or auto-convert to positive
- [ ] Amount > 1,000,000 → Accepted (no arbitrary limit)
- [ ] Decimal input (e.g., 12.50) → Accepted and formatted correctly
- [ ] Non-numeric input → Blocked by keyboard type (numeric)

**Category Field:**
- [ ] No category selected → Auto-selects "Other"
- [ ] Add custom category with emoji → Saves and displays correctly
- [ ] Delete custom category with existing expenses → Category remains on old expenses

**Note Field:**
- [ ] Note with 200+ characters → Accepted (no hard limit)
- [ ] Note with special characters (emoji, symbols) → Accepted
- [ ] Empty note → Accepted (optional field)

### 10.4 Integration Testing

**Local Database:**
- [ ] Write 1000 expenses → No performance degradation
- [ ] Query expenses by date range → Returns correct results
- [ ] Query expenses by category → Returns correct results
- [ ] Database migrations (schema changes) → No data loss

**Ads SDK:**
- [ ] Banner ad loads within 2 seconds
- [ ] Banner ad failure → Collapses space, no blank box
- [ ] Rewarded ad plays full video → Grants reward
- [ ] Rewarded ad skipped early → No reward granted
- [ ] Rewarded ad fails to load → Toast: "No ads available"

**IAP:**
- [ ] Purchase IAP → Receipt validated, premium flag set
- [ ] Restore purchase on new device → Premium restored
- [ ] Purchase IAP twice → Second attempt blocked (already owned)

**Local Notifications:**
- [ ] Enable daily reminder → Notification fires at set time
- [ ] Disable daily reminder → Notification stops
- [ ] Change reminder time → Notification updates to new time
- [ ] Tap notification → Opens app to Today screen

### 10.5 Performance Testing

**App Launch:**
- [ ] Cold start (first launch) → < 2 seconds to Today screen
- [ ] Warm start (backgrounded) → < 500ms to Today screen
- [ ] App size (APK/IPA) → < 10 MB

**Screen Transitions:**
- [ ] Navigate between screens → < 200ms transition time
- [ ] No frame drops during animations (60fps)
- [ ] Scroll History with 500+ entries → Smooth scroll (lazy loading)

**Database Operations:**
- [ ] Add expense → < 100ms DB write
- [ ] Load Today screen with 50 expenses → < 300ms
- [ ] Search History with 1000 entries → < 500ms results

### 10.6 Security Testing

**Data Privacy:**
- [ ] No data sent to external servers (verified via network logs)
- [ ] Ads SDK does NOT access expense data (sandbox test)
- [ ] Local DB file is NOT readable by other apps
- [ ] Export CSV contains only user's data (no leakage)

**Input Sanitization:**
- [ ] SQL injection in note field → Blocked (use parameterized queries)
- [ ] XSS in note field → Escaped (no script execution)

### 10.7 Accessibility Testing

**WCAG Compliance:**
- [ ] Text contrast ratio ≥ 4.5:1 (body text)
- [ ] Text contrast ratio ≥ 3:1 (large text, 18pt+)
- [ ] Touch targets ≥ 44x44 pt (iOS) / 48x48 dp (Android)
- [ ] Focus indicators visible on all interactive elements

**Screen Reader Support:**
- [ ] VoiceOver (iOS) reads all elements correctly
- [ ] TalkBack (Android) reads all elements correctly
- [ ] Buttons have descriptive labels (not just "Button")
- [ ] Images have alt text (icon descriptions)

**Dynamic Type:**
- [ ] App supports iOS Dynamic Type (text scales)
- [ ] App supports Android Font Scale (text scales)
- [ ] Layout does NOT break at 200% text size

### 10.8 Platform-Specific Testing

**iOS:**
- [ ] Safe area respected (notch, Dynamic Island, home indicator)
- [ ] Back swipe gesture works on all screens
- [ ] Keyboard dismisses with swipe-down gesture
- [ ] Dark Mode toggle → UI updates correctly
- [ ] App icon displays correctly on home screen
- [ ] App name visible under icon (no truncation)

**Android:**
- [ ] System back button behaves correctly (not "double-back-to-exit")
- [ ] Bottom navigation respects gesture bar
- [ ] Keyboard "Done" button dismisses keyboard
- [ ] Dark Mode toggle → UI updates correctly
- [ ] Adaptive icon displays correctly (various shapes)
- [ ] App name visible under icon

### 10.9 Monetization Testing

**Banner Ads:**
- [ ] Banner loads on Today, History, Insights screens
- [ ] Banner does NOT appear on Add Expense screen
- [ ] Banner does NOT cover FAB or primary CTAs
- [ ] Banner collapses if ad fails to load

**Rewarded Ads:**
- [ ] "Watch Ad to Unlock" on Monthly Summary → Plays ad, unlocks breakdown
- [ ] "Watch Ad to Export" on CSV → Plays ad, downloads file
- [ ] Ad skipped before completion → No reward granted
- [ ] Ad completed → Reward granted immediately
- [ ] Monthly unlock persists until month end
- [ ] Monthly unlock resets on new month

**IAP:**
- [ ] Purchase "Remove Ads" → All banner ads hidden
- [ ] Purchase "Remove Ads" → Monthly Summary permanently unlocked
- [ ] Purchase "Remove Ads" → Exports work without ads
- [ ] "Restore Purchases" button → Restores premium on new device

### 10.10 Localization Testing

**Multi-Language:**
- [ ] Change to Spanish → All UI text updates
- [ ] Change to Hindi → RTL layout NOT applied (Hindi is LTR)
- [ ] Change to Arabic → RTL layout applied correctly
- [ ] Date formats update per locale (e.g., DD/MM vs MM/DD)
- [ ] Number formats update per locale (e.g., 1,000.00 vs 1.000,00)

**Multi-Currency:**
- [ ] Change to EUR → All amounts show € symbol
- [ ] Change to INR → All amounts show ₹ symbol
- [ ] Currency symbol position correct (e.g., $10 vs 10€)
- [ ] Past expenses retain original currency (no auto-conversion)

### 10.11 Edge Cases & Error Handling

**No Internet:**
- [ ] App launches successfully (offline-only design)
- [ ] All features work without internet
- [ ] Ads fail gracefully (collapsed space, toast)

**Low Storage:**
- [ ] Export CSV with full storage → Error toast: "Not enough storage"
- [ ] Add expense with full DB → Rare, but handle gracefully

**Device Timezone Changes:**
- [ ] Log expense, change timezone, view History → Expense appears with correct time
- [ ] Streak logic respects device timezone consistently

**App Backgrounded Mid-Action:**
- [ ] User starts typing expense, backgrounds app, returns → Data persists in form
- [ ] User watches rewarded ad, backgrounds app, returns → Ad progress lost (ad SDK behavior)

**Rapid Tapping:**
- [ ] Double-tap Save Expense button → Saves once (debounce)
- [ ] Rapidly tap navigation buttons → No crash, navigates once

---

## 🚀 DEPLOYMENT CHECKLIST

### 11.1 Pre-Deployment

**Code Quality:**
- [ ] All QA test cases passed (see above)
- [ ] No debug logs in production build
- [ ] No hardcoded API keys or secrets
- [ ] Code follows Dart style guide (dart format)
- [ ] No TODOs or FIXMEs in critical paths

**Performance:**
- [ ] App size < 10 MB (APK/IPA)
- [ ] Cold start < 2 seconds
- [ ] Crash-free sessions > 99.5% (beta testing)

**Configuration:**
- [ ] Firebase project configured for production
- [ ] AdMob ad units created (banner, rewarded)
- [ ] IAP product created in Google Play Console / App Store Connect
- [ ] App versioning set (1.0.0 for initial release)

**Legal:**
- [ ] Privacy Policy finalized and hosted (link in Settings)
- [ ] Terms of Service finalized and hosted (link in Settings)
- [ ] COPPA compliance verified (if targeting kids under 13)
- [ ] GDPR compliance verified (if targeting EU users)

### 11.2 App Store Assets

**iOS App Store:**
- [ ] App icon (1024x1024 PNG, no transparency)
- [ ] Screenshots (6.7" iPhone, 5.5" iPhone, 12.9" iPad)
- [ ] App preview video (optional, 30s max)
- [ ] App name (max 30 characters): "Daily Expense Tracker"
- [ ] Subtitle (max 30 characters): "Simple Offline Money Manager"
- [ ] Keywords: "expense tracker, offline, no login, simple, budget, money"
- [ ] Description (4000 chars):
  ```
  Daily Expense Tracker - The simplest way to track your spending.
  
  ✅ No signup, no login
  ✅ 100% offline, 100% private
  ✅ Log expenses in under 3 seconds
  ✅ Build daily logging habits with streaks
  ✅ Multi-language, multi-currency
  
  Perfect for students, gig workers, and anyone who values privacy.
  
  Features:
  • Fast expense logging
  • Income tracking
  • Monthly summaries
  • Streak gamification
  • Export to CSV/PDF
  • Daily reminders
  
  No bank sync. No cloud. Your data stays on your device.
  ```
- [ ] Promotional text (170 chars): "Log expenses faster than opening a notes app. No signup, no internet. Your data, your device."
- [ ] Age rating: 4+ (No objectionable content)
- [ ] Category: Finance
- [ ] Privacy Policy URL
- [ ] Support URL

**Google Play Store:**
- [ ] App icon (512x512 PNG)
- [ ] Feature graphic (1024x500 PNG)
- [ ] Screenshots (phone + tablet, min 2, max 8)
- [ ] App name: "Daily Expense Tracker"
- [ ] Short description (80 chars): "Simple offline expense tracker. No login, no bank sync. Your data, your device."
- [ ] Full description (4000 chars): Same as iOS, reformatted
- [ ] Category: Finance
- [ ] Content rating: Everyone
- [ ] Privacy Policy URL
- [ ] Data safety questionnaire completed
  - [ ] Does app collect data? Yes (local only, clarify in description)
  - [ ] Does app share data with third parties? No
  - [ ] Does app use encryption? No (local storage only)

### 11.3 Build & Release

**iOS:**
- [ ] Build app in Release mode (`flutter build ios --release`)
- [ ] Archive in Xcode
- [ ] Upload to App Store Connect via Xcode or Transporter
- [ ] Submit for review
- [ ] Set release date (manual or automatic)

**Android:**
- [ ] Build app in Release mode (`flutter build appbundle --release`)
- [ ] Sign with upload key
- [ ] Upload AAB to Google Play Console
- [ ] Create release (Production track)
- [ ] Set rollout percentage (e.g., 100% for full release)
- [ ] Submit for review

**Version Numbers:**
- [ ] iOS: CFBundleShortVersionString = 1.0.0, CFBundleVersion = 1
- [ ] Android: versionName = 1.0.0, versionCode = 1

**Release Notes:**
```
Initial release!

✨ Features:
• Fast expense logging (< 3 seconds)
• Offline-first, no login required
• Income tracking
• Monthly summaries
• Streak gamification
• Multi-language, multi-currency
• Export to CSV/PDF
• Daily reminders

Your data stays on your device. No cloud, no tracking.
```

---

## 🌐 LOCALIZATION & INTERNATIONALIZATION

### Supported Languages (Priority Order)
1. **English** (default, US/UK/AU)
2. **Spanish** (Spain, Latin America)
3. **French** (France, Canada)
4. **German** (Germany, Austria)
5. **Portuguese** (Brazil, Portugal)
6. **Hindi** (India)
7. **Arabic** (Middle East, RTL layout)
8. **Mandarin Chinese** (China, simplified)

### Localization Files
- Use Flutter's `intl` package for string localization
- Store translations in `.arb` files (one per language)
- Example: `app_en.arb`, `app_es.arb`, `app_ar.arb`

### UI Adjustments per Locale
- **RTL languages (Arabic):** Mirror layout (text, icons, navigation)
- **Date formats:** MM/DD/YYYY (US) vs DD/MM/YYYY (EU) vs YYYY/MM/DD (Asia)
- **Number formats:** 1,000.00 (US) vs 1.000,00 (EU) vs 1 000,00 (FR)
- **Currency symbols:** Position varies (e.g., $10 vs 10€ vs ₹10)

### Currency Support
- **Top 20 currencies:** USD, EUR, GBP, INR, JPY, CNY, BRL, RUB, KRW, MXN, AUD, CAD, CHF, SEK, NOK, DKK, PLN, THB, IDR, TRY
- **User can override:** Manual currency selection in Settings
- **Symbol display:** Use Unicode symbols (₹, €, £, ¥, etc.)
- **Formatting:** Use `intl` package for currency formatting per locale

---

## 🎯 ASO (APP STORE OPTIMIZATION)

### Target Keywords
**Primary:**
- "expense tracker"
- "offline expense tracker"
- "simple expense manager"
- "no login expense app"
- "daily expense log"

**Secondary:**
- "budget app"
- "money tracker"
- "spending tracker"
- "personal finance"
- "cash tracker"

**Long-tail:**
- "expense tracker no signup"
- "offline budget app"
- "simple money manager"
- "private expense tracker"
- "daily spending log"

### Keyword Integration
- **App Name:** "Daily Expense Tracker"
- **Subtitle (iOS):** "Simple Offline Money Manager"
- **Short Description (Android):** "Simple offline expense tracker. No login, no bank sync."
- **In-App Copy:**
  - Onboarding: "Welcome to the simplest expense tracker"
  - Empty states: "Start tracking your daily expenses"
  - Settings: "Daily expense reminders"

### Screenshot Strategy
1. **Hero shot:** Today screen with real data, caption "Track expenses in under 3 seconds"
2. **Feature 1:** Add Expense screen, caption "No login, no internet required"
3. **Feature 2:** Monthly Summary, caption "Unlock insights with rewarded ads"
4. **Feature 3:** Streaks screen, caption "Build daily logging habits"
5. **Feature 4:** Multi-language/currency, caption "Global support, 8 languages"
6. **Feature 5:** Privacy focus, caption "Your data never leaves your device"

### App Store Listing Best Practices
- Lead with privacy/offline in first sentence
- Use bullet points for features (easy scanning)
- Include social proof (if available): "Join 10,000+ users..."
- Call-to-action: "Download now and start logging today!"
- Update description seasonally (e.g., "New Year, new habits!")

---

## 🛠️ DEVELOPMENT GUIDELINES

### Folder Structure (Feature-First)
```
lib/
├── main.dart
├── app.dart (MaterialApp setup)
├── core/
│   ├── constants/
│   │   ├── colors.dart
│   │   ├── text_styles.dart
│   │   └── dimensions.dart
│   ├── utils/
│   │   ├── date_utils.dart
│   │   ├── currency_utils.dart
│   │   └── validators.dart
│   └── services/
│       ├── database_service.dart (Hive/SQLite wrapper)
│       ├── ad_service.dart (AdMob wrapper)
│       ├── iap_service.dart (IAP wrapper)
│       └── notification_service.dart
├── features/
│   ├── today/
│   │   ├── screens/
│   │   │   └── today_screen.dart
│   │   ├── widgets/
│   │   │   ├── total_card.dart
│   │   │   └── recent_list.dart
│   │   ├── models/
│   │   │   └── today_summary.dart
│   │   └── providers/
│   │       └── today_provider.dart
│   ├── add_expense/
│   │   ├── screens/
│   │   │   └── add_expense_screen.dart
│   │   ├── widgets/
│   │   │   ├── amount_input.dart
│   │   │   └── category_selector.dart
│   │   └── providers/
│   │       └── expense_form_provider.dart
│   ├── history/
│   │   ├── screens/
│   │   │   └── history_screen.dart
│   │   ├── widgets/
│   │   │   └── expense_row.dart
│   │   └── providers/
│   │       └── history_provider.dart
│   ├── monthly_summary/
│   │   ├── screens/
│   │   │   └── monthly_summary_screen.dart
│   │   ├── widgets/
│   │   │   ├── paywall_card.dart
│   │   │   └── breakdown_chart.dart
│   │   └── providers/
│   │       └── summary_provider.dart
│   ├── insights/
│   │   ├── screens/
│   │   │   └── insights_screen.dart
│   │   └── widgets/
│   │       ├── streak_card.dart
│   │       └── weekly_activity.dart
│   └── settings/
│       ├── screens/
│       │   └── settings_screen.dart
│       └── providers/
│           └── settings_provider.dart
└── shared/
    ├── widgets/
    │   ├── custom_button.dart
    │   ├── custom_text_field.dart
    │   ├── banner_ad_widget.dart
    │   └── streak_modal.dart
    └── theme/
        └── app_theme.dart
```

### Code Standards
- **Follow Effective Dart:** [dart.dev/guides/language/effective-dart](https://dart.dev/guides/language/effective-dart)
- **Use meaningful names:** `addExpense()` not `add()`, `totalAmount` not `ta`
- **Max function length:** 50 lines (break into helpers if longer)
- **Use const constructors:** For immutable widgets (performance)
- **Avoid nested callbacks:** Extract to named functions
- **Error handling:** Wrap DB/network calls in try-catch
- **Comments:** Why, not what (self-documenting code preferred)

### Performance Best Practices
- **Lazy load lists:** Use `ListView.builder` for long lists (History)
- **Debounce inputs:** Search bar, amount input (wait 300ms before filtering)
- **Cache DB queries:** Today screen totals (invalidate on new expense)
- **Optimize images:** Use `flutter_svg` for icons (vector > raster)
- **Profile builds:** Use DevTools to identify bottlenecks

### Testing Strategy
- **Unit tests:** Core utils (date, currency, validators)
- **Widget tests:** Custom widgets (buttons, inputs, cards)
- **Integration tests:** Critical flows (add expense, delete expense, IAP)
- **Manual testing:** Device testing on 3-5 real devices (iOS + Android)

---

## 🐛 ERROR HANDLING & EDGE CASES

### Error Categories

**1. Database Errors:**
- **Symptom:** DB write fails, DB corrupted
- **Handling:**
  - Show toast: "Failed to save. Please try again."
  - Log error to Crashlytics
  - Fallback: Retry once, then show "Contact support" option
- **Prevention:** Validate data before write, use transactions

**2. Ad Loading Errors:**
- **Symptom:** Banner ad fails to load, rewarded ad unavailable
- **Handling:**
  - Banner: Collapse ad space (don't show blank)
  - Rewarded: Show toast: "No ads available. Try again later."
  - Log error to Firebase Analytics (not Crashlytics, expected behavior)
- **Prevention:** Test ad SDK in sandbox mode, use test ad units in debug

**3. IAP Errors:**
- **Symptom:** Purchase fails, receipt validation fails
- **Handling:**
  - Show toast: "Purchase failed. Your card was not charged."
  - Log error to Crashlytics
  - Provide "Contact Support" button (email link)
- **Prevention:** Test IAP flow in sandbox, handle all error codes

**4. Permission Errors:**
- **Symptom:** Notification permission denied, storage permission denied
- **Handling:**
  - Show dialog: "We need [permission] to [feature]. Grant in Settings?"
  - Provide deep link to app settings
  - Gracefully disable feature if denied (don't nag)
- **Prevention:** Request permissions with clear context ("Get reminded daily!")

**5. Device-Specific Errors:**
- **Symptom:** App crashes on specific OS version, device model
- **Handling:**
  - Log crash to Crashlytics with device metadata
  - Push hotfix ASAP
- **Prevention:** Test on min OS versions (iOS 14, Android 8), use diverse device farm

### Empty States

**Today Screen (No Expenses):**
- Illustration: Simple coin/wallet icon
- Text: "Start logging your first expense!"
- CTA: "Add Your First Expense" (primary button)

**History Screen (No Expenses):**
- Illustration: Empty calendar icon
- Text: "No expenses yet. Tap the + button to get started."

**Monthly Summary (No Data):**
- Text: "No expenses this month. Start tracking to see insights!"

**Search No Results:**
- Text: "No expenses match your search. Try a different keyword or category."

### Validation Rules

**Amount Field:**
- Must be > 0
- Must be numeric (keyboard enforces)
- Max 2 decimal places (auto-format)
- Max value: 999,999.99 (arbitrary, prevent abuse)

**Note Field:**
- Max 500 characters (prevent DB bloat)
- No validation (allow any text, emoji, symbols)

**Category Field:**
- Required (auto-select "Other" if none selected)
- Max 20 characters for custom categories

---

## 📱 PLATFORM-SPECIFIC REQUIREMENTS

### iOS (App Store Guidelines)

**HIG Compliance:**
- [ ] Use iOS-native navigation patterns (back swipe, tab bar)
- [ ] Safe areas respected (notch, home indicator, Dynamic Island)
- [ ] System fonts (SF Pro) OR consistent custom fonts
- [ ] Dynamic Type supported (text scales with system settings)
- [ ] Dark Mode supported (or explicitly disabled in Info.plist)
- [ ] Haptic feedback for key actions (expense saved, milestone)

**App Store Review Guidelines:**
- [ ] App is complete, no "coming soon" features
- [ ] All links work (Privacy Policy, Terms)
- [ ] No crashes during review (test on review devices: iPhone 12, 14, 15)
- [ ] Privacy Policy mentions ad tracking (if using AdMob)
- [ ] App doesn't reference Android or other platforms in UI
- [ ] In-App Purchases clearly labeled, no misleading pricing

**App Privacy (Nutrition Label):**
- **Data Collection:**
  - [ ] Usage Data: Yes (Firebase Analytics)
  - [ ] Identifiers: Yes (AdMob IDFA for personalized ads)
  - [ ] Financial Info: No (expenses stored locally, not transmitted)
- **Data Linked to User:** None (offline app, no accounts)
- **Data Used to Track User:** Yes (AdMob, for ad targeting)

### Android (Google Play Guidelines)

**Material Design:**
- [ ] Use Material 3 design system (or custom that feels native)
- [ ] Respect system navigation bar (gesture/button modes)
- [ ] Ripple effects on all tappable elements
- [ ] Elevation/shadows follow Material spec

**Google Play Policies:**
- [ ] Target API 34 (Android 14) as of 2024
- [ ] Data Safety form completed accurately
- [ ] Content rating (IARC) completed
- [ ] Advertising ID usage disclosed (AdMob)
- [ ] User can opt-out of personalized ads (AdMob setting)

**Permissions:**
- [ ] `INTERNET` (for ads, analytics)
- [ ] `WRITE_EXTERNAL_STORAGE` (for CSV/PDF export, API <29)
- [ ] `POST_NOTIFICATIONS` (for daily reminders, API 33+)
- [ ] No unnecessary permissions requested

---

## 🎨 VISUAL DESIGN REFINEMENTS

### Micro-Interactions

**Button Press:**
- Scale down to 0.97 on press
- 100ms transition duration
- Subtle shadow increase on hover (web)

**Card Tap:**
- Scale down to 0.98 on tap
- 80ms transition duration
- No shadow change (subtle)

**FAB Tap:**
- Rotate 45° on tap (+ becomes ×)
- 200ms transition duration
- Bounce animation on first appearance

**Swipe-to-Delete:**
- Red background reveals on left swipe
- Delete icon fades in
- Confirm dialog on tap (prevent accidental delete)

**Streak Modal:**
- Modal slides up from bottom with bounce easing
- Confetti particles fall from top (300 particles, 2s duration)
- Fire emoji pulses (scale 1.0 → 1.2 → 1.0, 1s loop)

### Animations

**Screen Transitions:**
- Slide from right (iOS style) for push navigation
- Slide from bottom for modals
- Fade for tab switches
- 300ms duration, ease-in-out curve

**Loading States:**
- Skeleton UI (shimmer effect) for cards
- Spinner (teal color) for async actions
- Progress bar (linear, teal) for ad loading

**List Animations:**
- Staggered fade-in for History list (50ms delay per item)
- Delete animation: Slide out to left, fade out (300ms)

### Dark Mode

**Color Overrides:**
- Background: `#0D1B2A` (dark navy)
- Cards: `#1B263B` (lighter navy)
- Text: `#EDF2F4` (off-white)
- Accent: `#2A9D8F` (unchanged, good contrast)
- Borders: `#415A77` (muted blue-gray)

**Image Adjustments:**
- Illustrations: Invert colors OR use dark-mode variants
- Icons: White tint in dark mode (teal in light mode)

**Testing:**
- [ ] Toggle system dark mode → App updates immediately
- [ ] All text readable (contrast check)
- [ ] No pure white/black (use off-white/navy for softer feel)

---

## 📊 ANALYTICS EVENTS (Firebase)

### User Actions
```dart
// Expense Management
analytics.logEvent(name: 'expense_added', parameters: {
  'amount': amount,
  'category': category,
  'has_note': note != null,
});

analytics.logEvent(name: 'expense_edited', parameters: {
  'category': category,
});

analytics.logEvent(name: 'expense_deleted', parameters: {
  'category': category,
});

// Navigation
analytics.logEvent(name: 'screen_view', parameters: {
  'screen_name': 'Today', // or 'History', 'Monthly Summary', etc.
});

// Monetization
analytics.logEvent(name: 'banner_ad_impression', parameters: {
  'screen': 'Today',
});

analytics.logEvent(name: 'rewarded_ad_started', parameters: {
  'placement': 'monthly_summary', // or 'export_csv'
});

analytics.logEvent(name: 'rewarded_ad_completed', parameters: {
  'placement': 'monthly_summary',
  'reward_granted': true,
});

analytics.logEvent(name: 'iap_purchase_initiated', parameters: {
  'product_id': 'remove_ads',
});

analytics.logEvent(name: 'iap_purchase_completed', parameters: {
  'product_id': 'remove_ads',
  'price': 3.99,
});

// Settings
analytics.logEvent(name: 'language_changed', parameters: {
  'from': 'en',
  'to': 'es',
});

analytics.logEvent(name: 'currency_changed', parameters: {
  'from': 'USD',
  'to': 'EUR',
});

analytics.logEvent(name: 'reminder_toggled', parameters: {
  'enabled': true,
  'time': '20:00',
});

// Streaks
analytics.logEvent(name: 'streak_milestone_reached', parameters: {
  'days': 5, // or 10, 15, 30, etc.
});

// Export
analytics.logEvent(name: 'export_csv_initiated', parameters: {
  'rewarded_ad': true, // false if premium user
});

analytics.logEvent(name: 'export_pdf_initiated', parameters: {
  'rewarded_ad': false,
});
```