/* =====================================================
   USER FUNNEL ANALYTICS PROJECT
   Dataset: user_events
   Tools Used: MySQL, Power BI

   Project Objectives:
   - Analyze user funnel behavior
   - Measure conversion rates
   - Identify drop-off stages
   - Perform behavioral analytics
   - Analyze device-wise performance
   - Apply CTEs and Window Functions

   ===================================================== */


/* =====================================================
   1. Funnel Metrics
   Objective:
   Calculate total signup, login, and purchase users.
   ===================================================== */

SELECT
COUNT(DISTINCT CASE WHEN event_name='signup' THEN user_id END) AS signup_users,
COUNT(DISTINCT CASE WHEN event_name='login' THEN user_id END) AS login_users,
COUNT(DISTINCT CASE WHEN event_name='purchase' THEN user_id END) AS purchase_users
FROM user_events;


/* =====================================================
   2. Signup to Login Conversion Rate
   Objective:
   Measure percentage of users who logged in after signup.
   ===================================================== */

SELECT
ROUND(
COUNT(DISTINCT CASE WHEN event_name='login' THEN user_id END) * 100.0 /
COUNT(DISTINCT CASE WHEN event_name='signup' THEN user_id END),
2
) AS signup_to_login_conversion
FROM user_events;


/* =====================================================
   3. Login to Purchase Conversion Rate
   Objective:
   Measure percentage of logged-in users who completed purchase.
   ===================================================== */

SELECT
ROUND(
COUNT(DISTINCT CASE WHEN event_name='purchase' THEN user_id END) * 100.0 /
COUNT(DISTINCT CASE WHEN event_name='login' THEN user_id END),
2
) AS login_to_purchase_conversion
FROM user_events;


/* =====================================================
   4. Overall Funnel Conversion Rate
   Objective:
   Measure percentage of signup users who completed purchase.
   ===================================================== */

SELECT
ROUND(
COUNT(DISTINCT CASE WHEN event_name='purchase' THEN user_id END) * 100.0 /
COUNT(DISTINCT CASE WHEN event_name='signup' THEN user_id END),
2
) AS overall_conversion_rate
FROM user_events;


/* =====================================================
   5. Users Logged In But Did Not Purchase
   Objective:
   Identify users who dropped before purchase stage.
   ===================================================== */

SELECT user_id
FROM user_events
GROUP BY user_id
HAVING
SUM(CASE WHEN event_name='login' THEN 1 ELSE 0 END) > 0
AND
SUM(CASE WHEN event_name='purchase' THEN 1 ELSE 0 END) = 0;


/* =====================================================
   6. Users Signed Up But Never Logged In
   Objective:
   Identify users who abandoned after signup stage.
   ===================================================== */

SELECT user_id
FROM user_events
GROUP BY user_id
HAVING
SUM(CASE WHEN event_name='signup' THEN 1 ELSE 0 END) > 0
AND
SUM(CASE WHEN event_name='login' THEN 1 ELSE 0 END) = 0;


/* =====================================================
   7. Device-wise Conversion Analysis
   Objective:
   Compare conversion rates across devices.
   ===================================================== */

SELECT
device,

COUNT(DISTINCT CASE
WHEN event_name='signup'
THEN user_id
END) AS signup_users,

COUNT(DISTINCT CASE
WHEN event_name='purchase'
THEN user_id
END) AS purchase_users,

ROUND(
COUNT(DISTINCT CASE
WHEN event_name='purchase'
THEN user_id
END) * 100.0 /

COUNT(DISTINCT CASE
WHEN event_name='signup'
THEN user_id
END),
2
) AS conversion_rate

FROM user_events
GROUP BY device;


/* =====================================================
   8. Daily Signup Trend Analysis
   Objective:
   Analyze signup activity trends over time.
   ===================================================== */

SELECT
DATE(event_time) AS signup_day,
COUNT(DISTINCT user_id) AS total_signups
FROM user_events
WHERE event_name='signup'
GROUP BY signup_day
ORDER BY signup_day;


/* =====================================================
   9. Average Time to Purchase
   Objective:
   Measure time taken by users to complete purchase
   after signup.
   ===================================================== */

SELECT
s.user_id,

TIMESTAMPDIFF(
MINUTE,
s.event_time,
p.event_time
) AS minutes_to_purchase

FROM user_events s
JOIN user_events p
ON s.user_id = p.user_id

WHERE s.event_name='signup'
AND p.event_name='purchase';


/* =====================================================
   10. Repeat Login Behavior
   Objective:
   Identify users with multiple login activities.
   ===================================================== */

SELECT
user_id,
COUNT(*) AS total_logins
FROM user_events
WHERE event_name='login'
GROUP BY user_id
HAVING COUNT(*) > 1;


/* =====================================================
   11. Rank Top Active Users
   Objective:
   Rank users based on login frequency using
   window functions.
   ===================================================== */

WITH user_login_counts AS (

    SELECT
        user_id,
        COUNT(*) AS total_logins

    FROM user_events

    WHERE event_name = 'login'

    GROUP BY user_id
)

SELECT
user_id,
total_logins,

RANK() OVER (
ORDER BY total_logins DESC
) AS login_rank

FROM user_login_counts;


/* =====================================================
   12. Running Total of Daily Signups
   Objective:
   Track cumulative signup growth over time.
   ===================================================== */

WITH daily_signups AS (

    SELECT
        DATE(event_time) AS signup_day,

        COUNT(DISTINCT user_id) AS total_signups

    FROM user_events

    WHERE event_name = 'signup'

    GROUP BY signup_day
)

SELECT
signup_day,
total_signups,

SUM(total_signups) OVER (
ORDER BY signup_day
) AS running_total_signups

FROM daily_signups;


/* =====================================================
   13. Rank Days by Purchase Activity
   Objective:
   Identify top-performing purchase days.
   ===================================================== */

WITH daily_purchases AS (

    SELECT
        DATE(event_time) AS purchase_day,

        COUNT(DISTINCT user_id) AS purchase_users

    FROM user_events

    WHERE event_name = 'purchase'

    GROUP BY purchase_day
)

SELECT
purchase_day,
purchase_users,

DENSE_RANK() OVER (
ORDER BY purchase_users DESC
) AS purchase_rank

FROM daily_purchases;


/* =====================================================
   14. Device-wise Conversion Ranking
   Objective:
   Rank devices based on conversion performance.
   ===================================================== */

WITH device_conversion AS (

    SELECT
        device,

        COUNT(DISTINCT CASE
            WHEN event_name = 'signup'
            THEN user_id
        END) AS signup_users,

        COUNT(DISTINCT CASE
            WHEN event_name = 'purchase'
            THEN user_id
        END) AS purchase_users

    FROM user_events

    GROUP BY device
)

SELECT
device,
signup_users,
purchase_users,

ROUND(
purchase_users * 100.0 /
signup_users,
2
) AS conversion_rate,

RANK() OVER (
ORDER BY
purchase_users * 100.0 /
signup_users DESC
) AS device_rank

FROM device_conversion;


/* =====================================================
   15. Most Valuable Users Analysis
   Objective:
   Identify highly engaged and valuable users
   based on login and purchase activity.
   ===================================================== */

WITH user_activity AS (

    SELECT
        user_id,

        SUM(CASE
            WHEN event_name = 'login'
            THEN 1 ELSE 0
        END) AS total_logins,

        SUM(CASE
            WHEN event_name = 'purchase'
            THEN 1 ELSE 0
        END) AS total_purchases

    FROM user_events

    GROUP BY user_id
)

SELECT
user_id,
total_logins,
total_purchases,

RANK() OVER (
ORDER BY
total_purchases DESC,
total_logins DESC
) AS valuable_user_rank

FROM user_activity;