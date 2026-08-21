USE HOTEL;

-- 모든 테이블 탐색하기
SELECT * FROM CONTACT;
SELECT * FROM DEPARTMENT;
SELECT * FROM EMPLOYEE;
SELECT * FROM CONCIERGE;
SELECT * FROM HOUSEKEEPING;
SELECT * FROM MASSAGE_THERAPIST;
SELECT * FROM VALET_DRIVER;
SELECT * FROM COOK;
SELECT * FROM GUEST;
SELECT * FROM PAYMENT;
SELECT * FROM FEEDBACK;
SELECT * FROM ROOM;
SELECT * FROM CAR;
SELECT * FROM `EVENT`;
SELECT * FROM INVENTORY;
SELECT * FROM BOOK;

# 로열티 포인트가 1000 포인트 넘는 고객 찾기
SELECT COUNT(*) AS `Number Loyal`,
	   
FROM GUEST
WHERE Loyalty_pts >= 1000;

SELECT *
FROM GUEST
WHERE Loyalty_pts >= 1000;

# 충성 고객 등급별로 몇명인지 파악하기
WITH LOYALTY AS(
	SELECT Guest_ID,
		   F_name,
		   L_name,
		   Loyalty_pts,
		   CASE
			WHEN 1000 <= Loyalty_pts AND  Loyalty_pts < 5000 THEN 'Silver'
			WHEN 5000 <= Loyalty_pts AND Loyalty_pts < 10000 THEN 'Gold'
			WHEN Loyalty_pts >= 10000 THEN 'Platinum'
            ELSE 'Basic'
		   END AS Loyalty_Grade
	FROM GUEST
)
SELECT Loyalty_Grade,
	   COUNT(*) AS COUNT
FROM LOYALTY
GROUP BY Loyalty_Grade;

# 충성고객을 등급별로 나눠보기
WITH LOYALTY AS(
    SELECT Guest_ID, F_name, L_name, Loyalty_pts,
        CASE
            WHEN Loyalty_pts >= 1000 AND Loyalty_pts < 5000 THEN 'Silver'
            WHEN Loyalty_pts >= 5000 AND Loyalty_pts < 10000 THEN 'Gold'
            WHEN Loyalty_pts >= 10000 THEN 'Platinum'
            ELSE 'Basic'
        END AS Loyalty_Grade
    FROM GUEST
),
ALL_GRADES AS (
    SELECT 'Basic' AS Loyalty_Grade
    UNION ALL SELECT 'Silver'
    UNION ALL SELECT 'Gold'
    UNION ALL SELECT 'Platinum'
)
SELECT
    G.Loyalty_Grade,
    COUNT(L.Guest_ID) AS COUNT
FROM ALL_GRADES G
LEFT JOIN LOYALTY L ON G.Loyalty_Grade = L.Loyalty_Grade
GROUP BY G.Loyalty_Grade
ORDER BY FIELD(G.Loyalty_Grade, 'Basic','Silver','Gold','Platinum');

-- 등급별 매출 기여도
WITH LOYALTY AS (
    SELECT Guest_ID,
        CASE
            WHEN Loyalty_pts >= 10000 THEN 'Platinum'
            WHEN Loyalty_pts >= 5000 THEN 'Gold'
            WHEN Loyalty_pts >= 1000 THEN 'Silver'
            ELSE 'Basic'
        END AS Loyalty_Grade
    FROM GUEST
)
SELECT
    L.Loyalty_Grade,
    COUNT(DISTINCT L.Guest_ID) AS Guest_Count,
    SUM(P.Payment_amt) AS Total_Revenue,
    ROUND(SUM(P.Payment_amt) / COUNT(DISTINCT L.Guest_ID), 2) AS Avg_Revenue_Per_Guest,
    ROUND(SUM(P.Payment_amt) * 100.0 / SUM(SUM(P.Payment_amt)) OVER(), 1) AS Pct_of_Total_Revenue
FROM LOYALTY L
INNER JOIN PAYMENT P ON L.Guest_ID = P.Payer_ID
GROUP BY L.Loyalty_Grade
ORDER BY Total_Revenue DESC;
-- **************************

-- 재방문 여부 기준 매출 격차
WITH visit_count AS (
    SELECT G_no, COUNT(Booking_ID) AS Total_Bookings
    FROM BOOK GROUP BY G_no
),
payment_sum AS (
    SELECT Payer_ID, SUM(Payment_amt) AS Total_Payment
    FROM PAYMENT GROUP BY Payer_ID
)
SELECT
    'Visit-based (Repeat vs One-time)' AS Segmentation_Method,
    CASE WHEN V.Total_Bookings > 1 THEN 'High Group' ELSE 'Low Group' END AS Segment,
    COUNT(DISTINCT V.G_no) AS Guest_Count,
    ROUND(AVG(COALESCE(P.Total_Payment,0)), 2) AS Avg_Revenue
FROM visit_count V
LEFT JOIN payment_sum P ON V.G_no = P.Payer_ID
GROUP BY Segment

UNION ALL

-- 로열티 등급 기준 매출 격차 (Silver 이상 vs Basic)
SELECT
    'Loyalty-based (Silver+ vs Basic)' AS Segmentation_Method,
    CASE WHEN G.Loyalty_pts >= 1000 THEN 'High Group' ELSE 'Low Group' END AS Segment,
    COUNT(DISTINCT G.Guest_ID) AS Guest_Count,
    ROUND(AVG(COALESCE(P.Total_Payment,0)), 2) AS Avg_Revenue
FROM GUEST G
LEFT JOIN payment_sum P ON G.Guest_ID = P.Payer_ID
GROUP BY Segment;



-- 호텔에 투숙객 중에서 가장 많은 소비를 한 투숙객 10명 찾기
WITH payment_sum AS (
    SELECT Payer_ID, SUM(Payment_amt) AS Payment_Revenue
    FROM PAYMENT
    GROUP BY Payer_ID
),
inventory_sum AS (
    SELECT B.G_no, SUM(I.Quantity * I.Price) AS Inventory_Revenue
    FROM BOOK B
    JOIN INVENTORY I ON B.Booking_ID = I.Booking_ID
    GROUP BY B.G_no
),
TOP_10 AS (SELECT G.Guest_ID AS Guest_ID,
				  G.F_name AS F_name,
				  G.L_name AS L_name,
                  COALESCE(P.Payment_Revenue, 0) + COALESCE(INV.Inventory_Revenue, 0) AS Total_Revenue,
				  RANK() OVER (ORDER BY COALESCE(P.Payment_Revenue, 0) + COALESCE(INV.Inventory_Revenue, 0) DESC) AS Revenue_Rank
			FROM GUEST G
			LEFT JOIN payment_sum P ON G.Guest_ID = P.Payer_ID
			LEFT JOIN inventory_sum INV ON G.Guest_ID = INV.G_no
			ORDER BY Total_Revenue DESC
			LIMIT 10
),
LOYALTY AS (
    SELECT Guest_ID,
        CASE
            WHEN Loyalty_pts >= 10000 THEN 'Platinum'
            WHEN Loyalty_pts >= 5000 THEN 'Gold'
            WHEN Loyalty_pts >= 1000 THEN 'Silver'
            ELSE 'Basic'
        END AS Loyalty_Grade
    FROM GUEST
)
SELECT *
FROM TOP_10
INNER JOIN LOYALTY ON TOP_10.Guest_ID = LOYALTY.Guest_ID

# 오늘 밤 호텔에서 머물고 있는 고객의 ID와 방 번호 찾기
SELECT G.Guest_ID AS Guest_ID,
	   B.Room_no AS Room_no
FROM GUEST AS G
LEFT JOIN BOOK AS B ON G.Guest_ID = B.G_no
WHERE B.Booking_Status LIKE 'CheckedIn';

# 오늘 밤에 비워져 있는 객실 중 가격이 $200 이하인 방 조회하기
WITH OCCUPIED AS (
	SELECT B.Room_no AS Room_no
	FROM GUEST AS G
	LEFT JOIN BOOK AS B ON G.Guest_ID = B.G_no
	WHERE B.Booking_Status LIKE 'CheckedIn'
    )
SELECT R.Room_no AS `VACANT ROOM`,
	   R.Daily_price
FROM ROOM AS R
LEFT JOIN OCCUPIED AS O on O.Room_no = R.Room_no
WHERE O.Room_no IS NULL AND R.Daily_price < 200;

-- 현재 점유(CheckedIn) 또는 예약(Reserved) 중인 객실 vs 공실 비교
WITH occupied_rooms AS (
    SELECT DISTINCT Room_no
    FROM BOOK
    WHERE Booking_Status IN ('CheckedIn', 'Reserved')
)
SELECT
    CASE WHEN O.Room_no IS NULL THEN 'Vacant' ELSE 'Occupied/Reserved' END AS Room_Status,
    COUNT(DISTINCT R.Room_no) AS Room_Count,
    ROUND(COUNT(DISTINCT R.Room_no) * 100.0 / SUM(COUNT(DISTINCT R.Room_no)) OVER(), 1) AS Pct_of_Total,
    ROUND(AVG(R.Daily_price), 2) AS Avg_Daily_Price
FROM ROOM R
LEFT JOIN occupied_rooms O ON R.Room_no = O.Room_no
GROUP BY Room_Status;


-- 재방문 고객이 있을까?
SELECT  G.Guest_ID AS Guest_ID,
        G.F_name AS F_name,
        G.L_name AS L_name,
    COUNT(B.Booking_ID) AS Total_Bookings,
    MIN(B.Start_date) AS First_Visit,
    MAX(B.Start_date) AS Last_Visit
FROM GUEST G
JOIN BOOK B ON G.Guest_ID = B.G_no
GROUP BY G.Guest_ID, G.F_name, G.L_name
HAVING COUNT(B.Booking_ID) > 1
ORDER BY Total_Bookings DESC;

-- 재방문 고객이 남김 피드잭이 존재할까?
WITH REVISIT AS (
	SELECT
		G.Guest_ID AS Guest_ID,
        G.F_name AS F_name,
        G.L_name AS L_name,
		COUNT(B.Booking_ID) AS Total_Bookings,
		MIN(B.Start_date) AS First_Visit,
		MAX(B.Start_date) AS Last_Visit
	FROM GUEST G
	JOIN BOOK B ON G.Guest_ID = B.G_no
	GROUP BY G.Guest_ID, G.F_name, G.L_name
	HAVING COUNT(B.Booking_ID) > 1
	ORDER BY Total_Bookings DESC
)
SELECT F.Feed_Comment AS Feed_Comment,
	   F.Guest_ID AS Guest_ID
FROM REVISIT AS R
INNER JOIN FEEDBACK AS F ON R.Guest_ID = F.Guest_ID;

-- 부서별 직원들 임금 합계와 부서 예산대비 초과율 분석하기
SELECT D.D_name,
	   D.Budget,
       SUM(E.Salary) AS Total_Salary_Cost,
       ROUND(SUM(E.Salary) / D.Budget * 100, 2) AS Salary_Pct_of_Budget,
       COUNT(E.Employee_ID) AS Headcount,
       ROUND(SUM(E.Salary) / COUNT(E.Employee_ID), 2) AS Avg_Salary_Per_Employee
FROM DEPARTMENT D
JOIN EMPLOYEE E ON D.D_no = E.Dno
GROUP BY D.D_name, D.Budget
ORDER BY Salary_Pct_of_Budget DESC;


-- 오늘 공실과 예약된 방 수 비교하기
SELECT CASE 
		WHEN B.Room_no IS NULL THEN 'Vacant' ELSE 'Occupied/Reserved' END 
	   AS Room_Status,
       COUNT(DISTINCT R.Room_no) AS Room_Count,
       ROUND(AVG(R.Daily_price), 2) AS Avg_Daily_Price
FROM ROOM AS R
LEFT JOIN (
    SELECT DISTINCT Room_no 
    FROM BOOK 
    WHERE Booking_Status IN ('CheckedIn','Reserved')
) AS B ON R.Room_no = B.Room_no
GROUP BY Room_Status;

-- 객실 등급별 예약 값 확인하기
SELECT
    CASE
        WHEN R.Daily_price < 150 THEN 'Budget (<$150)'
        WHEN R.Daily_price < 250 THEN 'Standard ($150-250)'
        ELSE 'Premium ($250+)'
    END AS Price_Tier,
    COUNT(B.Booking_ID) AS Booking_Count,
    ROUND(AVG(R.Daily_price), 2) AS Avg_Price_In_Tier
FROM ROOM R
JOIN BOOK B ON R.Room_no = B.Room_no
GROUP BY Price_Tier
ORDER BY Avg_Price_In_Tier ASC;

-- 재방문 고객 수와 이용 지출 파악
WITH visit_count AS (
    SELECT G_no, COUNT(Booking_ID) AS Total_Bookings
    FROM BOOK
    GROUP BY G_no
),
payment_sum AS (
    SELECT Payer_ID, SUM(Payment_amt) AS Total_Payment
    FROM PAYMENT
    GROUP BY Payer_ID
)
SELECT
    CASE WHEN V.Total_Bookings > 1 THEN 'Repeat Guest' ELSE 'One-time Guest' END AS Guest_Type,
    COUNT(DISTINCT V.G_no) AS Guest_Count,
    ROUND(COUNT(DISTINCT V.G_no) * 100.0 / SUM(COUNT(DISTINCT V.G_no)) OVER(), 1) AS Pct_of_Guests,
    SUM(COALESCE(P.Total_Payment, 0)) AS Total_Revenue,
    ROUND(SUM(COALESCE(P.Total_Payment, 0)) * 100.0 / SUM(SUM(COALESCE(P.Total_Payment, 0))) OVER(), 1) AS Pct_of_Revenue
FROM visit_count V
LEFT JOIN payment_sum P ON V.G_no = P.Payer_ID
GROUP BY Guest_Type;
