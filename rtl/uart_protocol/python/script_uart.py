import serial
import time

port = 'COM3'
baudrate = 9600
timeout = 1

try:
    ser = serial.Serial(port, baudrate, timeout=timeout)
    time.sleep(0.05)


    payload = [
        bytes([0x13, 0x05, 0x00, 0x00]),
        bytes([0x93, 0x05, 0x10, 0x00]),
        bytes([0x13, 0x06, 0xf0, 0x00]),   #  ← AQUÍ VAN TUS DOS BYTES /// 0xf0 is LSB [3:0], and 0x0F is MSB [7:4]
        bytes([0x63, 0x0C, 0x06, 0x00]),
        bytes([0xB3, 0x02, 0xB5, 0x00]),
        bytes([0x13, 0x85, 0x05, 0x00]),
        bytes([0x93, 0x85, 0x02, 0x00]),
        bytes([0x13, 0x06, 0xF6, 0xFF]),
        bytes([0x6F, 0xF0, 0xDF, 0xFE]),
        bytes([0x6F, 0x00, 0x00, 0x00])
    ]

    # Enviar número de instrucciones
    n_instr = b'\x0A'
    ser.write(n_instr)
    print(f"Sent: {n_instr}")
    time.sleep(0.005)

    for frame in payload:
        ser.write(frame)
        print(f"Sent: {frame}")
        time.sleep(0.005)

    ser.close()
    print("Serial port closed.")
    time.sleep(0.5)

except Exception as e:
    print("ERROR:", e)
