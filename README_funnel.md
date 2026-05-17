# 📊 User Funnel Analysis Dashboard

> Built with Power BI · SQL · DAX | Product Analytics | Funnel Analysis

---

## 🎯 Project Overview

This project analyses how users move through a 3-stage product funnel:

**Signup → Login → Purchase**

Using a real event-level dataset of **311 user events** across **120 unique users** (Jan–Mar 2025), the goal was to identify where users drop off, measure conversion at each stage, and derive actionable recommendations to improve overall funnel performance.

---

## 🛠️ Tools Used

| Tool | Purpose |
|------|---------|
| **Power BI** | Dashboard building and visualisation |
| **DAX** | KPI measures and conditional formatting |
| **SQL** | Data preparation and funnel aggregation |
| **Excel / CSV** | Raw event dataset (`User_Events.csv`) |

---

## 📁 Project Structure

```
user-funnel-analysis/
 ┣ 📊 User_Funnel_Dashboard.pbix          ← Power BI dashboard file
 ┣ 📄 README.md                           ← This file
 ┣ 📄 User_Funnel_Analytics_Project.sql   ← SQL used for data prep
 ┣ 📄 User_Events.csv                     ← Raw event dataset (311 records)
 ┗ 📁 screenshots/
      ┗ dashboard.png                     ← Dashboard screenshot
```

---

## 📌 Problem Statement

In e-commerce and SaaS products, users drop off at various funnel stages before completing a purchase. Understanding **where** and **how many** users drop off is critical for improving revenue.

**Business Question:**
> "At which stage of the funnel are we losing the most users, and what actions can improve overall conversion?"

---

## 📊 Dashboard Features

- **4 KPI Cards** — Total Users (120), Signup Users, Login Users, Purchase Users
- **3 Conversion Rate Cards** — Conditional formatting: Green (>85%) · Amber (65–85%) · Red (<65%)
- **Funnel Overview** — Visual drop-off across all 3 stages
- **Drop-Off by Stage** — Bar chart showing absolute users lost at each stage
- **User Trend Over Time** — Line chart: Signup / Login / Purchase users by month (Jan–Mar 2025)
- **Purchase by Device** — Mobile vs Desktop conversion breakdown
- **Key Insights Text Box** — Written business analysis
- **Interactive Slicers** — Filter by Device and Date Range

---

## 📈 Key Metrics (from actual data)

| Metric | Value |
|--------|-------|
| Total unique users | **120** |
| Signup users | **120** |
| Login users | **108** |
| Purchase users | **76** |
| Signup → Login conversion | **90.0%** ✅ |
| Login → Purchase conversion | **70.4%** ⚠️ |
| Overall funnel conversion | **63.3%** ⚠️ |
| Funnel leakage | **36.7%** |
| Biggest drop-off stage | **Login → Purchase** |
| Users lost at purchase stage | **32 users** |
| Mobile conversion rate | **63.3%** |
| Desktop conversion rate | **63.3%** |
| Date range | **Jan 2025 – Mar 2025** |
| Total event records | **311** |

---

## 🔍 Key Insights

- **90% of users login after signup** — onboarding flow is strong, no action needed at this stage
- **Major drop-off at Login → Purchase** — 32 logged-in users (29.6%) never completed a purchase
- **Only 63.3% of users complete the full funnel** — this gap is the primary revenue opportunity
- **Mobile and Desktop convert at identical rates (63.3% each)** — the bottleneck is not device-specific; it is a checkout/intent problem affecting both platforms equally
- **Logged-in non-purchasers are the highest-value retargeting segment** — they showed intent by logging in but did not convert

---

## 💡 Business Recommendations

The critical bottleneck is **Login → Purchase** — 32 users logged in but never bought. Recovering even half of these users would meaningfully increase revenue.

**Recommended actions:**

1. **Reduce checkout friction** — Implement one-click or 2-step checkout to lower abandonment
2. **Retarget logged-in non-purchasers** — Trigger email or push notification within 24 hours of login without purchase
3. **A/B test checkout flow** — Run a simplified checkout vs current flow, targeting the Login → Purchase gap specifically
4. **Investigate the 10% who never logged in** — 12 users signed up but never logged in; check if email verification or onboarding is blocking them

**Projected impact:** Recovering 15 of the 32 dropped users at the purchase stage = 12.5% uplift in overall conversion

---

## 📐 DAX Measures Used

```dax
Signup Users =
CALCULATE(DISTINCTCOUNT(user_events[user_id]),
          user_events[event_name] = "signup")

Login Users =
CALCULATE(DISTINCTCOUNT(user_events[user_id]),
          user_events[event_name] = "login")

Purchase Users =
CALCULATE(DISTINCTCOUNT(user_events[user_id]),
          user_events[event_name] = "purchase")

Signup to Login % =
DIVIDE([Login Users], [Signup Users])

Login to Purchase % =
DIVIDE([Purchase Users], [Login Users])

Overall Conversion % =
DIVIDE([Purchase Users], [Signup Users])

Funnel Leakage % =
1 - [Overall Conversion %]
```

---

## 🗄️ SQL Concepts Used

- `GROUP BY` with aggregate functions (`COUNT`, `MAX`)
- `CASE WHEN` for pivoting event types into columns
- `DISTINCT` user counts per event stage
- CTEs for multi-step funnel logic
- `JOIN` to combine signup, login, and purchase stages
- `RANK()` for device-wise conversion ranking

---

## 📊 Dataset Information

| Property | Detail |
|----------|--------|
| File name | `User_Events.csv` |
| Total records | 311 events |
| Unique users | 120 |
| Event types | signup, login, purchase |
| Device types | mobile, desktop |
| Date range | Jan 2025 – Mar 2025 |

---

## 📈 Dashboard Screenshot

![Dashboard](screenshots/dashboard.png)

---

## 👤 About

**Made by:** [Suresh Vakil Pawar]
**Role target:** Data Analyst / Product Analyst /Businees Analyst
**Tools:** Power BI · SQL · DAX · Excel


---

> ⭐ If you found this project useful, feel free to star the repository!
