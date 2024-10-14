//get event date, event name, page url, session_id, user_id

  SELECT
  event_date,
  event_name,
  CONCAT(
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = "ga_session_id"), 
    "_", 
    user_pseudo_id
  ) AS session_id,
  user_pseudo_id AS user_id,
  (SELECT value.string_value FROM UNNEST(event_params) WHERE key = "page_location") AS page_url
FROM
  `calendow.analytics_340229049.events_*`


--------------------------------------------------------------
  
SELECT
  event_date,
  page_url,  
  COUNT(DISTINCT session_id) AS sessions,
  COUNT(DISTINCT user_id) AS users,
  SUM(
  IF
    (event_name = "page_view", 1, 0)) AS page_views,
  SUM(
  IF
    (event_name = "view_item", 1, 0)) AS view_item,
  SUM(
  IF
    (event_name = "purchase", 1, 0)) AS purchases
FROM
  `calendow.analytics_340229049.daily_event_session_id`
GROUP BY
  event_date,
  page_url
order by sessions desc

----- 
//To change the format of event_date
-----  
  
SELECT
  PARSE_DATE('%Y%m%d', event_date) AS event_date,
  page_url,  
  COUNT(DISTINCT session_id) AS sessions,
  COUNT(DISTINCT user_id) AS users,
  SUM(
  IF
    (event_name = "page_view", 1, 0)) AS page_views,
  SUM(
  IF
    (event_name = "view_item", 1, 0)) AS view_item,
  SUM(
  IF
    (event_name = "purchase", 1, 0)) AS purchases
FROM
  `calendow.analytics_340229049.daily_event_session_id`
GROUP BY
  event_date,
  page_url
order by event_date desc


--------------------------------------------------

SELECT
  PARSE_DATE('%Y%m%d', event_date) AS event_date,
  (SELECT value.string_value FROM UNNEST(event_params) WHERE key = "page_location") AS page_url,
  COUNT(DISTINCT CONCAT(
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = "ga_session_id"),
    "_",
    user_pseudo_id
  )) AS sessions
FROM
  `calendow.analytics_340229049.events_*`
WHERE
  event_name = 'page_view'  -- Filter for page view events
  AND PARSE_DATE('%Y%m%d', event_date) BETWEEN '2024-09-01' AND '2024-09-30'
GROUP BY
  event_date,
  page_url
ORDER BY
  event_date,
  sessions DESC
