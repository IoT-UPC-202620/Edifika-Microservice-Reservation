-- Datos de prueba locales (solo corre con SEED_MODE=always). Idempotente.
-- resident_id = IDs de usuario de IAM (2..5). La puerta IoT esp32-gym-01 controla el Gimnasio (id 3).

INSERT INTO common_areas (id, created_at, updated_at, booking_type, max_capacity, name, status, type) VALUES
  (1, now(), now(), 'SHARED',    30, 'Piscina',          'AVAILABLE',   'POOL'),
  (2, now(), now(), 'EXCLUSIVE', 50, 'Salon de fiestas', 'AVAILABLE',   'PARTY_ROOM'),
  (3, now(), now(), 'SHARED',    15, 'Gimnasio',         'AVAILABLE',   'GYM'),
  (4, now(), now(), 'EXCLUSIVE', 20, 'Zona BBQ',         'MAINTENANCE', 'BBQ_AREA')
ON CONFLICT DO NOTHING;

INSERT INTO common_area_rules (id, allow_cancellation, guarantee_amount, max_reservation_hours, penalty_amount, penalty_hours_before, price, requires_approval, requires_guarantee, requires_payment, common_area_id) VALUES
  (1, true,    0.00, 2,  0.00, 0,   0.00, false, false, false, 1),
  (2, true,  200.00, 6, 50.00, 48, 150.00, true,  true,  true,  2),
  (3, true,    0.00, 1,  0.00, 0,   0.00, false, false, false, 3),
  (4, true,  100.00, 4, 30.00, 24, 80.00, true,  true,  true,  4)
ON CONFLICT DO NOTHING;

INSERT INTO reservations (id, created_at, updated_at, number_of_guests, penalty_applied, qr_code_access, reservation_date, resident_id, status, time_slot, common_area_id) VALUES
  (1, now(), now(), 25, false, 'QR-SEED-0001', CURRENT_DATE + 2, 3, 'ACTIVE',    18, 2),
  (2, now(), now(),  1, false, 'QR-SEED-0002', CURRENT_DATE + 1, 4, 'ACTIVE',     7, 3),
  (3, now(), now(),  4, false, 'QR-SEED-0003', CURRENT_DATE - 3, 5, 'ACTIVE',    10, 1),
  (4, now(), now(), 10, false, 'QR-SEED-0004', CURRENT_DATE + 5, 2, 'CANCELLED', 20, 2),
  (5, now(), now(),  2, false, 'QR-SEED-0005', CURRENT_DATE,     2, 'ACTIVE',    19, 3)
ON CONFLICT DO NOTHING;

SELECT setval(pg_get_serial_sequence('common_areas', 'id'), (SELECT MAX(id) FROM common_areas));
SELECT setval(pg_get_serial_sequence('common_area_rules', 'id'), (SELECT MAX(id) FROM common_area_rules));
SELECT setval(pg_get_serial_sequence('reservations', 'id'), (SELECT MAX(id) FROM reservations));
