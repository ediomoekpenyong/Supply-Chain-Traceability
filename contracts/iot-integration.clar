;; IoT Integration Contract

(define-map iot-data
  { mineral-id: uint, device-id: (string-ascii 50), timestamp: uint }
  {
    location: (string-ascii 100),
    temperature: int,
    humidity: uint,
    additional-data: (optional (string-utf8 500))
  }
)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u403))

(define-public (record-iot-data (mineral-id uint) (device-id (string-ascii 50)) (location (string-ascii 100)) (temperature int) (humidity uint) (additional-data (optional (string-utf8 500))))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (ok (map-set iot-data
      { mineral-id: mineral-id, device-id: device-id, timestamp: block-height }
      {
        location: location,
        temperature: temperature,
        humidity: humidity,
        additional-data: additional-data
      }
    ))
  )
)

(define-read-only (get-iot-data (mineral-id uint) (device-id (string-ascii 50)) (timestamp uint))
  (map-get? iot-data { mineral-id: mineral-id, device-id: device-id, timestamp: timestamp })
)

(define-read-only (get-latest-iot-data (mineral-id uint) (device-id (string-ascii 50)))
  (get-iot-data mineral-id device-id block-height)
)

