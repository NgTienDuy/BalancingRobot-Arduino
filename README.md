# Robot Hai Bánh Tự Cân Bằng (Con Lắc Ngược)

Firmware điều khiển **register-level** trên **ATmega328P (Arduino Uno / Seeeduino Lotus, 16 MHz)**, biên dịch và nạp bằng **CodeVisionAVR**. Robot tự giữ thăng bằng trên hai bánh nhờ cảm biến IMU MPU‑6050, bộ lọc bù (complementary filter) và bộ điều khiển PID, truyền động qua mạch cầu H L298N.

> Toàn bộ ngoại vi (TWI/I²C, UART, các Timer, PWM) đều được lập trình **trực tiếp ở mức thanh ghi**, không dùng thư viện trừu tượng của Arduino — đúng tinh thần môn Lập trình hệ thống nhúng.

---

## 1. Tính năng

- Đọc gia tốc kế + con quay hồi chuyển MPU‑6050/6500 qua **TWI phần cứng** (TWBR/TWCR/TWSR/TWDR).
- Ước lượng góc nghiêng bằng **bộ lọc bù** (gyro + accelerometer).
- Điều khiển **PID** (anti‑windup, đạo hàm trên giá trị đo, lọc đạo hàm).
- **PWM 20 kHz** điều khiển hai động cơ qua L298N (Timer1, Fast PWM mode 14).
- Vòng điều khiển **100 Hz** chính xác bằng **Timer2 CTC**.
- **Hiệu chỉnh bias con quay** lúc khởi động; **ngắt an toàn** khi nghiêng quá ngưỡng.
- **Telemetry UART dạng CSV** + **hiệu chỉnh tham số trực tiếp (live‑tune)** qua cổng Serial, không cần nạp lại.
- **Chống treo bus I²C**: timeout + phục hồi bus (chống nhiễu/sụt áp từ động cơ).
- Toán học **số nguyên (fixed‑point)** — không dùng dấu phẩy động, gọn nhẹ.

---

## 2. Phần cứng

### 2.1. Linh kiện

| Khối | Linh kiện |
|---|---|
| Vi điều khiển | ATmega328P (Arduino Uno / Seeeduino Lotus), thạch anh 16 MHz |
| Cảm biến | MPU‑6050 / GY‑521 (±2 g, ±250 °/s) |
| Driver động cơ | L298N (cầu H đôi) |
| Động cơ | 2 × DC giảm tốc |
| Nguồn | 2 × pin 18650 nối tiếp (~7.4 V) |

### 2.2. Sơ đồ chân (đúng đấu nối thực tế)

| Chức năng | Chân ATmega | Chân Arduino | Nối tới |
|---|---|---|---|
| I²C SDA | PC4 | A4 | MPU SDA |
| I²C SCL | PC5 | A5 | MPU SCL |
| PWM ENA (động cơ TRÁI) | PB1 / OC1A | D9 | L298 ENA |
| PWM ENB (động cơ PHẢI) | PB2 / OC1B | D10 | L298 ENB |
| Chiều IN1 (TRÁI) | PD2 | D2 | L298 IN1 |
| Chiều IN2 (TRÁI) | PD4 | D4 | L298 IN2 |
| Chiều IN3 (PHẢI) | PD7 | D7 | L298 IN3 |
| Chiều IN4 (PHẢI) | PB0 | D8 | L298 IN4 |
| UART TX (telemetry) | PD1 | D1 | USB‑Serial trên board |
| LED trạng thái | PB5 | D13 | LED on‑board |

**Nguồn & mass:** pin 7.4 V → L298 `+12V` và Arduino `VIN`; **GND chung một điểm** giữa pin – L298 – Arduino. Đã **tháo jumper ENA/ENB** của L298 (để PWM điều khiển được tốc độ); **giữ jumper 5V** của module.

### 2.3. Lưu ý lắp đặt (chống nhiễu)

- Tụ **100 nF** sát chân nguồn MPU và chân nguồn logic L298; tụ hóa **470–1000 µF** ở nguồn động cơ (+12 V/GND).
- Dây **SDA/SCL ngắn**, tách xa dây công suất động cơ.
- MPU đặt **nằm ngang, mặt lên trên**, cạnh dài song song trục nối hai bánh.

---

## 3. Cấu trúc mã nguồn

| File | Vai trò |
|---|---|
| `config.h` | Tập trung **toàn bộ** cấu hình: chân, clock, hệ số PID, dấu trục cảm biến, deadband, giới hạn an toàn. |
| `myi2c.h/.c` | Driver **TWI phần cứng** (register-level) + timeout + phục hồi bus. |
| `uart.h/.c` | USART0 register-level (38400 8N1), in số nguyên không dùng `printf`. |
| `mpu6050.h/.c` | Khởi tạo, đọc IMU, hiệu chỉnh bias, tính góc accel + tốc độ góc. |
| `filter.h/.c` | Bộ lọc bù (complementary filter). |
| `motor.h/.c` | PWM Timer1 + điều chiều + deadband riêng từng động cơ. |
| `pid.h/.c` | Bộ điều khiển PID số nguyên. |
| `Self_Balancing_Rover.c` | `main`: khởi tạo, Timer2 ISR, vòng điều khiển, telemetry, parser live‑tune. |

---

## 4. Nguyên lý hoạt động

Mỗi 10 ms (Timer2 CTC, 100 Hz), firmware thực hiện:

```
Đọc MPU6050  →  Lọc bù góc  →  PID  →  PWM động cơ  (+ kiểm tra an toàn)
```

### 4.1. Ước lượng góc

- **Góc từ gia tốc kế:** xấp xỉ số nguyên `góc ≈ (ax / az) × 5730` (đơn vị centi‑độ; chính xác ở góc nhỏ quanh điểm cân bằng). Vì khi đứng `az` âm, code dùng `−az` để góc đọc ≈ 0° lúc thẳng đứng.
- **Tốc độ góc từ con quay:** `(gy − bias) / 131` (°/s), đã trừ bias đo lúc khởi động.
- **Bộ lọc bù:** kết hợp ưu điểm hai cảm biến (con quay nhạy/ít trễ ngắn hạn, gia tốc kế ổn định dài hạn):

  ```
  góc = α·(góc + Δgóc_gyro) + (1−α)·góc_accel ,   α = 251/256 ≈ 0.98
  ```

### 4.2. Bộ điều khiển PID

```
e = setpoint − góc
output = Kp·e + Ki·∫e dt + Kd·d(góc)/dt
```

- **Anti‑windup**: kẹp tích phân trong giới hạn.
- **Đạo hàm trên giá trị đo** (tránh "derivative kick") + lọc thông thấp.
- Ngõ ra giới hạn `±799` (= độ phân giải PWM).

### 4.3. Truyền động & deadband

PWM 20 kHz qua Timer1 (mode 14, `ICR1 = 799`). Vì L298 sụt áp lớn, động cơ chỉ quay khi duty cao; firmware bù bằng **deadband riêng từng động cơ** và ánh xạ tỉ lệ: `|output| 0..799 → deadband..799`.

### 4.4. An toàn

`|góc| > 40°` → dừng động cơ + reset PID. Mất tín hiệu I²C liên tục → dừng động cơ, phục hồi bus, khởi tạo lại MPU.

---

## 5. Biên dịch & nạp bằng CodeVisionAVR

1. **Tạo project**: `File → New → Project`, chọn **No** ở CodeWizard (mã viết tay).
2. **Thêm file**: `Project → Configure → Files` → thêm 7 file `.c`:
   `Self_Balancing_Rover.c, myi2c.c, uart.c, mpu6050.c, filter.c, motor.c, pid.c`.
3. **C Compiler**: Chip = `ATmega328P`, **Clock = 16.000000 MHz**, Memory model = Small, Optimize for = Size, `(s)printf/(s)scanf features = None`.
4. **Build**: `Project → Build All` (Shift+F9).
5. **Nạp** (tab `After Build`): Action = **Upload to Arduino**, Board = Arduino Uno, Protocol = Optiboot, COM port tương ứng, Baud 115200, Verify = on. Mỗi lần Build All sẽ tự nạp.
   - *Đóng Serial Monitor trước khi nạp* (tránh chiếm cổng COM). Không chỉnh fuse.

---

## 6. Telemetry & hiệu chỉnh (live‑tune)

Mở Serial **38400 8N1**. Sau khi nạp sẽ thấy: `B` → `ID=112` → `CAL` (giữ xe yên ~2 s) → `RUN` → các dòng telemetry.

**Định dạng telemetry CSV** mỗi chu kỳ: `<ms>,<góc_centiđộ>,<output>` (ví dụ `12300,382,-590` = 12.30 s, 3.82°, output −590).

**Lệnh hiệu chỉnh trực tiếp** (gõ rồi Enter, không cần nạp lại):

| Lệnh | Ý nghĩa |
|---|---|
| `P n` | Kp = n/10 |
| `I n` | Ki = n/10 |
| `D n` | Kd = n/10 |
| `S n` | setpoint = n/10 (độ) |
| `L n` | deadband động cơ trái |
| `R n` | deadband động cơ phải |
| `T n` | chạy thử cả hai động cơ ở duty n cố định (đo ngưỡng; 0 = tắt) |
| `?` | in tham số hiện tại (`#Kp,Ki,Kd,Sp,DL,DR`) |

### Vẽ đồ thị kết quả

Ghi telemetry ra file `*.csv` (terminal.exe → StreamLog), rồi:

```bash
pip install matplotlib numpy
python plot_ketqua.py log.csv                       # 1 đồ thị + biên độ/RMS/thời gian xác lập
python plot_ketqua.py kp150.csv kp250.csv kp350.csv # vẽ chồng so sánh các bộ PID
```

---

## 7. Quy trình bring‑up & hiệu chỉnh

1. **Kê bánh lên.** Kiểm tra góc: đứng thẳng `góc ≈ 0`; nghiêng trước → góc dương rõ ràng.
2. **Chiều điều khiển:** nghiêng xe về trước, bánh phải quay theo hướng "chạy tới đỡ cú ngã". Sai → đặt `OUTPUT_SIGN = -1`. Nếu hai bánh quay ngược nhau → đảo 2 dây OUT của một động cơ.
3. **Deadband:** dùng `T` để tìm duty tối thiểu mỗi bánh bắt đầu quay, đặt `L`/`R` tương ứng.
4. **Tune PD:** tăng `Kp` tới khi xe "chống" lại tay; thêm `Kd` dập dao động; tìm `setpoint` bằng `S`.
5. **Thêm Ki nhỏ** khử trôi chậm. Ghi bộ số tốt vào `config.h` rồi Build All để lưu cứng.

> Khi tune: giữ cáp USB chùng/treo cao để không kéo xe; động cơ chạy bằng pin, GND chung. Có thể gắn HC‑05 để hiệu chỉnh không dây.

---

## 8. Kết quả

Đồ thị góc–thời gian từ `plot_ketqua.py` thể hiện:

- **Đứng yên:** dao động nhỏ quanh 0° (đo biên độ ± và RMS).
- **Đáp ứng nhiễu:** đẩy nhẹ rồi thả → đỉnh lệch + dao động tắt dần về 0° (đo góc lệch lớn nhất, thời gian xác lập).
- **So sánh PID:** Kp thấp → đổ; Kp cao → dao động; thêm Kd → dập rung — minh chứng cho phần hiệu chỉnh.

---

## 9. Hạn chế & hướng phát triển

- **L298N** sụt áp lớn → vùng điều khiển hẹp, đáp ứng thô ở tốc độ thấp. Nâng cấp **TB6612FNG/DRV8833** cho mượt hơn.
- Thêm **encoder** + vòng điều khiển vị trí/tốc độ để xe không trôi.
- Thay lọc bù bằng **Kalman** để ước lượng góc tốt hơn.
- Khung cứng hơn, trọng tâm hợp lý để giảm rung cảm biến.

---

## 10. Tham số mặc định (trong `config.h`)

| Tham số | Giá trị khởi đầu |
|---|---|
| Tần số vòng điều khiển | 100 Hz |
| Tần số PWM | 20 kHz |
| Lọc bù α | 251/256 ≈ 0.98 |
| Kp, Ki, Kd | 15.0, 0.0, 0.6 |
| Ngưỡng ngã | 40° |
| Baud UART | 38400 |
