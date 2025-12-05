import serial
import time

port = 'COM3'
baudrate = 9600
timeout = 1

try:
    ser = serial.Serial(port, baudrate, timeout=timeout)
    print(f"Serial port {port} opened successfully.")

    time.sleep(0.05)

    # Instrucciones para la serie fibonacci
    payload = [
        b'\x93\x04\x00\x00',
        b'\x93\x05\x00\x10',
        b'\x93\x06\x00\x0A',
        b'\x63\x0C\x06\x00',
        b'\xB3\x0A\x00\x0B',
        b'\xB3\x05\x00\x0B',
        b'\xB3\x05\x00\x05',
        b'\x93\x06\x00\xF6',
        b'\x6F\x00\xFF\xDD',
        b'\x6F\x00\x00\x00'
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

except Exception as e:
    print("ERROR:", e)
