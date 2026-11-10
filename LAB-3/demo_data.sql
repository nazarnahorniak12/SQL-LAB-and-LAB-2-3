-- Синтетичні дані; виконати після telecom_operator.sql у порожніх таблицях.
USE telecom_operator;
START TRANSACTION;
INSERT INTO subscriber VALUES (1,'Тестова абонентка','+380501234567',NULL,'2026-01-01');
INSERT INTO tariff VALUES (1,'Оптичний 100',300,100,1);
INSERT INTO contract VALUES (1,1,1,'TEST-001','Львів, тестова адреса','2026-01-01',NULL,'active');
INSERT INTO service VALUES (1,'Статична IP',50,'Додаткова адреса');
INSERT INTO contract_service VALUES (1,1,1,'2026-01-01',NULL);
INSERT INTO payment VALUES (1,1,'2026-01-02 12:00:00',300,'card','TEST-PAY-001');
INSERT INTO support_ticket VALUES (1,1,'2026-01-03 12:00:00','Перевірка','Тестовий запит','open',NULL);
COMMIT;
