# 📊 User Funnel Analysis Dashboard

> Built with Power BI | Product Analytics | Funnel Analysis

---

## 🎯 Project Overview

This project analyzes how users move through a product funnel across three key stages:

**Signup → Login → Purchase**

The goal was to identify where users drop off, understand conversion rates at each stage, and derive actionable business insights to improve overall conversion.

---

## 🛠️ Tools Used

| Tool | Purpose |
|------|---------|
| Power BI | Dashboard building and visualization |
| DAX | Custom measures and conditional formatting |
| SQL | Data preparation and funnel aggregation |
| Excel/CSV | Raw dataset |

---

## 📁 Project Structure

```
user-funnel-analysis/
 ┣ 📊 user-funnel-dashboard.pbix   ← Power BI dashboard file
 ┣ 📄 README.md                    ← This file
 ┣ 📄 sql_queries.sql              ← SQL used for data prep
 ┗ 📁 dataset/
      ┗ events.csv                 ← Sample dataset
```

---

## 📌 Problem Statement

In any e-commerce or SaaS product, users drop off at various stages of the funnel before completing a purchase. Understanding **where** and **how much** they drop off is critical for improving revenue.

**Business Question:**
> "At which stage of the funnel are we losing the most users, and what can we do about it?"

---

## 📊 Dashboard Features

- **4 KPI Cards** — Total Users, Signup Users, Login Users, Purchase Users
- **3 Conversion Rate Cards** — With conditional formatting (Green / Amber / Red)
- **Funnel Overview** — Visual drop-off at each stage (Blue → Orange → Green)
- **User Drop-Off By Stage** — Stacked bar chart showing absolute numbers
- **User Trend Over Time** — Line chart showing all 3 user types by month
- **Purchase By Device** — Mobile vs Desktop breakdown
- **Key Insights Text Box** — Written analysis of findings
- **Interactive Slicers** — Filter by Device and Date Range

---

## 🔍 Key Findings

| Metric | Value |
|--------|-------|
| Signup to Login conversion | **80.0%** ✅ |
| Login to Purchase conversion | **62.5%** ⚠️ |
| Overall funnel conversion | **50.0%** ⚠️ |
| Biggest drop-off stage | **Login → Purchase** |
| Users lost at purchase stage | **~37.5%** |

### Insights
- **80% of users login after signup** — Step 1 is strong, no action needed here
- **Only 62.5% convert from login to purchase** — This is the critical bottleneck
- **Mobile converts slightly higher than Desktop** — Mobile UX is performing better
- **Overall only 50% of signups complete the full funnel** — Significant revenue opportunity

---

## 💡 Business Recommendation

The biggest drop-off is between **Login and Purchase** — 37.5% of logged-in users never complete their purchase.

**Recommended actions:**
1. Implement one-click checkout to reduce friction
2. Send push notification / email to users who logged in but did not purchase within 24 hours
3. A/B test simplified 2-step checkout vs current flow
4. Prioritize mobile checkout experience as mobile converts better

**Projected impact:** Recovering 15% of dropped users = significant additional purchases per month

---

## 📈 Dashboard Screenshot

> *(Add your dashboard screenshot here after uploading)*
> 
> To add: Click **Edit** on GitHub → drag your screenshot image into this section

---

## 🗄️ SQL Query Used

```sql
SELECT
  user_id,
  MAX(CASE WHEN event_name = 'signup'   THEN 1 END) AS signup,
  MAX(CASE WHEN event_name = 'login'    THEN 1 END) AS login,
  MAX(CASE WHEN event_name = 'purchase' THEN 1 END) AS purchase
FROM events
GROUP BY user_id;
```

---

## 📐 DAX Measures Used

```dax
Signup to Login % = DIVIDE([Login Users], [Signup Users])

Login to Purchase % = DIVIDE([Purchase Users], [Login Users])

Overall Conversion % = DIVIDE([Purchase Users], [Signup Users])
```

---

## 👤 About

**Made by:** [Your Name]  
**Role applying for:** Data Analyst / Product Analyst  
**Tools:** Power BI · SQL · DAX  
**LinkedIn:** [Add your LinkedIn URL]

---

> ⭐ If you found this project useful, feel free to star the repository!
