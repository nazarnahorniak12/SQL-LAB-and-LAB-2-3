USE telecom_operator;
-- 1. Активні договори абонентів.
SELECT s.full_name, c.contract_number, c.service_address, t.tariff_name
FROM subscriber s JOIN contract c ON c.subscriber_id=s.subscriber_id
JOIN tariff t ON t.tariff_id=c.tariff_id WHERE c.status='active';
-- 2. Поточні послуги договорів (дата завершення виключна).
SELECT c.contract_number, s.service_name, s.monthly_fee
FROM contract_service cs JOIN contract c ON c.contract_id=cs.contract_id
JOIN service s ON s.service_id=cs.service_id
WHERE cs.activated_on<=CURRENT_DATE AND (cs.deactivated_on IS NULL OR cs.deactivated_on>CURRENT_DATE);
-- 3. Платежі за календарний 2026 рік, включаючи договори без платежів.
SELECT c.contract_number, COALESCE(SUM(p.amount),0) AS paid_uah
FROM contract c LEFT JOIN payment p ON p.contract_id=c.contract_id
AND p.paid_at>='2026-01-01' AND p.paid_at<'2027-01-01'
GROUP BY c.contract_id,c.contract_number;
-- 4. Невирішені звернення.
SELECT c.contract_number, st.subject, st.status, st.opened_at
FROM support_ticket st JOIN contract c ON c.contract_id=st.contract_id
WHERE st.status IN ('open','in_progress') ORDER BY st.opened_at;
